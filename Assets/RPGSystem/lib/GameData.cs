using System;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using Cysharp.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityObservables;

namespace RPGSystem
{
    [Serializable]
    public class GameData
    {
        public SwitchDictionary switches = new();
        public VariableDictionary variables = new();
        public LocalVariableDictionary localVariableDic = new();
        public Inventory inventory = new();

        [HideInInspector]
        public string savedMapName;
        [HideInInspector]
        public int savedMapSpawnIndex;
        [HideInInspector]
        public Vector3 savedPosition;
        [HideInInspector]
        public FaceDirection savedFaceDir;

        public void AddItem(ScriptableItem item, int amount)
        {
            if (inventory.ContainsKey(item))
            {
                if (item.isStackable) inventory[item] += amount;
                else inventory[item] = amount;
            }
            else
            {
                inventory.Add(item, amount);
            }
        }

        public void SaveGameDataSlot(int slotIndex)
        {
            savedMapSpawnIndex = -1;
            savedPosition = RPGManager.refs.player.transform.position;
            savedFaceDir = RPGManager.refs.player.faceDirection;
            savedMapName = SceneManager.GetActiveScene().name;
            var fileName = "/savegame" + slotIndex;
            var savePath = string.Concat(Application.persistentDataPath, fileName);
            string saveData = JsonUtility.ToJson(this, true);
            BinaryFormatter bf = new BinaryFormatter();
            FileStream file = File.Create(savePath);
            bf.Serialize(file, saveData);
            file.Close();
            Debug.Log(Application.persistentDataPath);
        }

        public async UniTaskVoid LoadGameDataSlot(int slotIndex)
        {
            var fileName = "/savegame" + slotIndex;
            var savePath = string.Concat(Application.persistentDataPath, fileName);
            if (File.Exists(savePath))
            {
                BinaryFormatter bf = new BinaryFormatter();
                FileStream file = File.Open(savePath, FileMode.Open);
                JsonUtility.FromJsonOverwrite(bf.Deserialize(file).ToString(), this);
            }
            else
            {
                Debug.Log("Starting New Game");
            }
            //TODO: Remove when Title Menu is completed
            await SceneManager.LoadSceneAsync(savedMapName);
            var playerT = RPGManager.refs.player.transform;
            playerT.position = savedPosition;
            playerT.GetComponent<Entity>().LookAtDirection(savedFaceDir);
        }

        public bool GetSwitch(int ID)
        {
            try
            {
                return switches[ID].Value;
            }
            catch
            {
                SetSwitch(ID, false);
                return false;
            }
        }

        public void SubscribeToSwitchChangedEvent(int ID, Action action)
        {
            GetSwitch(ID); // This ensure the switch exist before sub
            switches[ID].OnChanged += action;
        }

        public void SubscribeToVariableChangedEvent(int ID, Action action)
        {
            GetVariable(ID);
            variables[ID].OnChanged += action;
        }

        public void SubscribeToLocalVariableChangedEvent(int gameObjectID, Action action)
        {
            GetLocalVariable(gameObjectID);
            localVariableDic[gameObjectID].OnChanged += action;
        }

        public void UnsubscribeToSwitchChangedEvent(int ID, Action action)
        {
            switches[ID].OnChanged -= action;
        }

        public void UnsubscribeToVariableChangedEvent(int ID, Action action)
        {
            variables[ID].OnChanged -= action;
        }

        public void UnsubscribeToLocalVariableChangedEvent(int gameObjectID, Action action)
        {
            localVariableDic[gameObjectID].OnChanged -= action;
        }

        public int GetVariable(int ID)
        {
            try
            {
                return variables[ID].Value;
            }
            catch
            {
                SetVariable(ID, 0);
                return 0;
            }
        }

        public int GetLocalVariable(int gameObjectID)
        {
            try
            {
                return localVariableDic[gameObjectID].Value;
            }
            catch
            {
                SetLocalVariable(gameObjectID, 0);
                return 0;
            }
        }

        public void SetSwitch(int switchID, bool value)
        {
            if (switches.ContainsKey(switchID))
                switches[switchID].Value = value;
            else
                switches[switchID] = new Observable<bool>() { Value = value };
        }

        public void SetVariable(int variableID, int value)
        {
            if (variables.ContainsKey(variableID))
                variables[variableID].Value = value;
            else
                variables[variableID] = new Observable<int>() { Value = value };
        }

        public void AddToVariable(int variableID, int value)
        {
            if (variables.ContainsKey(variableID))
                variables[variableID].Value += value;
            else
                variables[variableID] = new Observable<int>() { Value = value };
        }

        public void SetLocalVariable(int gameObjectID, int value)
        {
            if (localVariableDic.ContainsKey(gameObjectID))
                localVariableDic[gameObjectID].Value = value;
            else
                localVariableDic[gameObjectID] = new Observable<int>() { Value = value };
        }

        public void AddToLocalVariable(int gameObjectID, int value)
        {
            if (localVariableDic.ContainsKey(gameObjectID))
                localVariableDic[gameObjectID].Value += value;
            else
                localVariableDic[gameObjectID] = new Observable<int>() { Value = value };
        }

        public void ResolveSetVariables(VariableTableSet vTable)
        {
            foreach (var sw in vTable.switchTable) SetSwitch(sw.ID(), sw.value);
            foreach (var va in vTable.setVariableTable)
            {
                switch (va.setType)
                {
                    case VariableSetType.Set: SetVariable(va.ID(), va.value); break;
                    case VariableSetType.Add: AddToVariable(va.ID(), va.value); break;
                    case VariableSetType.Sub: AddToVariable(va.ID(), -va.value); break;
                    case VariableSetType.Multiply: SetVariable(va.ID(), GetVariable(va.ID()) * va.value); break;
                    case VariableSetType.Random: SetVariable(va.ID(), UnityEngine.Random.Range(va.value, va.max)); break;
                }
            }
            foreach (var lv in vTable.setLocalVariableTable)
            {
                switch (lv.setType)
                {
                    case VariableSetType.Set: SetLocalVariable(lv.ID(), lv.value); break;
                    case VariableSetType.Add: AddToLocalVariable(lv.ID(), lv.value); break;
                    case VariableSetType.Sub: AddToLocalVariable(lv.ID(), -lv.value); break;
                    case VariableSetType.Multiply: SetVariable(lv.ID(), GetVariable(lv.ID()) * lv.value); break;
                    case VariableSetType.Random: SetVariable(lv.ID(), UnityEngine.Random.Range(lv.value, lv.max)); break;
                }
            }
        }
    }

}