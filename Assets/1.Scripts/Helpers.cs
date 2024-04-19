using RPGSystem;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Tilemaps;


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

    public static bool IsColliderAtPosition(Vector3 worldPosition)
    {
        var hits = Physics2D.CircleCastAll(worldPosition, 0.02f, Vector2.one, 1f, LayerMask.GetMask("Default"));
        foreach (var hit in hits)
        {
            if (hit.transform.TryGetComponent<Collider2D>(out var collider) && collider.isTrigger == false)
            {
                Debug.Log(hit.transform.name);
                return true;
            }
        }
        return false;
    }

    [MenuItem("RPG/Sprite Order Fix All Children")]
    public static void UISpriteOrderFixMapAll()
    {
        var target = Selection.activeTransform;
        foreach (Transform t in target)
        {
            var sortingOrder = Entity.GetSpriteOrderByPositionY(t.position);
            if (t.TryGetComponent<SpriteRenderer>(out var spriteRendererComponent))
            {
                if (t.TryGetComponent<SortingGroup>(out var sortingGroupComponent))
                    sortingGroupComponent.sortingOrder = sortingOrder;
                else spriteRendererComponent.sortingOrder = sortingOrder;
            }
            else if (t.TryGetComponent<TilemapRenderer>(out var tilemapRenderer))
                tilemapRenderer.sortingOrder = sortingOrder;
        }
    }




}

// Switches .txt Placeholder 
// [Button("save")]
// void WriteTest()
// {
//     var path = Application.dataPath + "/Editor/switches.txt";
//     File.WriteAllLines(path, DameDatos());
//     path = Application.dataPath + "/Editor/variables.txt";;
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

