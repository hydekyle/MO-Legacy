// using System;
// using UnityEngine;
// using UnityEngine.SceneManagement;
// using UnityEngine.UI;
// using RPGSystem;

// public struct GameReferences
// {
//     public Player player;
//     public Image flashScreen;
// }

// public class RPGManager : MonoBehaviour
// {
//     public static RPGManager Instance;


//     // void OnGUI()
//     // {
//     //     if (GUI.Button(new(0, 0, 100, 100), "Press me"))
//     //     {
//     //         cts.Cancel();
//     //     }
//     // }

//     void Awake()
//     {
//         if (Instance) Destroy(this.gameObject);
//         else
//         {
//             Instance = this;
//             refs.player = GameObject.Find("PLAYER").GetComponent<Player>();
//             refs.flashScreen = GameObject.Find("RPGFlashScreen").GetComponent<Image>();
//             SceneManager.activeSceneChanged += OnActiveSceneChanged;
//             transform.SetParent(null);
//             DontDestroyOnLoad(this);
//         }
//     }

//     void OnActiveSceneChanged(Scene arg0, Scene arg1)
//     {
//         try { SpawnPlayer(); } catch { print("No se encontraron Player Spawn Points"); }
//     }

//     void Update()
//     {
//         if (Input.GetKeyDown(KeyCode.F6)) _gameData.SaveGameDataSlot(0);
//         if (Input.GetKeyDown(KeyCode.F9)) _gameData.LoadGameDataSlot(0).Forget();
//         if (Input.GetKeyDown(KeyCode.F1)) Test();
//     }

//     private void Test()
//     {
//         textManager.SelectLanguage(textManager.availableLanguages[0]);
//         print(textManager.ReadLine(1));
//     }



// }
