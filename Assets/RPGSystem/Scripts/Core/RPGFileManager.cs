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
            var dataLines = File.ReadAllLines(switchesPath);

            foreach (var line in dataLines)
            {
                yield return line;
            }
        }

        public static IEnumerable<string> UIReadVariablesFromTXT()
        {
            var dataLines = File.ReadAllLines(variablesPath);

            foreach (var line in dataLines)
            {
                yield return line;
            }
        }

        public static void CreateSwitchesFileIfNeeded()
        {
            if (!File.Exists(switchesPath)) File.Create(switchesPath);
        }

        public static void CreateVariablesFileIfNeeded()
        {
            if (!File.Exists(variablesPath)) File.Create(variablesPath);
        }
    }
}