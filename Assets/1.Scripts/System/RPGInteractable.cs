using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;

public class RPGInteractable : MonoBehaviour
{
    public AudioClip playSound;
    public List<SwitchCondition> setSwitchList;
    public List<VariableCondition> setVariableList;
    public UnityEvent onInteractionEvent;

    public void DoInteraction()
    {
        if (playSound != null)
        {
            AudioManager.PlaySoundFromGameobject(playSound, gameObject);
        }
        foreach (var sw in setSwitchList) GameManager.SetSwitch(sw.ID, sw.value);
        foreach (var va in setVariableList) GameManager.SetVariable(va.ID, va.value);
        onInteractionEvent.Invoke();
    }
}
