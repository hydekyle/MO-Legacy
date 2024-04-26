using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Localization;

public abstract class Skill : ScriptableObject
{
    [PreviewField(75)]
    [HideLabel]
    public Sprite sprite;
    public LocalizedString title;
    public LocalizedString description;

}
