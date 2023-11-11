using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using Sirenix.OdinInspector;
using UnityEngine;

namespace RPGSystem
{
    public class RPGEvent : MonoBehaviour
    {
        [OnValueChanged("OnValuePageChanged", true)]
        public List<PageEvent> pages = new();
        int activePageIndex = -1;
        public PageEvent ActivePage { get => pages[activePageIndex]; }
        List<int> _subscribedLocalVariableList = new();
        List<int> _subscribedSwitchList = new();
        List<int> _subscribedVariableList = new();
        SpriteRenderer spriteRenderer;

        /// <summary> 
        /// Fire RPG Actions from active page of this RPG Event
        /// Call this function for Player Interaction !
        /// </summary>
        public void TriggerEvent()
        {
            if (ActivePage.conditions.IsAllConditionOK()) ActivePage.ResolveActionList(this.GetCancellationTokenOnDestroy()).Forget();
        }

        void Awake()
        {
            spriteRenderer = GetComponent<SpriteRenderer>();
        }

        void Start()
        {
            SubscribeToRequiredValueConditions();
            CheckAllPageCondition();
        }

        // Called every time a switch or variable required by any condition from this RPG Event
        void CheckAllPageCondition()
        {
            for (var x = pages.Count - 1; x >= 0; x--)
            {
                var page = pages[x];
                var isAllOK = page.conditions.IsAllConditionOK();
                if (isAllOK && activePageIndex == x) return;
                else if (isAllOK)
                {
                    gameObject.SetActive(true);
                    ApplyPage(x);
                    return;
                }
            }
            // If any of all pages met the conditions we disable the GameObject
            gameObject.SetActive(false);
            activePageIndex = -1;
        }

        void ApplyPage(int pageIndex)
        {
            var page = pages[pageIndex];
            if (spriteRenderer) spriteRenderer.sprite = page.sprite;
            if (pageIndex != activePageIndex)
            {
                if (page.trigger == TriggerType.Autorun && page.actionList.Count > 0) page.ResolveActionList(this.GetCancellationTokenOnDestroy()).Forget();
                activePageIndex = pageIndex;
                if (page.playSFXOnEnabled) RPGManager.AudioManager.PlaySound(page.playSFXOnEnabled, page.soundOptions, gameObject);
            }
        }

        void UIShowSprite()
        {
            for (var x = 0; x < pages.Count; x++)
            {
                if (pages[x].sprite != null)
                {
                    if (TryGetComponent<SpriteRenderer>(out SpriteRenderer spriteRenderer))
                    {
                        spriteRenderer.sprite = pages[x].sprite;
                        spriteRenderer.sortingOrder = 3;
                    }
                    else
                    {
                        try
                        {
                            var newRenderer = gameObject.AddComponent<SpriteRenderer>();
                            newRenderer.sprite = pages[x].sprite;
                            newRenderer.sortingLayerName = "Outside";
                        }
                        catch
                        {
                            Debug.LogError("Remove MeshFilter and MeshRenderer from the GameObject first in order to add a Sprite");
                        }
                    }
                    return;
                }
            }
            // If pages has no sprite
            DestroyImmediate(GetComponent(typeof(SpriteRenderer)));
        }

        void UIShowBoxCollider2D()
        {
            if (pages.Exists(page => page.trigger == TriggerType.PlayerInteraction || page.trigger == TriggerType.PlayerTouch))
            {
                if (!TryGetComponent<BoxCollider2D>(out BoxCollider2D boxCollider))
                {
                    var newCollider = gameObject.AddComponent<BoxCollider2D>();
                    newCollider.isTrigger = true;
                }
            }
            else
            {
                if (TryGetComponent<BoxCollider2D>(out BoxCollider2D boxCollider))
                    if (boxCollider.isTrigger) DestroyImmediate(boxCollider);
            }
        }

        void UIShowBoxCollider()
        {
            if (pages.Exists(page => page.trigger == TriggerType.PlayerInteraction || page.trigger == TriggerType.PlayerTouch))
            {
                if (!TryGetComponent<Collider>(out Collider collider))
                {
                    if (TryGetComponent<MeshRenderer>(out var component))
                    {
                        var newCollider = gameObject.AddComponent<MeshCollider>();
                        newCollider.convex = true;
                        newCollider.isTrigger = true;
                    }
                }
            }
            else
            {
                if (TryGetComponent<MeshCollider>(out MeshCollider boxCollider))
                    if (boxCollider.isTrigger) DestroyImmediate(boxCollider);
            }
        }

        void OnValuePageChanged()
        {
            UIShowSprite();
            UIShowBoxCollider();
        }

        void SubscribeToRequiredValueConditions()
        {
            foreach (var page in pages) page.conditions.SubscribeToConditionTable(ref _subscribedSwitchList, ref _subscribedVariableList, ref _subscribedLocalVariableList, CheckAllPageCondition);
        }

        void UnSubscribeToRequiredConditions()
        {
            foreach (var page in pages) page.conditions.UnsubscribeConditionTable(ref _subscribedSwitchList, ref _subscribedVariableList, ref _subscribedLocalVariableList, CheckAllPageCondition);
        }

        void OnDestroy()
        {
            UnSubscribeToRequiredConditions();
        }

        // Called when the component is added for first time
        void Reset()
        {
            pages.Add(new PageEvent()
            {
                sprite = TryGetComponent<SpriteRenderer>(out SpriteRenderer s) ? s.sprite : null
            });
        }

        void OnValidate()
        {
            foreach (var page in pages)
            {
                page.RPGEventParent = this;
                if (page.conditions != null) page.conditions.Refresh();
                if (page.actionList != null)
                    foreach (var action in page.actionList)
                    {
                        var actionType = action.GetType();
                        if (actionType == typeof(AddVariables))
                        {
                            AddVariables sv = (AddVariables)action;
                            sv.setVariables?.Refresh();
                        }
                        else if (actionType == typeof(CheckConditions))
                        {
                            CheckConditions sv = (CheckConditions)action;
                            sv.conditionList?.Refresh();
                        }
                    }
            }
        }

        public void InteractionPlayer()
        {
            if (ActivePage.trigger == TriggerType.PlayerInteraction) TriggerEvent();
        }

        public void TouchPlayer()
        {
            if (ActivePage.trigger == TriggerType.PlayerTouch) TriggerEvent();
        }


    }

}