using System;
using System.Collections.Generic;
using UnityEngine;

namespace RPGSystem
{
    [Serializable]
    public class Inventory : ItemDictionary
    {
        public List<Item> GetItemList()
        {
            var itemList = new List<Item>();
            foreach (var item in this) itemList.Add(item.Key);
            return itemList;
        }
    }
}