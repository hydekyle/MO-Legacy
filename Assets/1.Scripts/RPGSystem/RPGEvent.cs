using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

public class RPGEvent : MonoBehaviour
{
    public List<RPGPage> pages = new List<RPGPage>() { new RPGPage() };
    int _activePageIndex = -1;
    // Caching to avoid resubs
    List<int> _subscribedSwitchList = new List<int>();
    List<int> _subscribedVariableList = new List<int>();

    void OnValidate()
    {
        foreach (var page in pages)
        {
            if (page.conditions != null) page.conditions.Refresh();
            if (page.actions != null)
                foreach (var action in page.actions) action.variableTable?.Refresh();
        }
    }

    void Start()
    {
        SubscribeToRequiredValueConditions();
        CheckAllPageCondition();
    }

    private void OnDestroy()
    {
        UnSubscribeToRequiredConditions();
    }

    void OnTriggerEnter2D(Collider2D other)
    {
        var page = GetActivePage();
        if (page.trigger == TriggerType.PlayerTouch && other.CompareTag("Player"))
            GameManager.ResolveEntityActions(page, transform.GetHashCode());
    }

    public RPGPage GetActivePage()
    {
        return pages[_activePageIndex];
    }

    void ApplyPage(int pageIndex)
    {
        var page = pages[pageIndex];
        if (TryGetComponent<SpriteRenderer>(out SpriteRenderer spriteRenderer))
        {
            spriteRenderer.sprite = page.sprite;
        }
        else
        {
            var newRenderer = gameObject.AddComponent<SpriteRenderer>();
            newRenderer.sprite = page.sprite;
            newRenderer.sortingOrder = 3;
        }

        if (pageIndex != _activePageIndex && _activePageIndex != -1)
        {
            if (page.trigger == TriggerType.Autorun) GameManager.ResolveEntityActions(page, transform.GetHashCode());
            if (page.playSFXOnEnabled) AudioManager.PlaySoundFromGameobject(page.playSFXOnEnabled, gameObject);
        }

        _activePageIndex = pageIndex;
    }

    // Called every time a required switch or variable changes the value
    void CheckAllPageCondition()
    {
        for (var x = pages.Count - 1; x >= 0; x--)
        {
            var page = pages[x];
            var isAllOK = IsAllPageConditionOK(page);
            if (isAllOK && _activePageIndex == x) return;
            else if (isAllOK)
            {
                ApplyPage(x);
                return;
            }
        }
    }

    void SubscribeToRequiredValueConditions()
    {
        foreach (var page in pages) SubscribeConditionTable(page.conditions);
    }

    void SubscribeConditionTable(RPGVariableTable cTable)
    {
        foreach (var s in cTable.switchTable)
        {
            var ID = s.ID();
            if (_subscribedSwitchList.Contains(ID)) continue; // Avoiding resubscription
            GameManager.SubscribeToSwitchChangedEvent(ID, CheckAllPageCondition);
            _subscribedSwitchList.Add(ID);
        }
        foreach (var v in cTable.variableTable)
        {
            var ID = v.ID();
            if (_subscribedVariableList.Contains(ID)) continue;
            GameManager.SubscribeToVariableChangedEvent(ID, CheckAllPageCondition);
            _subscribedVariableList.Add(ID);
        }
    }

    /// <summary>Called Only OnDestroy</summary>
    void UnSubscribeToRequiredConditions()
    {
        foreach (var page in pages) UnsubscribeConditionTable(page.conditions);
    }

    void UnsubscribeConditionTable(RPGVariableTable cTable)
    {
        foreach (var id in _subscribedSwitchList) GameManager.UnsubscribeToSwitchChangedEvent(id, CheckAllPageCondition);
        foreach (var id in _subscribedVariableList) GameManager.UnsubscribeToVariableChangedEvent(id, CheckAllPageCondition);
        _subscribedSwitchList.Clear();
        _subscribedVariableList.Clear();
    }

    bool IsAllPageConditionOK(RPGPage page)
    {
        return IsTableConditionsOK(page.conditions);
    }

    bool IsTableConditionsOK(RPGVariableTable cTable)
    {
        foreach (var requiredSwitch in cTable.switchTable)
        {
            var switchValue = GameManager.GetSwitch(requiredSwitch.ID());
            if (requiredSwitch.value != switchValue) return false;
        }
        foreach (var requiredVariable in cTable.variableTable)
        {
            var variableValue = GameManager.GetVariable(requiredVariable.ID());
            switch (requiredVariable.conditionality)
            {
                case VariableConditionality.Equals: if (requiredVariable.value == variableValue) continue; break;
                case VariableConditionality.GreaterThan: if (requiredVariable.value < variableValue) continue; break;
                case VariableConditionality.LessThan: if (requiredVariable.value > variableValue) continue; break;
            }
            return false;
        }
        return true;
    }
}
