using System;
using System.Collections;
using System.Collections.Generic;
using Doublsb.Dialog;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace RPGSystem
{
    [Serializable]
    public struct GameReferences
    {
        public Player player;
        public Image flashScreen;
    }

    [Serializable]
    public class RPGManager : MonoBehaviour
    {
        public static RPGManager Instance;

        public static AudioManager AudioManager { get => RPGManager.Instance.audioManager; }
        public AudioManager audioManager;

        public static DialogManager DialogManager { get => RPGManager.Instance.dialogManager; }
        public DialogManager dialogManager;

        public static GameReferences refs = new();
        public GameData gameData = new();

        public bool isInteractionAvailable = true;
        public bool isMovementAvailable = true;


        private void Awake()
        {
            if (Instance != null) Destroy(this.gameObject);
            else
            {
                Instance = this;
                DontDestroyOnLoad(this.gameObject);
                refs.player = GameObject.Find("PLAYER").GetComponent<Player>();
                refs.flashScreen = GameObject.Find("RPGFlashScreen").GetComponent<Image>();
                SceneManager.activeSceneChanged += OnActiveSceneChanged;
            }
        }

        void Update()
        {
            if (Input.GetButtonDown("Interact")) dialogManager.Click_Window();
            if (Input.GetKeyDown(KeyCode.F6)) gameData.SaveGameDataSlot(0);
            if (Input.GetKeyDown(KeyCode.F9)) gameData.LoadGameDataSlot(0).Forget();
        }

        void OnActiveSceneChanged(Scene arg0, Scene arg1)
        {
            try { SpawnPlayer(); } catch { print("No se encontraron Player Spawn Points"); }
        }

        public void SpawnPlayer()
        {
            refs.player.LookAtDirection(gameData.savedFaceDir);
            refs.player.transform.position = gameData.savedMapSpawnIndex >= 0 ?
                GameObject.Find("[SPAWN]").transform.GetChild(gameData.savedMapSpawnIndex).position
                : gameData.savedPosition;
            CameraController.SetPosition(refs.player.transform.position);
        }
    }

}