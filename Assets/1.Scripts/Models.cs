using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityObservables;
using Sirenix.OdinInspector;
using Cysharp.Threading.Tasks;

public enum TriggerType { player, other }

public enum FaceDirection { North, West, East, South }

// 0 (down) walking
// 1 (down) idle
// 2 (down) walking

// 3 (left) walking

// 6 (right) walking

// 9 (up) walking

public class Entity : MonoBehaviour
{
    public Sprite[] spriteList;
    public float movementSpeed;
    public float animationFrameTime = 0.1f;
    [HideInInspector]
    public FaceDirection faceDirection;
    SpriteRenderer spriteRenderer;
    float _lastTimeAnimationChanged = -1;
    List<int> stepAnimOrder = new List<int>() { 0, 1, 2, 1 };
    int _indexStepAnim = 0;

    private void Awake()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
    }

    public void Move(Vector3 moveDirection)
    {
        transform.position = Vector3.Lerp(transform.position, transform.position + new Vector3(moveDirection.x, moveDirection.y, 0), Time.deltaTime * movementSpeed);
        var _faceDirection = Helpers.GetFaceDirectionByDir(moveDirection);
        faceDirection = _faceDirection;
        AnimationWalk();
    }

    public async void StopMovement()
    {
        await UniTask.WaitUntil(() => _lastTimeAnimationChanged + animationFrameTime < Time.time);
        LookAtDirection(faceDirection);
    }

    void LookAtDirection(FaceDirection fDir)
    {
        switch (fDir)
        {
            case FaceDirection.South:
                spriteRenderer.sprite = spriteList[1];
                break;
            case FaceDirection.West:
                spriteRenderer.sprite = spriteList[4];
                break;
            case FaceDirection.East:
                spriteRenderer.sprite = spriteList[7];
                break;
            case FaceDirection.North:
                spriteRenderer.sprite = spriteList[10];
                break;
        }
        faceDirection = fDir;
    }

    public void AnimationWalk()
    {
        switch (faceDirection)
        {
            case FaceDirection.South:
                spriteRenderer.sprite = spriteList[0 + stepAnimOrder[_indexStepAnim]];
                break;
            case FaceDirection.West:
                spriteRenderer.sprite = spriteList[3 + stepAnimOrder[_indexStepAnim]];
                break;
            case FaceDirection.East:
                spriteRenderer.sprite = spriteList[6 + stepAnimOrder[_indexStepAnim]];
                break;
            case FaceDirection.North:
                spriteRenderer.sprite = spriteList[9 + stepAnimOrder[_indexStepAnim]];
                break;
        }
        // Animation Steps
        if (Time.time > _lastTimeAnimationChanged + animationFrameTime)
        {
            _indexStepAnim = _indexStepAnim < stepAnimOrder.Count - 1 ? _indexStepAnim + 1 : 0;
            _lastTimeAnimationChanged = Time.time;
        }
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

