using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityObservables;

namespace RPGSystem
{
    // RPGSystem Enums
    public enum CollisionType { player, other, any }
    public enum FaceDirection { North, West, East, South, Any }
    public enum Conditionality { Equals, GreaterThan, LessThan }
    public enum VariableSetType { Set, Add, Sub, Multiply, Random }
    public enum TriggerType { PlayerInteraction, Touch, Autorun }
    public enum FreezeType { None, FreezeMovement, FreezeInteraction, FreezeAll }
    public enum OperationType { Replace, Add }
    public enum CameraTarget { Player, Transform }
    public enum CameraVelocity { Stopped, VerySlow, Slow, Normal, High, Instant }

    // RPGSystem Interfaces
    public interface IInteractionFrom
    {
        public void InteractionFrom(GameObject interactionEmmiter);
    }

    // RPGSystem Structs
    [Serializable]
    public struct FogData
    {
        public Image image;
        [Tooltip("Used for FogSettings Action to make it easy select fogs from same folder")]
        public Sprite defaultSprite;
    }

    // RPGSystem Serialized Dictionary with Observable Values
    [Serializable] public class SwitchDictionary : UnitySerializedDictionary<int, Observable<bool>> { }
    [Serializable] public class VariableDictionary : UnitySerializedDictionary<int, Observable<int>> { }
    [Serializable] public class LocalVariableDictionary : UnitySerializedDictionary<int, Observable<int>> { }
    [Serializable] public class ItemDictionary : UnitySerializedDictionary<Item, int> { }

    [Serializable] public class ObservableCharacter : Observable<Character> { }

    // This class is required for Odin to serialize dictionaries
    public abstract class UnitySerializedDictionary<TKey, TValue> : Dictionary<TKey, TValue>, ISerializationCallbackReceiver
    {
        [SerializeField, HideInInspector]
        private List<TKey> keyData = new();

        [SerializeField, HideInInspector]
        private List<TValue> valueData = new();

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

}