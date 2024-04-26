using MalbersAnimations.Scriptables;
using System.Collections.Generic;
using System.Linq;
using UnityEngine; 

namespace MalbersAnimations.Selector
{
    public enum SelectorType { Radial, Linear, Grid, Custom }
    public enum RadialAxis { Up, Right, Forward }
    public enum ItemRenderer { Mesh, Sprite, Canvas }

    [ExecuteInEditMode]
    [HelpURL("https://malbersanimations.gitbook.io/animal-controller/ultimate-selector/selector-editor")]
    [AddComponentMenu("Malbers/Ultimate Selector/Selector Editor")]

    public class SelectorEditor : MonoBehaviour
    {
        public Camera SelectorCamera;  //Get the Camera 
        public StringReference SelectorLayer = new("UI");
        public bool WorldCamera = false;
        public float CameraOffset = 2f;
        public Vector3 CameraPosition;
        public Vector3 CameraRotation;

        public bool createColliders = true;

        public List<MItem> Items;
        public SelectorType SelectorType;
        public ItemRenderer ItemRendererType = ItemRenderer.Mesh;
        public RadialAxis RadialAxis = RadialAxis.Up;

        public float distance = 3f;
        public float LinearX = 1, LinearY = 1, LinearZ = 1;
        /// <summary>It will keep always looking forward on the radial Style </summary>
        public bool UseWorld = true;
        /// <summary> this will keep always looking forward on the radial Style </summary>
        public bool LookRotation;
        public Vector3 RotationOffSet;

        [Min(1)]
        public int Grid = 6;
        public float GridWidth = 1;
        public float GridHeight = 1;

        public Vector3 LinearVector;

        private SelectorController controller;

        public SelectorController Controller
        {
            get
            {
                if (!controller) controller = GetComponentInChildren<SelectorController>();
                return controller;
            }
        }

        protected float angle = 0f;

        /// <summary>  Angle distance between items </summary>
        public float Angle => angle;

        //void Awake()
        //{
        //    UpdateItemsList();
        //}

        //THIS UPDATE IS FOR THE EDITOR TO CHECK ALL THE ITEMS
        void Update()
        {
            if (Application.isPlaying) return;
            UpdateItemsList();
        }

        //-----------------------------------Set the Camera Position----------------------------------
        public void SetCamera()
        {
            if (SelectorCamera)
            {
                SelectorCamera.transform.rotation = Quaternion.Euler(0, 0, 0);
                SelectorCamera.transform.eulerAngles += (CameraRotation);
                SelectorCamera.transform.localPosition = CameraPosition + SelectorCamera.transform.forward * CameraOffset;
            }
        }

        public void StoreCustomLocation()
        {
            foreach (var item in Items)
            {
                item.CustomPosition = item.transform.localPosition;
                item.CustomRotation = item.transform.localRotation;
                item.CustomScale = item.transform.localScale;
            }
        }

        /// <summary>Store in an  Array all the childrens </summary>
        public void UpdateItemsList()
        {
            if (transform.childCount != Items.Count) //If is there a new Item Update it
            {
                foreach (Transform child in transform)
                {
                    if (!child.TryGetComponent<MItem>(out _))
                    {
                        AddItemScript(child);
                    }
                }


                Items = this.GetComponentsInChildren<MItem>().ToList();

                if (transform.childCount != 0)
                    angle = 360f / transform.childCount;                            //Get The Angle for Radial Selectors


                for (int i = 0; i < Items.Count; i++)
                {
                    ItemsLocation(Items[i], i);                                       //Position the items
                }
            }
        }




        [ContextMenu("Set Initial Items Position")]
        /// <summary> Store the Initial Location of every Item on the  </summary>
        public virtual void StoreInitialLocation()
        {
            if (Items.Count > 0)
            {
                foreach (var item in Items)
                {
                    item.StartPosition = item.transform.localPosition;
                    item.StartRotation = item.transform.localRotation;
                    item.StartScale = item.transform.localScale;
                }
            }
        }

