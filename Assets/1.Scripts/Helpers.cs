using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine;

public class Helpers
{
    public static int GetPlayerDeaths()
    {
        return PlayerPrefs.GetInt("DeathCounter");
    }

    public static void AddPlayerDeath()
    {
        var deaths = GetPlayerDeaths();
        PlayerPrefs.SetInt("DeathCounter", ++deaths);
    }

    public static void UseItem(Item item)
    {
        switch (item.name)
        {
            case "Rusty Key": GameManager.CastUsableItem(item); break;
            default: Debug.LogFormat("You used {0} but nothing happened...", item.name); break;
        }
    }

    public static FaceDirection GetOppositeFaceDirection(FaceDirection faceDirection) => faceDirection switch
    {
        FaceDirection.South => FaceDirection.North,
        FaceDirection.West => FaceDirection.West,
        FaceDirection.East => FaceDirection.East,
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

