using System.Collections.Generic;
using UnityEngine;

namespace MalbersAnimations.Selector
{
    [CreateAssetMenu(menuName = "Malbers Animations/Ultimate Selector/Items Set", order = 5000)]
    public class MItemSet : ScriptableObject 
    { 
        public List<MItem> Set; 
    }
}