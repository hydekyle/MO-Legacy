using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

namespace RPGActions
{
    [Serializable]
    public abstract class RPGAction
    {
        public virtual async UniTask Resolve() { }
    }

    [Serializable]
    public class SetVariables : RPGAction
    {
        public VariableTableSet setVariables;

        public override async UniTask Resolve()
        {
            GameManager.GameData.ResolveSetVariables(setVariables);
        }
    }

    [Serializable]
    public class FlashScreen : RPGAction
    {
        public Color flashColor;
        public float duration;
        public bool waitToEnd;

        public override async UniTask Resolve()
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
    public class ShowCanvas : RPGAction
    {
        [ValueDropdown("UIGetCanvasList")]
        public Transform canvasT;
        public bool isVisible;

        public override async UniTask Resolve()
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
    public class CheckConditions : RPGAction
    {
        public VariableTableCondition conditionList;
        public RPGAction[] onTrue, onFalse;

        public override async UniTask Resolve()
        {
            if (conditionList.IsAllConditionOK())
                foreach (var action in onTrue) await action.Resolve();
            else
                foreach (var action in onFalse) await action.Resolve();
        }
    }

    [Serializable]
    public class ShowText : RPGAction
    {
        public string text;
        public override async UniTask Resolve()
        {
            Debug.Log(text);
        }
    }

    [Serializable]
    public class CallScript : RPGAction
    {
        public UnityEvent unityEvent;
        public override async UniTask Resolve()
        {
            unityEvent.Invoke();
        }
    }

    [Serializable]
    public class PlaySE : RPGAction
    {
        public AudioClip clip;
        public bool waitEnd;
        public override async UniTask Resolve()
        {
            AudioManager.PlaySound(clip);
            await UniTask.Delay(TimeSpan.FromSeconds(waitEnd ? clip.length : 0), ignoreTimeScale: true);
        }
    }

    [Serializable]
    public class Await : RPGAction
    {
        public float seconds;
        public override async UniTask Resolve()
        {
            await UniTask.Delay(TimeSpan.FromSeconds(seconds), ignoreTimeScale: false);
        }
    }

    public enum TweenType { PunchScale, PunchRotation }

    [Serializable]
    public class Tween : RPGAction
    {
        public TweenType type;
        public Transform targetTransform;
        public Vector3 punch;
        public float duration, elasticity;
        public int vibrato;
        public bool waitToEnd;
        public override async UniTask Resolve()
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
    public class AddItem : RPGAction
    {
        public ScriptableItem item;
        [ShowIf("@item && item.isStackable")]
        public int amount = 1;
        public override async UniTask Resolve()
        {
            GameManager.GameData.AddItem(item, amount);
        }
    }

    [Serializable]
    public class TeleportPlayer : RPGAction
    {
        [ValueDropdown("GetSceneNameList")]
        public string mapName;
        [Range(0, 10)]
        public int mapSpawnIndex;
        public bool changeFaceDirection;
        [ShowIf("changeFaceDirection")]
        public FaceDirection newFaceDirection;

        public override async UniTask Resolve()
        {
            var gameData = GameManager.GameData;
            var playerEntity = GameManager.refMap.player;
            gameData.savedMapSpawnIndex = mapSpawnIndex;
            gameData.savedFaceDir = changeFaceDirection ? newFaceDirection : playerEntity.faceDirection;
            if (SceneManager.GetActiveScene().name == mapName)
                GameManager.Instance.SpawnPlayer();
            else
                SceneManager.LoadScene(mapName);
        }

        public IEnumerable<string> GetSceneNameList()
        {
            var path = Application.dataPath + "/Scenes";
            var directoryInfo = new DirectoryInfo(path);
            var fileList = directoryInfo.GetFiles();
            foreach (var file in fileList)
                if (!file.Name.Contains(".meta")) yield return file.Name.Split(".unity")[0];
        }
    }

}

