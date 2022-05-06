using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using Cysharp.Threading.Tasks;
using UnityEditor;
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

    public static FaceDirection GetOppositeFaceDirection(FaceDirection faceDirection) => faceDirection switch
    {
        FaceDirection.South => FaceDirection.North,
        FaceDirection.West => FaceDirection.East,
        FaceDirection.East => FaceDirection.West,
        _ => FaceDirection.South
    };

    [MenuItem("RPG/Sprite Order Fix All")]
    public static void UISpriteOrderFixMapAll()
    {
        foreach (Transform t in GameObject.Find("[EVENTS]").transform)
        {
            if (t.TryGetComponent<SpriteRenderer>(out SpriteRenderer s))
            {
                s.sortingOrder = GetSpriteOrderByPositionY(t.position);
            }
        }
    }

    public static int GetSpriteOrderByPositionY(Vector3 position)
    {
        return (int)(-position.y * 10);
    }

    public static void SetVariables(VariableTable vTable)
    {
        foreach (var lv in vTable.localVariableTable)
        {
            switch (lv.conditionality)
            {
                case VariableConditionality.Equals: GameManager.gameData.SetLocalVariable(lv.ID(), lv.value); break;
                case VariableConditionality.GreaterThan: GameManager.gameData.AddToLocalVariable(lv.ID(), lv.value); break;
                case VariableConditionality.LessThan: GameManager.gameData.AddToLocalVariable(lv.ID(), -lv.value); break;
            }
        }
        foreach (var sw in vTable.switchTable) GameManager.gameData.SetSwitch(sw.ID(), sw.value);
        foreach (var va in vTable.variableTable)
        {
            switch (va.conditionality)
            {
                case VariableConditionality.Equals: GameManager.gameData.SetVariable(va.ID(), va.value); break;
                case VariableConditionality.GreaterThan: GameManager.gameData.AddToVariable(va.ID(), va.value); break;
                case VariableConditionality.LessThan: GameManager.gameData.AddToVariable(va.ID(), -va.value); break;
            }
        }
    }
}

// Switches .txt Placeholder 
// [Button("save")]
// void WriteTest()
// {
//     var path = Application.dataPath + "/switches.txt";
//     File.WriteAllLines(path, DameDatos());
//     path = Application.dataPath + "/variables.txt";
//     File.WriteAllLines(path, DameDatos());
// }

// IEnumerable<string> DameDatos()
// {
//     for (var x = 0; x < 200; x++)
//     {
//         var positionID = x.ToString();
//         if (x < 10) positionID = "00" + positionID;
//         else if (x < 100) positionID = "0" + positionID;
//         yield return positionID + " ";
//     }
// }

