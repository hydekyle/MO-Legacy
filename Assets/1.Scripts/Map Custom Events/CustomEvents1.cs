using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class CustomEvents1 : MonoBehaviour
{
    public AudioClip testSound;
    public Image red;

    public async void _EnterDoor1()
    {
        AudioManager.PlaySound(testSound);
        red.gameObject.SetActive(true);
        AudioManager.StopMusic();
        await UniTask.Delay(3333);
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }

}
