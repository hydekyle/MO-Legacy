using System;
using UnityEngine;

namespace RPGSystem
{
    [Serializable]
    public class SwitchCondition
    {
        public string name;
        public bool value;

        public int ID()
        {
            return int.Parse(name.Substring(0, 4));
        }
    }
}