        /// <summary> Positions all items depending of the selector type </summary>
        public void ItemsLocation()
        {
            for (int i = 0; i < Items.Count; i++)
            {
                ItemsLocation(Items[i], i);  //Position the items
            }
        }

        /// <summary> Positions all items depending of the selector type </summary>
        public void ItemsLocation(MItem item, int ID)
        {
            Vector3 posItem = Vector3.zero;

            if (item == null) return;

            switch (SelectorType)
            {
                case SelectorType.Radial:
                    {
                        switch (RadialAxis)
                        {
                            case RadialAxis.Up:
                                posItem = new Vector3(Mathf.Cos(Angle * ID * Mathf.PI / 180) * distance, 0, Mathf.Sin(Angle * ID * Mathf.PI / 180) * distance);
                                break;
                            case RadialAxis.Right:
                                posItem = new Vector3(0, Mathf.Cos(Angle * ID * Mathf.PI / 180) * distance, Mathf.Sin(Angle * ID * Mathf.PI / 180) * distance);
                                break;
                            case RadialAxis.Forward:
                                posItem = new Vector3(Mathf.Cos(Angle * ID * Mathf.PI / 180) * distance, Mathf.Sin(Angle * ID * Mathf.PI / 180) * distance, 0);
                                break;
                            default:
                                break;
                        }
                    }
                    break;
                case SelectorType.Linear:
                    posItem = LinearVector * (distance * ID / 2);
                    break;
                case SelectorType.Grid:
                   
                    posItem = new Vector3(ID % Grid * GridWidth, ID / Grid * GridHeight);
                    break;
                case SelectorType.Custom:

                    //if (m_item)
                    //{
                        item.transform.SetLocalPositionAndRotation(item.CustomPosition, item.CustomRotation);
                        item.transform.localScale = item.CustomScale;

                        goto SetStartTransform;   //THIS IS NEW WAY TO SKIP CODE!
                    //}
                   // break;
                default:
                    break;
            }

        
            item.transform.SetLocalPositionAndRotation(posItem, Quaternion.identity);

            if (LookRotation)
            {
                Vector3 LookRotationAxis = Vector3.up;
                if (RadialAxis == RadialAxis.Right) LookRotationAxis = Vector3.right;
                if (RadialAxis == RadialAxis.Forward) LookRotationAxis = Vector3.forward;

                item.transform.LookAt(transform, LookRotationAxis);
            }

            item.transform.localRotation *= Quaternion.Euler(RotationOffSet);

            SetStartTransform: //SKIP CODE RIGHT HERE

           // if (m_item)
            //{
                item.StartPosition = item.transform.localPosition;
                item.StartRotation = item.transform.localRotation;
                item.StartScale = item.transform.localScale;
            //}

            MTools.SetDirty(item.transform);
            MTools.SetDirty(item);
        }


        ///// <summary> / Add ItemsManager to all Childs and colliders </summary>
        //public virtual void AddItemScript()
        //{
        //    foreach (Transform child in transform)
        //    {
        //        AddItemScript(child);
        //    }
        //}

        /// <summary> Add ItemsManager to all Childs and colliders </summary>
        public virtual void AddItemScript(Transform child)
        {
            child.gameObject.AddComponent<MItem>();

            child.gameObject.SetLayer(LayerMask.NameToLayer(SelectorLayer.Value), true);           //Set the Layer to UI.

            Renderer renderer = child.GetComponentInChildren<Renderer>(); //Find the Renderer for this Item

            if (!child.GetComponent<Collider>())  //Check First if there's no collider
            {
                if (!renderer) return;

                if (renderer is MeshRenderer || renderer is SkinnedMeshRenderer)            //if the Item is a 3D Model
                {
                    if (!renderer.GetComponent<Collider>())
                    {
                        renderer.gameObject.AddComponent<BoxCollider>();
                    }
                }

                if (renderer is SpriteRenderer)
                {
                    if (!renderer.GetComponent<Collider2D>())
                    {
                        renderer.gameObject.AddComponent<BoxCollider2D>();
                    }
                }
            }
        }
    }
}