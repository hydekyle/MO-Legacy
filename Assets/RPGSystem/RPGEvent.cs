using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Localization.SmartFormat.Utilities;

namespace RPGSystem
{
    public class RPGEvent : MonoBehaviour
    {
        [OnValueChanged("OnUIValuePageChanged", true)]
        public List<PageEvent> pages = new();
        int activePageIndex = -1;
        public PageEvent ActivePage { get => pages[activePageIndex]; }
        List<int> _subscribedLocalVariableList = new();
        List<int> _subscribedSwitchList = new();
        List<int> _subscribedVariableList = new();
        SpriteRenderer spriteRenderer;

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

        void Awake()
        {
            spriteRenderer = GetComponent<SpriteRenderer>();
        }

        void Start()
        {
            SubscribeToRequiredValueConditions();
            CheckAllPageCondition(false); // We only play sound on enabled when switches changes in the scene, not now
        }

        void OnTriggerEnter2D(Collider2D other)
        {
            if (ActivePage.requiredFaceDirection != FaceDirection.Any) return;
            if (ActivePage.trigger == TriggerType.Touch && (ActivePage.triggerLayerMask.value & (1 << other.gameObject.layer)) != 0)
            {
                TriggerEvent();
            }
        }

        // We need to check while stay on event if faceDirection is met
        void OnTriggerStay2D(Collider2D other)
        {
            if (ActivePage.requiredFaceDirection == FaceDirection.Any) return;
            if (other.TryGetComponent(out Entity entity))
            {
                if (entity.faceDirection == ActivePage.requiredFaceDirection)
                {
                    // Verify that entity layer is in Event LayerMask
                    if (ActivePage.trigger == TriggerType.Touch && (ActivePage.triggerLayerMask.value & (1 << other.gameObject.layer)) != 0)
                    {

                        entity.LookAtDirection(ActivePage.requiredFaceDirection); // This avoid anim delay visual incongruence
                        TriggerEvent();
                    }
                }
            }
        }

        /// <summary> 
        /// Fire RPG Actions from active page of this RPG Event
        /// Call this function for Player Interaction !
        /// </summary>
        public void TriggerEvent()
        {
            if (ActivePage.conditions.IsAllConditionOK()) ActivePage.ResolveActionList(this.GetCancellationTokenOnDestroy()).Forget();
        }

        // Called every time a switch or variable required by any condition from this RPG Event is changed
        void CheckAllPageCondition(bool playSFXOnEnabled = true)
        {
            for (var x = pages.Count - 1; x >= 0; x--)
            {
                var page = pages[x];
                var isAllOK = page.conditions.IsAllConditionOK();
                if (isAllOK && activePageIndex == x) return;
                else if (isAllOK)
                {
                    gameObject.SetActive(true);
                    ApplyPage(x, playSFXOnEnabled);
                    return;
                }
            }
            // If no page met the conditions we disable the GameObject (but still subscribed to changes to enable it again if any page met conditions)
            gameObject.SetActive(false);
            activePageIndex = -1;
        }

        // Required to avoid calling anonymous function from SubscribeToRequiredValueConditions (gameobject destroyed when change scene and return to it)
        void CheckAllPageConditionWithSound()
        {
            CheckAllPageCondition(true);
        }

        void ApplyPage(int pageIndex, bool playSFXOnEnabled = true)
        {
            var page = pages[pageIndex];
            if (spriteRenderer) spriteRenderer.sprite = page.sprite;
            if (pageIndex != activePageIndex)
            {
                if (page.trigger == TriggerType.Autorun && page.actionList.Count > 0) page.ResolveActionList(this.GetCancellationTokenOnDestroy()).Forget();
                activePageIndex = pageIndex;
                if (page.playSFXOnEnabled && playSFXOnEnabled) AudioManager.Instance.PlaySound(page.playSFXOnEnabled, page.soundOptions, gameObject);
            }
        }

        void SubscribeToRequiredValueConditions()
        {
            foreach (var page in pages) page.conditions.SubscribeToConditionTable(_subscribedSwitchList, _subscribedVariableList, _subscribedLocalVariableList, CheckAllPageConditionWithSound);
        }

        void UnSubscribeToRequiredConditions()
        {
            foreach (var page in pages) page.conditions.UnsubscribeConditionTable(_subscribedSwitchList, _subscribedVariableList, _subscribedLocalVariableList, CheckAllPageConditionWithSound);
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
                sprite = TryGetComponent(out SpriteRenderer s) ? s.sprite : null
            });
        }

        public void InteractionPlayer()
        {
            if (ActivePage.trigger == TriggerType.PlayerInteraction) TriggerEvent();
        }

        public void TouchPlayer()
        {
            if (ActivePage.trigger == TriggerType.Touch) TriggerEvent();
        }

        // Called only in editor when changing page values to update GameObject components accordingly
        void OnUIValuePageChanged()
        {
            UIShowSprite();
            UIShowBoxCollider();
        }

        void UIShowSprite()
        {
            for (var x = 0; x < pages.Count; x++)
            {
                if (pages[x].sprite != null)
                {
                    if (TryGetComponent(out SpriteRenderer spriteRenderer))
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
            DestroyImmediate(GetComponent<SpriteRenderer>());
        }

        void UIShowBoxCollider()
        {
            if (pages.Exists(page => page.trigger == TriggerType.PlayerInteraction || page.trigger == TriggerType.Touch))
            {
                if (!TryGetComponent(out Collider collider))
                {
                    if (TryGetComponent(out MeshRenderer component))
                    {
                        var newCollider = gameObject.AddComponent<MeshCollider>();
                        newCollider.convex = true;
                        newCollider.isTrigger = true;
                    }
                }
            }
            else
            {
                if (TryGetComponent(out MeshCollider boxCollider))
                    if (boxCollider.isTrigger) DestroyImmediate(boxCollider);
            }
        }

    }

}