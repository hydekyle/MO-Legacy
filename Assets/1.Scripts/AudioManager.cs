using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance;
    public AudioMixerGroup mixerSFX;
    public AudioSource audioMusic, audioSFX;
    Dictionary<int, AudioSource> audioSources = new Dictionary<int, AudioSource>();

    void Awake()
    {
        if (Instance) Destroy(this);
        else
        {
            Instance = this;
        }
    }

    public static void StopMusic()
    {
        Instance.audioMusic.Stop();
    }

    public static void PlaySound(AudioClip soundClip)
    {
        Instance.audioSFX.PlayOneShot(soundClip);
    }

    /// <summary>Creates a GameObject for each emmiter so sounds still playing even if the GameObject is disabled</summary>
    public static void PlaySoundFromGameobject(AudioClip soundClip, GameObject emitter)
    {
        var emitterID = emitter.GetHashCode();
        if (Instance.audioSources.ContainsKey(emitterID))
        {
            var audioSource = Instance.audioSources[emitterID];
            audioSource.transform.position = emitter.transform.position;
            audioSource.PlayOneShot(soundClip);
        }
        else
        {
            var go = new GameObject();
            go.transform.SetParent(Instance.transform);
            var newAudioSource = go.AddComponent<AudioSource>();
            newAudioSource.outputAudioMixerGroup = Instance.mixerSFX;
            go.transform.position = emitter.transform.position;
            Instance.audioSources[emitterID] = newAudioSource;
            newAudioSource.PlayOneShot(soundClip);
        }
    }
}
