using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;

namespace MalbersAnimations.Selector
{
    [CustomEditor(typeof(SelectorController))]
    public class SelectorControllerEditor : Editor
    {
        SelectorController M;
        SelectorEditor E;
        MonoScript script;

        SerializedProperty RestoreTime, AnimateSelection, SoloSelection, SelectionTime, SelectionCurve, DragSpeed, dragHorizontal, inertia, inertiaTime, minInertiaSpeed, inertiaCurve, debug, FocusedItemIndex, ExternalSelectItem,
            UseSelectionZone, Hover, EditorIdleAnims, MoveIdle, RotateIdle, ScaleIdle, MoveIdleAnim, ItemRotationSpeed, TurnTableVector, ScaleIdleAnim, LockMaterial, frame_Camera, frame_Multiplier,
            EditorAdvanced, ClickToFocus, ChangeOnEmptySpace, Threshold, EditorShowEvents, OnClickOnItem,  OnIsChangingItem
            //ignoreTimeScale
            ;
        private void OnEnable()
        {
            M = (SelectorController)target;
            E = M.GetComponent<SelectorEditor>();
            script = MonoScript.FromMonoBehaviour((MonoBehaviour)target);

            AnimateSelection = serializedObject.FindProperty("AnimateSelection");
            debug = serializedObject.FindProperty("debug");
            OnIsChangingItem = serializedObject.FindProperty("OnIsChangingItem");
            OnClickOnItem = serializedObject.FindProperty("OnClickOnItem");
            EditorShowEvents = serializedObject.FindProperty("EditorShowEvents");
            Threshold = serializedObject.FindProperty("Threshold");
            ClickToFocus = serializedObject.FindProperty("ClickToFocus");
            ChangeOnEmptySpace = serializedObject.FindProperty("ChangeOnEmptySpace");
            EditorAdvanced = serializedObject.FindProperty("EditorAdvanced");
            frame_Multiplier = serializedObject.FindProperty("frame_Multiplier");
            frame_Camera = serializedObject.FindProperty("frame_Camera");
            LockMaterial = serializedObject.FindProperty("LockMaterial");
            ScaleIdleAnim = serializedObject.FindProperty("ScaleIdleAnim");
            TurnTableVector = serializedObject.FindProperty("TurnTableVector");
            ItemRotationSpeed = serializedObject.FindProperty("ItemRotationSpeed");
            MoveIdleAnim = serializedObject.FindProperty("MoveIdleAnim");
            ScaleIdle = serializedObject.FindProperty("ScaleIdle");
            RotateIdle = serializedObject.FindProperty("RotateIdle");
            MoveIdle = serializedObject.FindProperty("MoveIdle");
            EditorIdleAnims = serializedObject.FindProperty("EditorIdleAnims");
            Hover = serializedObject.FindProperty("Hover");
            UseSelectionZone = serializedObject.FindProperty("UseSelectionZone");
            inertiaCurve = serializedObject.FindProperty("inertiaCurve");
            minInertiaSpeed = serializedObject.FindProperty("minInertiaSpeed");
            inertiaTime = serializedObject.FindProperty("inertiaTime");
            inertia = serializedObject.FindProperty("inertia");
            DragSpeed = serializedObject.FindProperty("DragSpeed");
            dragHorizontal = serializedObject.FindProperty("dragHorizontal");
            SelectionTime = serializedObject.FindProperty("SelectionTime");
            SelectionCurve = serializedObject.FindProperty("SelectionCurve");
            SoloSelection = serializedObject.FindProperty("SoloSelection");
            RestoreTime = serializedObject.FindProperty("RestoreTime");
            FocusedItemIndex = serializedObject.FindProperty("focusedItemIndex");
            ExternalSelectItem = serializedObject.FindProperty("externalSelectItem");
         //   ignoreTimeScale = serializedObject.FindProperty("ignoreTimeScale");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update(); 

            MalbersEditor.DrawDescription("All the selector actions and animations are managed here");

            EditorGUI.BeginChangeCheck();
            // EditorGUILayout.BeginVertical(MalbersEditor.StyleGray);
            {
                MalbersEditor.DrawScript(script);

                using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                {
                   // EditorGUILayout.PropertyField(ignoreTimeScale, new GUIContent("Ignore Time Scale", "Ignore the Time Scale when the Selector is Open"));
                    EditorGUILayout.PropertyField(ExternalSelectItem, new GUIContent("External SelectItem", "SelectItem will be called from other script or event"));

                    EditorGUILayout.PropertyField(FocusedItemIndex, new GUIContent("Focused Item", "Index of the first Item to appear on Focus (Zero Index Based)"));

                    if (M.FocusedItemIndex == -1) EditorGUILayout.HelpBox("-1 Means no item is selected", MessageType.Info);
                    if (M.FocusedItemIndex < -1) M.FocusedItemIndex = -1;

                    EditorGUILayout.PropertyField(RestoreTime, new GUIContent("Restore Time", "Time to restore the previuous item to his original position"));
                }


                using (new GUILayout.HorizontalScope())
                {

                    AnimateSelection.boolValue = GUILayout.Toggle(AnimateSelection.boolValue, new GUIContent("Animate Selection", "Animate the selection between items"), EditorStyles.toolbarButton);
                    SoloSelection.boolValue = !AnimateSelection.boolValue;

                    SoloSelection.boolValue = GUILayout.Toggle(SoloSelection.boolValue, new GUIContent("Solo Selection", "Animate the selection between items"), EditorStyles.toolbarButton);
                    AnimateSelection.boolValue = !SoloSelection.boolValue;
                }
               

                if (AnimateSelection.boolValue)
                {
                    // EditorGUILayout.BeginVertical(MalbersEditor.StyleGreen);
                    MalbersEditor.DrawDescription("The Selector Controller will move and rotate to center the selected Item");
                    //EditorGUILayout.HelpBox("The Selector Controller will move and rotate to center the selected Item", MessageType.None);
                    //EditorGUILayout.EndVertical();


                    using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                    {
                        EditorGUILayout.PropertyField(SelectionTime, new GUIContent("Selection Time", "Time between the selection among the objects"));

                        if (SelectionTime.floatValue < 0) SelectionTime.floatValue = 0; //Don't put time below zero;

                        if (SelectionTime.floatValue != 0)
                            EditorGUILayout.PropertyField(SelectionCurve, new GUIContent("Selection Curve", "Timing of the selection animation"));


                        using (new GUILayout.HorizontalScope())
                        {
                            EditorGUILayout.PropertyField(DragSpeed, new GUIContent("Drag Speed", "Swipe speed when swiping  :)"));
                            if (DragSpeed.floatValue != 0)
                                dragHorizontal.boolValue = GUILayout.Toggle(dragHorizontal.boolValue, new GUIContent(dragHorizontal.boolValue ? "Horizontal" : "Vertical", "Drag/Swipe type from the mouse/touchpad "), EditorStyles.popup);
                        }
                        
                        if (DragSpeed.floatValue == 0) EditorGUILayout.HelpBox("Drag is disabled", MessageType.Info);
                    }
                    

                    if (DragSpeed.floatValue != 0)
                    {
                        using (new GUILayout.VerticalScope(EditorStyles.helpBox)) 
                        {
                            EditorGUILayout.PropertyField(inertia, new GUIContent("Inertia", "Add inertia when Draging is enabled and the mouse is released"));

                            if (inertia.boolValue)
                            {
                                EditorGUILayout.PropertyField(inertiaTime, new GUIContent("Inertia Time", "The time on inertia when the Drag is released"));
                                EditorGUILayout.PropertyField(minInertiaSpeed, new GUIContent("Inertia Min Speed", "Min Speed to apply inertia"));
                                EditorGUILayout.PropertyField(inertiaCurve, new GUIContent("Inertia Curve", "the Curve for the time inertia"));
                            }
                        }


                        using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                        {
                            EditorGUILayout.PropertyField(UseSelectionZone, new GUIContent("Use Selection Zone", "Add inertia when Draging is enabled and the mouse is released"));

                            if (UseSelectionZone.boolValue)
                            { 
                                EditorGUILayout.PropertyField(serializedObject.FindProperty("ZMinX"), new GUIContent("Min X", "Region enableed for the Dragging/Swapping"));
                                EditorGUILayout.PropertyField(serializedObject.FindProperty("ZMaxX"), new GUIContent("Max X", "Region enableed for the Dragging/Swapping"));
                                EditorGUILayout.PropertyField(serializedObject.FindProperty("ZMinY"), new GUIContent("Min Y", "Region enableed for the Dragging/Swapping"));
                                EditorGUILayout.PropertyField(serializedObject.FindProperty("ZMaxY"), new GUIContent("Max Y", "Region enableed for the Dragging/Swapping"));
                            }
                        }
                        
                    }
                }

                if (SoloSelection.boolValue)
                {
                  
                    using (new GUILayout.VerticalScope(MalbersEditor.StyleGreen))
                        EditorGUILayout.HelpBox("The Selector Controller will not move", MessageType.None);

                    using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                        EditorGUILayout.PropertyField(Hover, new GUIContent("Hover Selection", "Select by hovering the mouse over an item"));
                    
                }

                using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                {
                    EditorGUI.indentLevel++;
                    EditorIdleAnims.boolValue = EditorGUILayout.Foldout(EditorIdleAnims.boolValue, "Idle Animations");
                    EditorGUI.indentLevel--;

                    if (EditorIdleAnims.boolValue)
                    {
                        using (new GUILayout.HorizontalScope())
                        {
                            MoveIdle.boolValue = GUILayout.Toggle(MoveIdle.boolValue, new GUIContent("Move", "Repeating moving motion for the focused item"), EditorStyles.miniButton);
                            RotateIdle.boolValue = GUILayout.Toggle(RotateIdle.boolValue, new GUIContent("Rotate", "Turning table for the focused item"), EditorStyles.miniButton);
                            ScaleIdle.boolValue = GUILayout.Toggle(ScaleIdle.boolValue, new GUIContent("Scale", "Repeating scale motion for the focused item"), EditorStyles.miniButton);
                        }


                        if (MoveIdle.boolValue)
                        {
                            using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                                EditorGUILayout.PropertyField(MoveIdleAnim, new GUIContent("Move Idle", "Idle Move Animation when is on focus"));

                        }
                        if (M.RotateIdle)
                        {
                            using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                            {
                                EditorGUILayout.PropertyField(ItemRotationSpeed, new GUIContent("Speed", "How fast the focused Item will rotate"));
                                EditorGUILayout.PropertyField(TurnTableVector, new GUIContent("Rotation Vector", "Choose your desire vector to rotate around"));
                            }

                        }

                        if (M.ScaleIdle)
                        {
                            using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                                EditorGUILayout.PropertyField(ScaleIdleAnim, new GUIContent("Scale Idle", "Idle Scale Animation when is on focus"));

                        }
                    }
                }
                

                using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                {
                    EditorGUILayout.PropertyField(LockMaterial, new GUIContent("Lock Material", "Material choosed for the locked objects"));

                    using (new GUILayout.HorizontalScope())
                    {
                        EditorGUIUtility.labelWidth = 95;

                        if (E && E.SelectorCamera)
                        {
                            EditorGUILayout.PropertyField(frame_Camera, new GUIContent("Frame Camera", " Auto Adjust the camera position by the size of the object"), GUILayout.MinWidth(20));
                            if (frame_Camera.boolValue)
                            {
                                EditorGUIUtility.labelWidth = 55;
                                EditorGUILayout.PropertyField(frame_Multiplier, new GUIContent("Multiplier", "Distance Mupltiplier for the camera frame"), GUILayout.MaxWidth(100));
                            }
                        }
                        EditorGUIUtility.labelWidth = 0;
                    }
                }


                using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                {
                    EditorGUI.indentLevel++;
                    EditorAdvanced.boolValue = EditorGUILayout.Foldout(EditorAdvanced.boolValue, "Advanced");

                    if (EditorAdvanced.boolValue)
                    {
                        if (!Hover.boolValue)
                            EditorGUILayout.PropertyField(ClickToFocus, new GUIContent("Click to Focus", "If a another item is touched/clicked, focus on it"));

                        EditorGUILayout.PropertyField(ChangeOnEmptySpace, new GUIContent("Change on Empty Space", "If there's a Click/Touch on an empty space change to the next/previous item"));
                        EditorGUILayout.PropertyField(Threshold, new GUIContent("Threshold", "Max Threshold to identify if is a click/touch or a drag/swipe"));
                    }
                    EditorGUI.indentLevel--;
                }
                

                using (new GUILayout.VerticalScope(EditorStyles.helpBox))
                {
                    EditorGUI.indentLevel++;
                    EditorShowEvents.boolValue = EditorGUILayout.Foldout(EditorShowEvents.boolValue, "Events");
                    EditorGUI.indentLevel--;

                    if (EditorShowEvents.boolValue)
                    {
                        EditorGUILayout.PropertyField(OnClickOnItem, new GUIContent("On Click/Touch an Item"));
                       
                        if (AnimateSelection.boolValue)
                            EditorGUILayout.PropertyField(OnIsChangingItem, new GUIContent("Is Changing Item"));
                    }
                }
                

                EditorGUILayout.PropertyField(debug);

            }
            // EditorGUILayout.EndVertical();


            if (EditorGUI.EndChangeCheck())
            {
                Undo.RecordObject(target, "Selector Controller Inspector");
                //EditorUtility.SetDirty(target);
            }
            serializedObject.ApplyModifiedProperties();
        }
    }
}