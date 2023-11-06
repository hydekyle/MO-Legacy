using System;
using System.Collections;
using System.Collections.Generic;
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
        public static bool isInteractionAvailable = true;
        public static bool isMovementAvailable = true;
        public static AudioManager AudioManager { get => RPGManager.Instance.audioManager; }
        public AudioManager audioManager;
        public static GameData GameData { get => _gameData; }
        public static GameData _gameData = new();
        public static GameReferences refs = new();
        public TextManager textManager;

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
            if (Input.GetKeyDown(KeyCode.F6)) _gameData.SaveGameDataSlot(0);
            if (Input.GetKeyDown(KeyCode.F9)) _gameData.LoadGameDataSlot(0).Forget();
        }

        void OnActiveSceneChanged(Scene arg0, Scene arg1)
        {
            try { SpawnPlayer(); } catch { print("No se encontraron Player Spawn Points"); }
        }

        public void SpawnPlayer()
        {
            refs.player.LookAtDirection(_gameData.savedFaceDir);
            refs.player.transform.position = _gameData.savedMapSpawnIndex >= 0 ?
                GameObject.Find("[SPAWN]").transform.GetChild(_gameData.savedMapSpawnIndex).position
                : _gameData.savedPosition;
            CameraController.SetPosition(refs.player.transform.position);
        }
    }

}