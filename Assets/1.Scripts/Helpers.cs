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
            case "Rusty Key": GameManager.Instance.CastUsableItem(item); break;
            default: Debug.LogFormat("You used {0} but nothing happened...", item.name); break;
        }
    }

}

