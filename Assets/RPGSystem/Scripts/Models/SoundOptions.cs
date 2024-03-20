using System;
using UnityEngine;

namespace RPGSystem
{
    [Serializable]
    public struct SoundOptions
    {
        public bool keepPlayingWhenDisabled;
        public bool soundLoop;
        [Range(0f, 1f)]
        public float volume;
        [Tooltip("0 -> 2D Sound (global)\n1 -> 3D Sound (from position)")]
        [Range(0f, 1f)]
        public float spatialBlend;
        [Range(-1f, 1f)]
        public float stereoPan;
        [Range(-3f, 3f)]
        public float pitch;
    }
}
