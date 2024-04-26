#pragma warning disable CS1998 // Async method lacks 'await' operators and will run synchronously

using System.Data.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Doublsb.Dialog;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Localization;
using UnityEngine.SceneManagement;
using UnityEditor.Localization.Plugins.XLIFF.V12;

namespace RPGSystem
{
    public interface IAction
    {
        public async UniTask Resolve() { }
    }

    public abstract class WaitableAction
    {
        public bool waitEnd = true;
    }

    // ADD YOUR GAME ACTIONS HERE

    [Serializable]
    public class ChangePlayerFreeze : IAction
    {
        public FreezeType playerFreeze;

        public async UniTask Resolve()
        {
            RPGManager.Instance.SetPlayerFreeze(playerFreeze);
        }
    }

    [Serializable]
    public class CameraMove : IAction
    {
        public CameraTarget cameraTarget;
        [ShowIf("@cameraTarget == CameraTarget.Transform")]
        public Transform target;
        public bool changeCameraSpeed;
        [ShowIf("@changeCameraSpeed")]
        public CameraVelocity cameraVelocity;
        public ChangePlayerFreeze changePlayerMobility;

        public async UniTask Resolve()
        {
            if (changeCameraSpeed) CameraController.Instance.SetVelocity(cameraVelocity);
            var myTarget = cameraTarget == CameraTarget.Player ? RPGManager.refs.player.transform : target;
            CameraController.Instance.SetTarget(myTarget);
            changePlayerMobility.Resolve().Forget();
        }
    }

    [Serializable]
    public class FogSettings : IAction
    {
        [PreviewField(75)]
        [Tooltip("If null we disable fog gameobject directly")]
        public Sprite fogSprite;
        public Color fogColor = Color.white;
        public float scrollSpeedX, scrollSpeedY;
        public float transitionTime = 0f;

        [Button()]
        public void SetDefaultFogSprite()
        {
            fogSprite = RPGManager.Instance.fogData.defaultSprite;
        }

        public async UniTask Resolve()
        {
            var fogImage = RPGManager.Instance.fogData.image;
            if (fogSprite != null)
            {
                fogImage.gameObject.SetActive(true);
                fogImage.gameObject.SetActive(true);
                fogImage.sprite = fogSprite;
                fogImage.material.All1ModifyProperty("_Color", fogColor, transitionTime);
                fogImage.material.All1ModifyProperty("_TextureScrollXSpeed", scrollSpeedX, transitionTime);
                fogImage.material.All1ModifyProperty("_TextureScrollYSpeed", scrollSpeedY, transitionTime);
            }
            else
            {
                fogImage.gameObject.SetActive(false);
            }

        }
    }

    [Serializable]
    public class AddVariables : IAction
    {
        public VariableTableSet setVariables;

        public async UniTask Resolve()
        {
            RPGManager.gameState.ResolveSetVariables(setVariables);
        }
    }

    [Serializable]
    public class ShowCanvas : IAction
    {
        [ValueDropdown("UIGetCanvasList")]
        public Transform canvasT;
        public bool isVisible;

        public async UniTask Resolve()
        {
            canvasT.gameObject.SetActive(isVisible);
        }

        IEnumerable UIGetCanvasList()
        {
            foreach (Transform child in GameObject.Find("Canvas").transform)
                yield return child;
        }
    }

    [Serializable]
    public class CheckConditions : IAction
    {
        public VariableTableCondition conditionList;
        [SerializeReference]
        public List<IAction> onTrue = new(), onFalse = new();

        public async UniTask Resolve()
        {
            if (conditionList.IsAllConditionOK())
                foreach (var action in onTrue) await action.Resolve();
            else
                foreach (var action in onFalse) await action.Resolve();
        }
    }

    [Serializable]
    public class ShowText : WaitableAction, IAction
    {
        public bool hideFrame;
        public TextAnchor textAlignment = TextAnchor.UpperLeft;
        public LocalizedString localizedText;

        public async UniTask Resolve()
        {
            var dialogManager = DialogManager.Instance;

            var prevPrinterImageVisibility = dialogManager.PrinterImage.enabled;
            dialogManager.PrinterImageVisibility(!hideFrame);

            var prevTextAlign = dialogManager.Printer_Text.alignment;
            dialogManager.TextAlign(textAlignment);

            dialogManager.Show(new DialogData(await localizedText.GetLocalizedStringAsync(), callback: () =>
            {
                dialogManager.PrinterImageVisibility(prevPrinterImageVisibility);
                dialogManager.TextAlign(prevTextAlign);
            }));

            if (waitEnd) await UniTask.WaitUntil(() => dialogManager.state == State.Deactivate);
        }

    }

    [Serializable]
    public class InvokeUnityEvent : IAction
    {
        public UnityEvent unityEvent;
        public async UniTask Resolve()
        {
            unityEvent.Invoke();
        }
    }

    /// <summary>
    /// Plays a sound effect
    ///</summary>
    [Serializable]
    public class PlaySE : WaitableAction, IAction
    {
        public AudioClip clip;
        public SoundOptions soundOptions = new SoundOptions()
        {
            keepPlayingWhenDisabled = false,
            soundLoop = false,
            volume = 1f,
            spatialBlend = 1f,
            stereoPan = 0f,
            pitch = 1f
        };
        [Tooltip("If null we use MainCamera as emitter")]
        public GameObject emitter;

#if UNITY_EDITOR
        [Button("Set myself as emitter")]
        public void EmitterMyself()
        {
            emitter = Selection.activeGameObject;
        }
#endif

