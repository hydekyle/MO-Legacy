using System;
using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;

// Don't reorder
public enum RPGActionType
{
    SetVariables,
    Talk,
    PlaySFX,
    WaitSeconds,
    DOTween,
    CallScript
}

[Serializable]
public class RPGAction
{
    public RPGActionType actionType;
    [ShowIf("actionType", RPGActionType.SetVariables)]
    public RPGVariableTable variableTable;
    [ShowIf("actionType", RPGActionType.Talk)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionTalk talk;
    [ShowIf("actionType", RPGActionType.CallScript)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionCallScript callScript;
    [ShowIf("actionType", RPGActionType.PlaySFX)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionPlaySFX playSFX;
    [ShowIf("actionType", RPGActionType.WaitSeconds)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionWaitTime waitSeconds;
    [ShowIf("actionType", RPGActionType.DOTween)]
    [TableList(AlwaysExpanded = true)]
    public RPGActionDOTween tweenParams;

    public async UniTask Resolve()
    {
        switch (actionType)
        {
            case RPGActionType.SetVariables: variableTable.Resolve(); break;
            case RPGActionType.Talk: talk.Resolve(); break;
            case RPGActionType.CallScript: callScript.Resolve(); break;
            case RPGActionType.PlaySFX: playSFX.Resolve(); break;
            case RPGActionType.WaitSeconds: await waitSeconds.Resolve(); break;
            case RPGActionType.DOTween: await tweenParams.Resolve(); break;
        }
    }
}

#region Action_Params
[Serializable]
public class RPGActionTalk
{
    public string text;
    public void Resolve()
    {
        Debug.Log(text);
    }
}

[Serializable]
public class RPGActionCallScript
{
    public UnityEvent unityEvent;
    public void Resolve()
    {
        unityEvent.Invoke();
    }
}

[Serializable]
public class RPGActionPlaySFX
{
    public AudioClip clip;
    public void Resolve()
    {
        AudioManager.PlaySound(clip);
    }
}

[Serializable]
public class RPGActionWaitTime
{
    public float seconds;
    public async UniTask Resolve()
    {
        await UniTask.Delay(TimeSpan.FromSeconds(seconds), ignoreTimeScale: false);
    }
}

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
                task = targetTransform.DOPunchScale(punch, duration, vibrato, elasticity).ToUniTask(); break;
            case TweenType.PunchRotation:
                task = targetTransform.DOPunchRotation(punch, duration, vibrato, elasticity).ToUniTask(); break;
            default:
                task = new UniTask(); break;
        }
        if (waitAnimEnd) await task;
    }
}

public enum TweenType { PunchScale, PunchRotation }

#endregion
