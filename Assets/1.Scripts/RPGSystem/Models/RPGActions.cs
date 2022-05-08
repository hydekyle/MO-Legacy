using System;
using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

public enum RPGActionType
{
    SetVariables,
    ShowText,
    PlaySE,
    Wait,
    DOTween,
    Script,
    AddItem,
    TeleportPlayer,
    ConditionalBranch,
    ShowCanvas,
    FlashScreen
}

#region Action_Classes
[Serializable]
public class RPGActionFlashScreen
{
    public Color flashColor;
    public float duration;
    public bool waitToEnd;

    public async UniTask Resolve()
    {
        var flashScreen = GameManager.refMap.flashScreen;
        var initTime = Time.time;
        flashScreen.color = flashColor;
        do
        {
            var t = (Time.time - initTime) / duration;
            flashScreen.color = new Color(flashColor.r, flashColor.g, flashColor.b, 1 - t);
            await UniTask.Yield();
        }
        while (initTime + duration >= Time.time);
        flashScreen.color = new Color(0, 0, 0, 0);
    }
}

[Serializable]
public class RPGActionShowCanvas
{
    [ValueDropdown("UIGetCanvasList")]
    public Transform canvasT;
    public bool isVisible;

    public void Resolve()
    {
        canvasT.gameObject.SetActive(isVisible);
    }

    IEnumerable UIGetCanvasList()
    {
        foreach (Transform child in GameObject.Find("Canvas").transform)
            yield return child;
    }
}

[Serializable]
public class RPGActionCheckConditions
{
    public VariableTable conditionList;
    public RPGAction[] onTrue, onFalse;

    public async UniTask Resolve()
    {
        if (conditionList.IsAllConditionOK())
            foreach (var action in onTrue) await action.Resolve();
        else
            foreach (var action in onFalse) await action.Resolve();
    }
}

[Serializable]
public class RPGActionShowText
{
    public string text;
    public void Resolve()
    {
        Debug.Log(text);
    }
}

[Serializable]
public class RPGActionScript
{
    public UnityEvent unityEvent;
    public void Resolve()
    {
        unityEvent.Invoke();
    }
}

[Serializable]
public class RPGActionPlaySE
{
    public AudioClip clip;
    public bool waitEnd;
    public async UniTask Resolve()
    {
        AudioManager.PlaySound(clip);
        await UniTask.Delay(TimeSpan.FromSeconds(waitEnd ? clip.length : 0));
    }
}

[Serializable]
public class RPGActionWait
{
    public float seconds;
    public async UniTask Resolve()
    {
        await UniTask.Delay(TimeSpan.FromSeconds(seconds), ignoreTimeScale: false);
    }
}

public enum TweenType { PunchScale, PunchRotation }
[Serializable]
public class RPGActionDOTween
{
    public TweenType type;
    public Transform targetTransform;
    public Vector3 punch;
    public float duration, elasticity;
    public int vibrato;
    public bool waitAnimEnd;
    public async UniTask Resolve()
    {
        UniTask task;
        switch (type)
        {
            case TweenType.PunchScale:
                task = targetTransform.DOPunchScale(punch, duration, vibrato, elasticity).AwaitForComplete(); break;
            case TweenType.PunchRotation:
                task = targetTransform.DOPunchRotation(punch, duration, vibrato, elasticity).AwaitForComplete(); break;
            default:
                return;
        }
        await task;
    }
}

[Serializable]
public class RPGActionAddItem
{
    public ScriptableItem item;
    [ShowIf("@item && item.isStackable")]
    public int amount = 1;
    public void Resolve()
    {
        GameManager.gameData.AddItem(item, amount);
    }
}

[Serializable]
public class RPGActionTeleportPlayer
{
    public string mapName;
    public bool setCustomSpawnPoint;
    [HideIf("setCustomSpawnPoint")]
    public int mapSpawnIndex;
    [ShowIf("setCustomSpawnPoint")]
    public Vector3 spawnPoint;
    public bool changeFaceDirection;
    [ShowIf("changeFaceDirection")]
    public FaceDirection newFaceDirection;

    public void Resolve()
    {
        var gameData = GameManager.gameData;
        var playerEntity = GameManager.refMap.player;
        gameData.savedMapSpawnIndex = setCustomSpawnPoint ? -1 : mapSpawnIndex;
        gameData.savedPosition = spawnPoint;
        gameData.savedFaceDir = changeFaceDirection ? newFaceDirection : playerEntity.faceDirection;
        if (SceneManager.GetActiveScene().name == mapName)
            GameManager.Instance.SpawnPlayer();
        else
            SceneManager.LoadScene(mapName);
    }
}

#endregion

[Serializable]
public class RPGAction
{
    #region Action_Params
    public RPGActionType actionType;
    [ShowIf("actionType", RPGActionType.ConditionalBranch)]
    [GUIColor(0, 1, 1)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionCheckConditions checkConditions;
    [ShowIf("actionType", RPGActionType.SetVariables)]
    [GUIColor(0, 1, 1)]
    public VariableTable variableTable;
    [ShowIf("actionType", RPGActionType.ShowText)]
    [GUIColor(0, 1, 1)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionShowText talk;
    [ShowIf("actionType", RPGActionType.Script)]
    [GUIColor(0, 1, 1)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionScript callScript;
    [ShowIf("actionType", RPGActionType.PlaySE)]
    [GUIColor(0, 1, 1)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionPlaySE playSFX;
    [ShowIf("actionType", RPGActionType.Wait)]
    [GUIColor(0, 1, 1)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionWait waitSeconds;
    [ShowIf("actionType", RPGActionType.DOTween)]
    [GUIColor(0, 1, 1)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionDOTween tweenParams;
    [ShowIf("actionType", RPGActionType.AddItem)]
    [GUIColor(0, 1, 1)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionAddItem addItem;
    [ShowIf("actionType", RPGActionType.TeleportPlayer)]
    [GUIColor(0, 1, 1)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionTeleportPlayer teleportMap;
    [ShowIf("actionType", RPGActionType.ShowCanvas)]
    [GUIColor(0, 1, 1)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionShowCanvas setCanvas;
    [ShowIf("actionType", RPGActionType.FlashScreen)]
    [GUIColor(0, 1, 1)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionFlashScreen flashScreen;
    #endregion

    public async UniTask Resolve()
    {
        switch (actionType)
        {
            case RPGActionType.SetVariables: Helpers.SetVariables(variableTable); break;
            case RPGActionType.ShowText: talk.Resolve(); break;
            case RPGActionType.Script: callScript.Resolve(); break;
            case RPGActionType.PlaySE: await playSFX.Resolve(); break;
            case RPGActionType.Wait: await waitSeconds.Resolve(); break;
            case RPGActionType.DOTween: await tweenParams.Resolve(); break;
            case RPGActionType.AddItem: addItem.Resolve(); break;
            case RPGActionType.TeleportPlayer: teleportMap.Resolve(); break;
            case RPGActionType.ConditionalBranch: await checkConditions.Resolve(); break;
            case RPGActionType.ShowCanvas: setCanvas.Resolve(); break;
            case RPGActionType.FlashScreen:
                if (flashScreen.waitToEnd) await flashScreen.Resolve();
                else flashScreen.Resolve().Forget();
                break;
        }
    }
}

