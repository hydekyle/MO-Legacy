using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

namespace RPGSystem
{
    [Serializable]
    public class AudioManager
    {
        public AudioMixerGroup mixerSFX, mixerMusic;
        AudioSource audioMusic;
        Dictionary<int, AudioSource> audioSources = new Dictionary<int, AudioSource>();

        public void StopMusic()
        {
            audioMusic.Stop();
        }

        public void PlaySound(AudioClip soundClip, SoundOptions soundOptions, GameObject emitter = null)
        {
            if (soundOptions.keepPlayingWhenDisabled)
            {
                PlaySoundFromGameobjectDisabled(soundClip, soundOptions, emitter);
                return;
            }
            if (emitter == null)
            {
                PlaySound(soundClip, soundOptions, Camera.main.gameObject);
            }
            else if (emitter.TryGetComponent<AudioSource>(out AudioSource audioSource))
            {
                Play(audioSource, soundClip, soundOptions, emitter);
            }
            else
            {
                var newAudioSource = emitter.AddComponent<AudioSource>();
                Play(newAudioSource, soundClip, soundOptions, emitter);
            }

            void Play(AudioSource audioSource, AudioClip soundClip, SoundOptions soundOptions, GameObject emitter = null)
            {
                audioSource.outputAudioMixerGroup = mixerSFX;
                audioSource.loop = soundOptions.soundLoop;
                audioSource.spatialBlend = soundOptions.spatialBlend;
                audioSource.volume = soundOptions.volume;
                audioSource.panStereo = soundOptions.stereoPan;
                audioSource.pitch = soundOptions.pitch;
                audioSource.PlayOneShot(soundClip);
            }
        }

        /// <summary>
        /// Creates a GameObject with an AudioSource for every individual emmiter, so sounds still playing even if the GameObject is disabled.
        /// Only use this function if the gameobject can be disabled while playing sound since it produces garbage
        /// </summary>
        void PlaySoundFromGameobjectDisabled(AudioClip soundClip, SoundOptions soundOptions, GameObject emitter)
        {
            var emitterID = emitter.GetHashCode();
            if (audioSources.ContainsKey(emitterID))
            {
                var audioSource = audioSources[emitterID];
                audioSource.transform.position = emitter.transform.position;
                audioSource.PlayOneShot(soundClip);
            }
            else
            {
                var go = new GameObject();
                //go.transform.SetParent(RPGManager.Instance.transform);
                go.transform.position = emitter.transform.position;
                go.name = String.Concat("[RPG] AudioSource " + emitter.name);
                var newAudioSource = go.AddComponent<AudioSource>();
                audioSources[emitterID] = newAudioSource;
                PlaySound(soundClip, soundOptions, go);
            }
        }
    }

}