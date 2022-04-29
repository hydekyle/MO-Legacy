using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;

public class TitleMenuManager : MonoBehaviour
{
    void Start()
    {
        WaitAndLoadMapTest();
    }

    async UniTaskVoid WaitAndLoadMapTest()
    {
        await UniTask.Delay(1000);
        SceneManager.LoadScene(1);
    }
}