        [Button("Global Emitter")]
        public void EmitterGlobal()
        {
            emitter = null;
        }

        public async UniTask Resolve()
        {
            AudioManager.Instance.PlaySound(clip, soundOptions, emitter);
            await UniTask.Delay(TimeSpan.FromSeconds(clip.length), ignoreTimeScale: true);
        }
    }

    [Serializable]
    public class Await : WaitableAction, IAction
    {
        public float seconds;

        public async UniTask Resolve()
        {
            await UniTask.Delay(TimeSpan.FromSeconds(seconds), ignoreTimeScale: false);
        }
    }

    public enum TweenType { PunchScale, PunchRotation }

    [Serializable]
    public class Tween : WaitableAction, IAction
    {
        public TweenType type;
        public Vector3 punch;
        public Transform targetTransform;
        public float duration, elasticity;
        public int vibrato;
#if UNITY_EDITOR
        [Button()]
        public void TargetMyself()
        {
            targetTransform = Selection.activeGameObject.transform;
        }
#endif

        public async UniTask Resolve()
        {
            switch (type)
            {
                case TweenType.PunchScale:
                    targetTransform.DOPunchScale(punch, duration, vibrato, elasticity).ToUniTask().Forget(); break;
                case TweenType.PunchRotation:
                    targetTransform.DOPunchRotation(punch, duration, vibrato, elasticity).ToUniTask().Forget(); break;
                default:
                    return;
            }
            await UniTask.Delay(TimeSpan.FromSeconds(duration));
        }
    }

    [Serializable]
    public class AddItem : IAction
    {
        public Item item;
        [ShowIf("@item && item.isStackable")]
        public int amount;
        public async UniTask Resolve()
        {
            RPGManager.gameState.AddItem(item, amount);
        }
    }

    [Serializable]
    public class ModifyTransform : IAction
    {
        public OperationType operationType;
        public Vector3 targetPosition, targetRotation, targetScale;
        public Transform targetTransform;
        [Tooltip("Sum values instead replacing them")]
#if UNITY_EDITOR
        [Button()]
        public void TargetMyself()
        {
            targetTransform = Selection.activeGameObject.transform;
        }
#endif


        [Button()]
        public void CopyTargetValues()
        {
            targetPosition = targetTransform.position;
            targetRotation = targetTransform.rotation.eulerAngles;
            targetScale = targetTransform.localScale;
        }

        public async UniTask Resolve()
        {
            if (operationType == OperationType.Add)
            {
                targetTransform.position += targetPosition;
                targetTransform.rotation = Quaternion.Euler(targetRotation + targetTransform.rotation.eulerAngles);
                targetTransform.localScale += targetScale;
            }
            else if (operationType == OperationType.Replace)
            {
                targetTransform.position = targetPosition;
                targetTransform.rotation = Quaternion.Euler(targetRotation);
                targetTransform.localScale = targetScale;
            }
        }
    }

    [Serializable]
    public class ModifyMaterial : WaitableAction, IAction
    {
        public MeshRenderer targetRenderer;
        public Color targetColor;
        public float transitionTime;
        [Tooltip("Set a new material. Leave it null if you want to keep the existing material")]
        public Material newMaterial;

#if UNITY_EDITOR
        [Button()]
        public void TargetMyself()
        {
            targetRenderer = Selection.activeGameObject.GetComponent<MeshRenderer>();
        }
#endif

        public async UniTask Resolve()
        {
            if (newMaterial) targetRenderer.material = newMaterial;
            var material = targetRenderer.material;
            if (transitionTime > 0f)
            {
                var startTime = Time.time;
                var startColor = material.color;
                while (startTime + transitionTime > Time.time)
                {
                    var t = (Time.time - startTime) / transitionTime;
                    material.color = Color.Lerp(startColor, targetColor, t);
                    await UniTask.DelayFrame(1);
                }
            }
            material.color = targetColor;
        }
    }

    [Serializable]
    public class ChangeSprite : IAction
    {
        public SpriteRenderer targetSpriteRenderer;
        public Sprite newSprite;

#if UNITY_EDITOR
        [Button()]
        public void TargetMyself()
        {
            targetSpriteRenderer = Selection.activeGameObject.GetComponent<SpriteRenderer>();
        }
#endif

        public async UniTask Resolve()
        {
            targetSpriteRenderer.sprite = newSprite;
        }
    }

    [Serializable]
    public class TeleportPlayer : IAction
    {
        [ValueDropdown("GetSceneNameList")]
        public string mapName;
        [Range(0, 10)]
        public int mapSpawnIndex;
        public bool changeFaceDirection;
        [ShowIf("changeFaceDirection")]
        public FaceDirection newFaceDirection;

        public async UniTask Resolve()
        {
            var gameData = RPGManager.gameState;
            var playerEntity = RPGManager.refs.player;
            gameData.savedMapSpawnIndex = mapSpawnIndex;
            gameData.savedFaceDir = changeFaceDirection ? newFaceDirection : playerEntity.faceDirection;
            if (SceneManager.GetActiveScene().name == mapName)
                RPGManager.Instance.SpawnPlayer();
            else
                SceneManager.LoadScene(mapName);
        }

        public IEnumerable<string> GetSceneNameList()
        {
            var path = Application.dataPath + "/Scenes";
            var directoryInfo = new DirectoryInfo(path);
            var fileList = directoryInfo.GetFiles();
            foreach (var file in fileList)
                if (!file.Name.Contains(".meta")) yield return file.Name.Split(".unity")[0];
        }
    }

}

