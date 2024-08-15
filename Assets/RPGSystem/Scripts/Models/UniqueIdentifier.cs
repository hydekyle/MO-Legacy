using Sirenix.OdinInspector;
using UnityEngine;

namespace RPGSystem
{
    public class UniqueIdentifier : MonoBehaviour
    {
        int _id;
        [ShowInInspector]
        public int ID { get => _id; }

        public UniqueIdentifier()
        {
            _id = GetHashCode();
        }
    }

}