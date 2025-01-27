using Sirenix.OdinInspector;
using UnityEngine;

namespace RPGSystem
{
    public class UniqueIdentifier : MonoBehaviour
    {
        [SerializeField]
        int _id;
        [ShowInInspector]
        public int ID { get => _id; }

        void OnValidate()
        {
            RefreshID();
        }

#if UNITY_EDITOR
        [Button()]
        public void RefreshID()
        {
            _id = GetHashCode();
        }
#endif
    }

}