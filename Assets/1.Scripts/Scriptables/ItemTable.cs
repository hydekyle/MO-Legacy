using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Table/Items")]
public class ItemTable : ScriptableObject
{
    public List<Item> items;
}
