using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace RPGSystem
{
    public static class RPGFileManager
    {
        static readonly string switchesPath = Application.dataPath + "/RPGSystem/Assets/switches.txt";
        static readonly string variablesPath = Application.dataPath + "/RPGSystem/Assets/variables.txt";

        public static IEnumerable<string> UIReadSwitchesFromTXT()
        {
            if (!File.Exists(switchesPath)) File.Create(switchesPath);
            var dataLines = File.ReadAllLines(switchesPath);
            foreach (var line in dataLines) yield return line;
        }

        public static IEnumerable<string> UIReadVariablesFromTXT()
        {
            if (!File.Exists(variablesPath)) File.Create(variablesPath);
            var dataLines = File.ReadAllLines(variablesPath);
            foreach (var line in dataLines) yield return line;
        }

    }
}