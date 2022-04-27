using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using Cysharp.Threading.Tasks;
using UnityEngine;

public class Helpers
{
    public static async void ResolveActions(RPGAction[] actions)
    {
        for (var x = 0; x < actions.Length; x++)
        {
            var action = actions[x];
            switch (action.actionType)
            {
                case RPGActionType.SetVariables: action.setVariableTable.Resolve(); break;
                case RPGActionType.Talk: Debug.Log(action.talkMSG); break;
                case RPGActionType.CallScript: action.callScript.Invoke(); break;
                case RPGActionType.PlaySFX: AudioManager.PlaySound(action.playSFX); break;
                case RPGActionType.WaitSeconds: await UniTask.Delay(TimeSpan.FromSeconds(action.waitTime), ignoreTimeScale: false); ; break;
            }
        }
    }

    public static int GetPlayerDeaths()
    {
        return PlayerPrefs.GetInt("DeathCounter");
    }

    public static void AddPlayerDeath()
    {
        var deaths = GetPlayerDeaths();
        PlayerPrefs.SetInt("DeathCounter", ++deaths);
    }

    public static FaceDirection GetOppositeFaceDirection(FaceDirection faceDirection) => faceDirection switch
    {
        FaceDirection.South => FaceDirection.North,
        FaceDirection.West => FaceDirection.East,
        FaceDirection.East => FaceDirection.West,
        _ => FaceDirection.South
    };

    public static FaceDirection GetFaceDirectionByDir(Vector3 dir)
    {
        // Face priority by higher axis
        if (Mathf.Abs(dir.x) > Mathf.Abs(dir.y))
        {
            if (dir.x < 0) return FaceDirection.West;
            else if (dir.x > 0) return FaceDirection.East;
            else if (dir.y < 0) return FaceDirection.South;
            else return FaceDirection.North;
        }
        else
        {
            if (dir.y < 0) return FaceDirection.South;
            else if (dir.y > 0) return FaceDirection.North;
            else if (dir.x < 0) return FaceDirection.West;
            else return FaceDirection.East;
        }
    }

}

