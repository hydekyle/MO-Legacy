using System;
using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using JetBrains.Annotations;
using RPGSystem;
using UnityEngine;

// All1OneShader Settings Modifier
// I made this script to avoid writting same lines for different Scripts, it should exists by default ù.u
// Also added transitionTime parameter
public static class All1OneShaderModifier
{
    public static void All1ModifyProperty(this Material material, string propertyName, object targetValue, float transitionTime = 0f)
    {
        Resolve(material, propertyName, targetValue, transitionTime).Forget();
    }

    static async UniTaskVoid Resolve(Material material, string propertyName, object targetValue, float transitionTime = 0f)
    {
        var startedTime = Time.time;
        if (targetValue.GetType() == typeof(Color))
        {
            var targetColor = (Color)targetValue;
            var initialColor = material.GetColor(propertyName);

            while (Time.time - startedTime < transitionTime)
            {
                var t = (Time.time - startedTime) / transitionTime;
                material.SetColor(propertyName, Color.Lerp(initialColor, targetColor, t));
                await UniTask.Yield();
            }
        }
        else if (targetValue.GetType() == typeof(float))
        {
            var targetFloat = (float)targetValue;
            var initialValue = material.GetFloat(propertyName);

            while (Time.time - startedTime < transitionTime)
            {
                var t = (Time.time - startedTime) / transitionTime;
                material.SetFloat(propertyName, Mathf.Lerp(initialValue, targetFloat, t));
                await UniTask.Yield();
            }
        }
        // TODO: Add more types here when needed

    }
}
