using System;
using System.Collections.Generic;
using System.Threading;
using Cysharp.Threading.Tasks;
using Sirenix.OdinInspector;
using UnityEngine;

namespace RPGSystem
{
    [Serializable]
    public class PageEvent
    {
        [PreviewField(50, ObjectFieldAlignment.Center)]
        public Sprite sprite;
        [GUIColor(0, 1, 1)]
        public VariableTableCondition conditions;
        [GUIColor(1, 1, 0)]
        [ListDrawerSettings(ShowFoldout = true)]
        [SerializeReference]
        public List<IAction> actionList = new();
        [ShowIf("@this.actionList.Count > 0")]
        public TriggerType trigger = TriggerType.Autorun;
        [ShowIf("@this.actionList.Count > 0")]
        public bool isLoop;
        [ShowIf("@this.actionList.Count > 0")]
        public FreezeType freezePlayerAtRun;
        [Space(25)]
        public AudioClip playSFXOnEnabled;
        [ShowIf("@playSFXOnEnabled != null")]
        public SoundOptions soundOptions = new SoundOptions()
        {
            soundLoop = false,
            volume = 1f,
            spatialBlend = 1f,
            stereoPan = 0f,
            pitch = 1f
        };
        bool isResolvingActionList = false;
        [HideInInspector]
        public RPGEvent RPGEventParent;

        public async UniTaskVoid ResolveActionList(CancellationToken cts)
        {
            if (isResolvingActionList) return;
            isResolvingActionList = true;
            DoFreezeWhile();
            do
            {
                for (var x = 0; x < actionList.Count; x++)
                {
                    if (!Application.isPlaying) return;
                    var action = actionList[x];

                    if (action is IWaitable)
                    {
                        IWaitable waitableAction = (IWaitable)action;
                        if (waitableAction.waitEnd)
                        {
                            await action.Resolve().AttachExternalCancellation(cts);
                            continue;
                        }
                    }

                    action.Resolve().AttachExternalCancellation(cts).Forget();
                }
                await UniTask.Yield();
            } while (isLoop && RPGEventParent.ActivePage == this);
            UnfreezeWhile();
            isResolvingActionList = false;
        }

        void DoFreezeWhile()
        {
            switch (freezePlayerAtRun)
            {
                case FreezeType.FreezeAll: RPGManager.Instance.isInteractionAvailable = RPGManager.Instance.isMovementAvailable = false; break;
                case FreezeType.FreezeInteraction: RPGManager.Instance.isInteractionAvailable = false; break;
                case FreezeType.FreezeMovement: RPGManager.Instance.isMovementAvailable = false; break;
            }
        }

        void UnfreezeWhile()
        {
            if (freezePlayerAtRun != FreezeType.None)
                RPGManager.Instance.isInteractionAvailable = RPGManager.Instance.isMovementAvailable = true;
        }
    }
}