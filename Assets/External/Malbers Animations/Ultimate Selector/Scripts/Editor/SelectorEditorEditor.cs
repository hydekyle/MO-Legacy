using UnityEditor;
using UnityEngine;
using UnityEngine.EventSystems;

namespace MalbersAnimations.Selector
{
    [CustomEditor(typeof(SelectorEditor))]
    public class SelectorEditorEditor : Editor
    {
        SelectorEditor M;
        MonoScript script;

        SerializedProperty SelectorCamera, WorldCamera, CameraOffset, CameraPosition, CameraRotation, SelectorType1, ItemRendererType, distance, RadialAxis,
            UseWorld, LookRotation, LinearX, LinearY, LinearZ, Grid, GridWidth, GridHeight, RotationOffSet, Items, SelectorLayer;
        private void OnEnable()
        {
            M = (SelectorEditor)target;
            script = MonoScript.FromMonoBehaviour((MonoBehaviour)target);

            Items = serializedObject.FindProperty("Items");
            SelectorCamera = serializedObject.FindProperty("SelectorCamera");
            WorldCamera = serializedObject.FindProperty("WorldCamera");
            CameraOffset = serializedObject.FindProperty("CameraOffset");
            CameraPosition = serializedObject.FindProperty("CameraPosition");
            CameraRotation = serializedObject.FindProperty("CameraRotation");
            SelectorType1 = serializedObject.FindProperty("SelectorType");
            ItemRendererType = serializedObject.FindProperty("ItemRendererType");
            distance = serializedObject.FindProperty("distance");
            RadialAxis = serializedObject.FindProperty("RadialAxis");
            UseWorld = serializedObject.FindProperty("UseWorld");
            LookRotation = serializedObject.FindProperty("LookRotation");
            LinearX = serializedObject.FindProperty("LinearX");
            LinearY = serializedObject.FindProperty("LinearY");
            LinearZ = serializedObject.FindProperty("LinearZ");
            Grid = serializedObject.FindProperty("Grid");
            GridWidth = serializedObject.FindProperty("GridWidth");
            GridHeight = serializedObject.FindProperty("GridHeight");
            SelectorLayer = serializedObject.FindProperty("SelectorLayer");
            RotationOffSet = serializedObject.FindProperty("RotationOffSet");

            M.UpdateItemsList();
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            MalbersEditor.DrawDescription("Manage the distribution of all items. Items are always child of this gameObject");

            using (new GUILayout.VerticalScope(EditorStyles.helpBox))
            {
                using (var ChangeCheck = new EditorGUI.ChangeCheckScope())
                {
                    EditorGUILayout.PropertyField(SelectorCamera, new GUIContent("Selector Camera", "Camera for the selector"));
                    EditorGUILayout.PropertyField(SelectorLayer);

                    if (ChangeCheck.changed)
                    {
                        AddRaycaster();
                    }
                }

                if (SelectorCamera.objectReferenceValue != null)
                {
                    EditorGUILayout.PropertyField(WorldCamera, new GUIContent("World Spacing", "The camera is no longer child of the Selector\nIt should be child of the Main Camera, Use this when the the Selector on the hands of a character, on VR mode, etc"));

                    if (!WorldCamera.boolValue)
                    {
                        using var cac = new EditorGUI.ChangeCheckScope();
                        EditorGUILayout.PropertyField(CameraOffset, new GUIContent("Offset", "Camera Forward Offset"));
                        EditorGUILayout.PropertyField(CameraPosition, new GUIContent("Position", "Camera Position Offset"));
                        EditorGUILayout.PropertyField(CameraRotation, new GUIContent("Rotation", "Camera Rotation Offset"));


                        if (cac.changed)
                        {
                            Undo.RecordObject(target, "Change Camera Values");
                            M.SetCamera();
                            EditorUtility.SetDirty(target);
                        }
                    }
                }

                if (M.transform.childCount != M.Items.Count)
                {
                    M.UpdateItemsList();
                    EditorUtility.SetDirty(target);
                }
            }

            using (new GUILayout.VerticalScope(EditorStyles.helpBox))
            {
                using var cac = new EditorGUI.ChangeCheckScope();
                EditorGUILayout.PropertyField(SelectorType1, new GUIContent("Selector Type", "Items Distribution"));
                EditorGUILayout.PropertyField(ItemRendererType, new GUIContent("Items Type", "Items Renderer Type"));

                if (cac.changed)
                {
                    Undo.RecordObject(target, "Change Item Type ");
                    AddRaycaster();

                    Undo.RecordObject(target, "Editor Selector Changed");
                    M.LinearVector = new Vector3(M.LinearX, M.LinearY, M.LinearZ);  //Set the new linear vector

                    if (M.SelectorType == SelectorType.Custom)
                    {
                        if (EditorUtility.DisplayDialog("Use Current Distribution",
                            "Do you want to save the current distribution as a Custom Type Selector", "Yes", "No"))
                        {
                            M.StoreCustomLocation();
                        }
                    }
                    serializedObject.ApplyModifiedProperties();

                    Debug.Log("CHANFGESD TUPE");
                    M.ItemsLocation();

                    EditorUtility.SetDirty(target);
                }
            }
            GUIContent DistanceName = new("Radius", "Radius of the selector");
            using (new GUILayout.VerticalScope(EditorStyles.helpBox))
            {
                var selType = (SelectorType)SelectorType1.enumValueIndex;

                using var newChange = new EditorGUI.ChangeCheckScope();

                switch (selType)
                {
                    case SelectorType.Radial:


                        EditorGUILayout.PropertyField(distance, DistanceName);
                        EditorGUILayout.PropertyField(RadialAxis, new GUIContent("Axis", "Radial Axis"));
                        using (new GUILayout.HorizontalScope())
                        {
                            EditorGUILayout.PropertyField(UseWorld, new GUIContent("Use World Rotation", "The Items will keep the same initial Rotation"));
                            EditorGUILayout.PropertyField(LookRotation, new GUIContent("Use Look Rotation", "The items will look to the center of the selector"));
                        }
                        break;

                    case SelectorType.Linear:
                        DistanceName = new GUIContent("Distance", "Distance between objects");
                        LookRotation.boolValue = false;
                        //  EditorUtility.SetDirty(target);
                        serializedObject.ApplyModifiedProperties();
                        EditorGUILayout.PropertyField(distance, DistanceName);
                        LinearX.floatValue = EditorGUILayout.Slider(new GUIContent("Linear X"), LinearX.floatValue, -1, 1);
                        LinearY.floatValue = EditorGUILayout.Slider(new GUIContent("Linear Y"), LinearY.floatValue, -1, 1);
                        LinearZ.floatValue = EditorGUILayout.Slider(new GUIContent("Linear Z"), LinearZ.floatValue, -1, 1);
                        UseWorld.boolValue = false;
                        break;
                    case SelectorType.Grid:
                        UseWorld.boolValue = false;
                        using (new GUILayout.HorizontalScope())
                        {
                            EditorGUIUtility.labelWidth = 65;
                            EditorGUILayout.PropertyField(Grid, new GUIContent("Columns", "Ammount of the Columns for the Grid. the Rows are given my the ammount of Items"), GUILayout.MinWidth(100));
                            EditorGUIUtility.labelWidth = 15;
                            EditorGUILayout.PropertyField(GridWidth, new GUIContent("W", "Width"), GUILayout.MinWidth(50));
                            EditorGUILayout.PropertyField(GridHeight, new GUIContent("H", "Height"), GUILayout.MinWidth(50));
                            EditorGUIUtility.labelWidth = 0;
                        }
                        break;
                    case SelectorType.Custom:

                        if (GUILayout.Button(new GUIContent("Store Item Location", "Store the Initial Pos/Rot/Scale of every Item")))
                        {
                            M.StoreCustomLocation();
                        }
                        break;
                    default:
                        break;
                }

                EditorGUILayout.PropertyField(RotationOffSet, new GUIContent("Rotation Offset", "Offset for the Rotation on the Radial Selector"));


                if (newChange.changed)
                {
                    Undo.RecordObject(target, "Editor Selector Changed");
                    M.ItemsLocation();
                    serializedObject.ApplyModifiedProperties();
                    EditorUtility.SetDirty(target);
                }
            }

            using (new GUILayout.VerticalScope(EditorStyles.helpBox))
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(Items, new GUIContent("Items"), true);
                EditorGUI.indentLevel--;
            }



            M.ItemsLocation();
            serializedObject.ApplyModifiedProperties();
        }

        private void AddRaycaster()
        {
            if (SelectorCamera.objectReferenceValue != null)
            {
                DestroyImmediate(M.SelectorCamera.GetComponent<BaseRaycaster>());

                var IRenderType = (ItemRenderer)ItemRendererType.enumValueIndex;

                switch (IRenderType)
                {
                    case ItemRenderer.Mesh:
                        PhysicsRaycaster Ph = M.SelectorCamera.gameObject.AddComponent<PhysicsRaycaster>();
                        Ph.eventMask = 32;
                        break;
                    case ItemRenderer.Sprite:
                        Physics2DRaycaster Ph2d = M.SelectorCamera.gameObject.AddComponent<Physics2DRaycaster>();
                        Ph2d.eventMask = 32;
                        break;
                    case ItemRenderer.Canvas:
                        break;
                    default:
                        break;
                }
            }
        }
    }
}