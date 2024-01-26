using System;
using System.Collections.Generic;
using UnityEngine;
using UnityObservables;

namespace RPGSystem
{
    // RPGSystem Structs
    public enum CollisionType { player, other, any }
    public enum FaceDirection { North, West, East, South }
    public enum Conditionality { Equals, GreaterThan, LessThan }
    public enum VariableSetType { Set, Add, Sub, Multiply, Random }
    public enum TriggerType { PlayerInteraction, PlayerTouch, Autorun }
    public enum FreezeType { None, FreezeMovement, FreezeInteraction, FreezeAll }
    public enum OperationType { Replace, Add }

    // Interfaces
    public interface IInteractable
    {
        public void InteractionFrom(Entity interactionEmmiter);
    }

    // RPGSystem Serialized Dictionary with Observable Values
    [Serializable] public class SwitchDictionary : UnitySerializedDictionary<int, Observable<bool>> { }
    [Serializable] public class VariableDictionary : UnitySerializedDictionary<int, Observable<int>> { }
    [Serializable] public class LocalVariableDictionary : UnitySerializedDictionary<int, Observable<int>> { }
    [Serializable] public class Inventory : UnitySerializedDictionary<ScriptableItem, int> { }

    // This class is required for Odin to serialize dictionaries
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

}