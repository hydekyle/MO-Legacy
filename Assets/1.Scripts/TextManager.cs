using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class TextManager
{
    public List<TextAsset> availableLanguages = new();
    TextAsset selectedLanguage;
    string[] linesTXT;

    public void SelectLanguage(TextAsset languageTXT)
    {
        selectedLanguage = languageTXT;
        linesTXT = selectedLanguage.text.Split("\n");
    }

    public string ReadLine(int lineNumber)
    {
        return linesTXT[lineNumber];
    }
}
