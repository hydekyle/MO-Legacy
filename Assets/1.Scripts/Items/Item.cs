using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Localization;

[CreateAssetMenu(menuName = "Scriptables/Item")]
public class Item : ScriptableObject
{
    [HorizontalGroup("Item Data", 75)]
    [PreviewField(75)]
    [HideLabel]
    public Sprite sprite;
    [VerticalGroup("Item Data/Stats")]
    public LocalizedString title;
    [VerticalGroup("Item Data/Stats")]
    public LocalizedString description;
    [VerticalGroup("Item Data/Stats")]
    public bool isUsable;
    [VerticalGroup("Item Data/Stats")]
    public bool isStackable;

    public void Use()
    {

    }
}