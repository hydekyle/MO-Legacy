using System;

namespace RPGSystem
{
    [Serializable]
    public class VariableCondition
    {
        public string name;
        public int value;
        public Conditionality conditionality;

        public int ID()
        {
            return int.Parse(name.Substring(0, 4));
        }
    }
}
