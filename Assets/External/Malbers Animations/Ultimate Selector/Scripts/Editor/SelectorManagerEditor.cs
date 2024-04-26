using UnityEngine;
using UnityEngine.Events;
using System.Collections;
using UnityEditor;
using UnityEditor.Events;
using MalbersAnimations.Events;

namespace MalbersAnimations.Selector
{
    [CustomEditor(typeof(SelectorManager))]
    public class SelectorManagerEditor : Editor
    {
        SelectorManager M;
       // MonoScript script;


        SerializedProperty enableSelector, DontDestroy, ItemSelected, OriginalItemSelected, 
            InstantiateItems, SpawnPoint, RemoveLast, DontDestroySelectedItem, LoadItemSet,
            CloseOnSelected,
            ShowAnims, Target, EnterAnimation, ExitAnimation, Data, OnSelected, OnOpen, 
            OnClosed, OnDataChanged, ShowEvents, OnItemFocused, FocusItemAnim, SubmitItemAnim,ignoreTimeScale;

        bool DataHelp = false;
        //bool EventHelp = false;

        private void OnEnable()
        {
            M = (SelectorManager)target;
            //  script = MonoScript.FromMonoBehaviour((MonoBehaviour)target);
            enableSelector = serializedObject.FindProperty("enableSelector");
            LoadItemSet = serializedObject.FindProperty("LoadItemSet");
            DontDestroy = serializedObject.FindProperty("DontDestroy");
            ItemSelected = serializedObject.FindProperty("ItemSelected");
            OriginalItemSelected = serializedObject.FindProperty("OriginalItemSelected");
            InstantiateItems = serializedObject.FindProperty("InstantiateItems");
            SpawnPoint = serializedObject.FindProperty("SpawnPoint");
            RemoveLast = serializedObject.FindProperty("RemoveLast");
            DontDestroySelectedItem = serializedObject.FindProperty("DontDestroySelectedItem");
            ShowAnims = serializedObject.FindProperty("ShowAnims");
            Target = serializedObject.FindProperty("Target");
            EnterAnimation = serializedObject.FindProperty("EnterAnimation");
            ExitAnimation = serializedObject.FindProperty("ExitAnimation");
            FocusItemAnim = serializedObject.FindProperty("FocusItemAnim");
            SubmitItemAnim = serializedObject.FindProperty("SubmitItemAnim");
            Data = serializedObject.FindProperty("Data");
            OnSelected = serializedObject.FindProperty("OnSelected");
            OnOpen = serializedObject.FindProperty("OnOpen");
            OnClosed = serializedObject.FindProperty("OnClosed");
            OnDataChanged = serializedObject.FindProperty("OnDataChanged");

            OnItemFocused = serializedObject.FindProperty("OnItemFocused");
            CloseOnSelected = serializedObject.FindProperty("CloseOnSelected");

            ShowEvents = serializedObject.FindProperty("ShowEvents");

            ignoreTimeScale = serializedObject.FindProperty("ignoreTimeScale");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            MalbersEditor.DrawDescription("Selector Manager. Require Selector Editor, Controller and Items");

            EditorGUI.BeginChangeCheck();
            {
                using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                {
                    EditorGUILayout.PropertyField(ignoreTimeScale, new GUIContent("Ignore Time Scale", "Ignore the Time Scale when the Selector is Open"));
                    if (!Application.isPlaying)
                    {
                        EditorGUILayout.PropertyField(enableSelector,
                            new GUIContent(M.enableSelector.Value ? "Open on Awake" : "Closed on Awake", "Initial State of the selector"));
                    }
                    else
                    {
                        EditorGUILayout.LabelField(M.enableSelector.Value ? "OPEN" : "CLOSED", EditorStyles.largeLabel);
                    }

                    EditorGUILayout.PropertyField(DontDestroy,
                        new GUIContent("Don't destroy on Load", "Set the Selector to not be destroyed automatically when loading a new scene."));
                    EditorGUILayout.PropertyField(CloseOnSelected);
                }
               
                using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                    EditorGUILayout.PropertyField(LoadItemSet, new GUIContent("Load Item Set", "Loads a new Set of Items at the start of the Selector"));
              


                if (Application.isPlaying)
                {
                    using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                    {
                        using (new EditorGUI.DisabledGroupScope(true))
                        {
                            EditorGUILayout.PropertyField(ItemSelected, new GUIContent("Item", "Item Holder"));
                            EditorGUILayout.PropertyField(OriginalItemSelected, new GUIContent("Original GO", "Original Game Object"));
                        }
                    }
                }


                using (new GUILayout.VerticalScope(EditorStyles.helpBox))

                {
                    EditorGUILayout.PropertyField(InstantiateItems,
                    new GUIContent("Instantiate Items", "Insantiate the original prefab of the selected item\n If no Transform is selected, it will instantiate on (0,0,0)"));


                    if (M.InstantiateItems.Value)
                    {
                        EditorGUILayout.PropertyField(SpawnPoint, new GUIContent("Spawn Point", "Spawn Point to Instantiate the items, if empty it will spawn it into(0, 0, 0)"), GUILayout.MinWidth(80));
                    }



                    if (M.InstantiateItems.Value)
                    {
                        EditorGUILayout.PropertyField(RemoveLast,
                            new GUIContent("Remove Last Spawn", "Remove the Last Spawned Object"));

                        EditorGUILayout.PropertyField(DontDestroySelectedItem,
                            new GUIContent("Don't Destroy Selected", "Makes the Selected Item not be destroyed automatically when loading a new scene."));
                    }
                }


                using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                {
                    if (MalbersEditor.Foldout(ShowAnims, "Transform Animations"))
                    {
                        EditorGUILayout.PropertyField(Target, new GUIContent("Items Root", "This is the Root Transform for the items to animate for Opening & Closing the selector"), GUILayout.MinWidth(50));

                        if (Target.objectReferenceValue != null)
                        {
                            EditorGUILayout.PropertyField(EnterAnimation, new GUIContent("Open", "Plays an animation on enter"), GUILayout.MinWidth(50));
                            EditorGUILayout.PropertyField(ExitAnimation, new GUIContent("Close", "Plays an animation on exit"), GUILayout.MinWidth(50));
                        }
                        EditorGUILayout.PropertyField(FocusItemAnim, new GUIContent("Focused Anim", "Plays an Transform Animation on the Focused Item"), GUILayout.MinWidth(50));
                        EditorGUILayout.PropertyField(SubmitItemAnim, new GUIContent("Sumbit Anim", "Plays an Transform Animation when Submit is called"), GUILayout.MinWidth(50));
                    }
                }

                using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                {
                    using (new GUILayout.HorizontalScope())
                    {
                        EditorGUILayout.PropertyField(Data, new GUIContent("Data", "This is an Scriptable Object to save all the important values of the Selector\n You can enable 'Use PlayerPref' and save the data there, but is recommended to use a Better and secure  'Saving System'"));
                        DataHelp = GUILayout.Toggle(DataHelp, "?", EditorStyles.miniButton, GUILayout.MaxWidth(20));
                    }


                    if (Data.objectReferenceValue != null)
                    {

                        M.Data.Save.Coins = EditorGUILayout.IntField(new GUIContent("Coins", "Amount of coins"), M.Data.Save.Coins);
                        M.Data.usePlayerPref = EditorGUILayout.ToggleLeft(new GUIContent("Use PlayerPref to Save Data", "Enable it to persistent save the Data using PlayerPref Class, but is recommended to use a better and secure 'Saving System' and connect it to the Data Asset"), M.Data.usePlayerPref);
                    }

                    if (DataHelp)
                    {
                        EditorGUILayout.HelpBox("Data is a [Scriptable Asset] used to save all the important values of the Selector, like Coins, Locked Items, Item Amount." +
                            "\nYou can enable 'Use PlayerPref' to persistent save the Data using that method." +
                            "Its recomended to use a better and secure 'Saving System' and connect it to the Data Asset", MessageType.None);
                    }


                    using (new GUILayout.HorizontalScope())
                    {
                        if (Data.objectReferenceValue != null)
                        {
                            if (GUILayout.Button(new GUIContent("Save Default Data", "Store all the Items Values and Coins as the Restore/Default Data")))
                            {
                                M.SaveDefaultData();
                                if (Data.objectReferenceValue != null)
                                {
                                    EditorUtility.SetDirty(M.Data);
                                }
                            }

                            if (GUILayout.Button(new GUIContent("Restore Data", "Restore all the values from  to the Default Data")))
                            {
                                M.RestoreToDefaultData();
                                if (Data.objectReferenceValue != null)
                                {
                                    EditorUtility.SetDirty(M.Data);
                                }
                            }
                        }
                    }
                }


                using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                {
                    if (MalbersEditor.Foldout(ShowEvents, "Events"))
                    {
                        EditorGUILayout.PropertyField(OnSelected);
                        EditorGUILayout.PropertyField(OnItemFocused);
                        EditorGUILayout.PropertyField(OnOpen);
                        EditorGUILayout.PropertyField(OnClosed);

                        if (Data.objectReferenceValue != null)
                        {
                            EditorGUILayout.PropertyField(OnDataChanged);
                        }
                    }
                }
               
            }

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RegisterCompleteObjectUndo(M, "Manager Values Changed");
            }
            serializedObject.ApplyModifiedProperties();
        }
    }
}
