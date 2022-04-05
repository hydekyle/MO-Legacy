using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityObservables;
using Sirenix.OdinInspector;

public enum TriggerType { player, other }

public class Entity : MonoBehaviour
{
    public Sprite sprite;
    public float movementSpeed;

    public void Move(Vector2 dir)
    {
        transform.position = Vector2.MoveTowards(transform.position, transform.position + new Vector3(dir.x, dir.y, 0), Time.deltaTime * movementSpeed);
    }
}

[Serializable]
public struct Item
{
    [PreviewField(50, ObjectFieldAlignment.Right)]
    public Sprite sprite;
    public string name;
    public string description;
    public bool isUsable;
}

[Serializable]
public struct GameData
{
    public Switches switches;
    public Variables variables;
    public List<Item> inventory;
}

[Serializable]
public class Switch
{
    public string ID;
    public bool value;
}

[Serializable]
public class Variable
{
    public string ID;
    public int value;
}

[Serializable]
public class Switches : UnitySerializedDictionary<string, bool> { }

[Serializable]
public class Variables : UnitySerializedDictionary<string, int> { }

// This is required for Odin Inspector Plugin to serialize Dictionary
public abstract class UnitySerializedDictionary<TKey, TValue> : Dictionary<TKey, TValue>, ISerializationCallbackReceiver
{
    [SerializeField, HideInInspector]
    private List<TKey> keyData = new List<TKey>();

    [SerializeField, HideInInspector]
    private List<TValue> valueData = new List<TValue>();

    void ISerializationCallbackReceiver.OnAfterDeserialize()
    {
        this.Clear();
        for (int i = 0; i < this.keyData.Count && i < this.valueData.Count; i++)
        {
            this[this.keyData[i]] = this.valueData[i];
        }
    }

    void ISerializationCallbackReceiver.OnBeforeSerialize()
    {
        this.keyData.Clear();
        this.valueData.Clear();

        foreach (var item in this)
        {
            this.keyData.Add(item.Key);
            this.valueData.Add(item.Value);
        }
    }
}

