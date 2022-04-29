using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

[CreateAssetMenu(menuName = "Scriptables/New Item")]
public class ScriptableItem : ScriptableObject
{
    [HorizontalGroup("Item Data", 75)]
    [PreviewField(75)]
    [HideLabel]
    public Sprite sprite;
    [VerticalGroup("Item Data/Stats")]
    public string title;
    [VerticalGroup("Item Data/Stats")]
    [TextArea]
    public string description;
    [VerticalGroup("Item Data/Stats")]
    public bool isUsable;
    [VerticalGroup("Item Data/Stats")]
    public bool isStackable;
}