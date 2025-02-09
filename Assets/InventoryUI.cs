using System.Collections.Generic;
using System.Threading.Tasks;
using Cysharp.Threading.Tasks;
using MoreMountains.Feedbacks;
using MoreMountains.Tools;
using RPGSystem;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class InventoryUI : MonoBehaviour
{
    Inventory Inventory { get => RPGManager.GameState.inventory; set => RPGManager.GameState.inventory = value; }
    List<Item> cachedItemList;

    public CanvasGroup inventoryCanvasGroup;
    public TMP_Text itemName, itemCount;
    public Transform itemsDisplayerRotator;
    public Transform itemsDisplayerFollowers;
    public float rotationVelocity = 10f;

    [Range(0, 360)]
    public int maxAngle = 360;
    public float radius = 100f;
    public int index;

    bool IsInventoryOpen => inventoryCanvasGroup.alpha > 0.3f;
    bool isInteractable = true;

    public MMFeedbacks _MMFOnOpenUI, _MMFOnCloseUI;
    public float inputDelay = 0.5f;
    float lastTimeInput = -1f;

    void Start()
    {
        CloseUI();
    }

    void Update()
    {
        if (!isInteractable) return;
        if (IsInventoryOpen)
        {
            if (Input.GetKeyDown(KeyCode.F2)) CloseUI();
            RotateInventory();
            if (Time.time < lastTimeInput + inputDelay) return;
            if (Input.GetAxis("Horizontal") > 0) NextIndex();
            if (Input.GetAxis("Horizontal") < 0) PreviousIndex();
        }
        else if (Input.GetKeyDown(KeyCode.F)) OpenUI();
    }

    void RotateInventory()
    {
        var targetRot = maxAngle / Inventory.Count * index;
        itemsDisplayerRotator.rotation = Quaternion.Lerp(itemsDisplayerRotator.rotation, Quaternion.Euler(Vector3.forward * targetRot), Time.deltaTime * rotationVelocity);
    }

    void NextIndex()
    {
        if (index == Inventory.Count - 1) index = 0;
        else index++;
        HighlightCurrentIndex();
        lastTimeInput = Time.time;
    }

    void PreviousIndex()
    {
        if (index == 0) index = Inventory.Count - 1;
        else index--;
        HighlightCurrentIndex();
        lastTimeInput = Time.time;
    }

    void HighlightCurrentIndex()
    {
        itemName.text = cachedItemList[index].name;
        itemCount.text = Inventory[cachedItemList[index]].ToString();
    }

    void OpenUI()
    {
        _MMFOnOpenUI.PlayFeedbacks();
        cachedItemList = Inventory.GetItemList();
        SetItemImages();
        SetItemPositions();
        HighlightCurrentIndex();
        isInteractable = true;
        RPGManager.Instance.SetPlayerFreeze(FreezeType.FreezeAll);
    }

    void CloseUI()
    {
        _MMFOnCloseUI.PlayFeedbacks();
        isInteractable = false;
        OnCloseUI().Forget();
        RPGManager.Instance.SetPlayerFreeze(FreezeType.None);
    }

    async UniTaskVoid OnCloseUI()
    {
        await UniTask.WaitUntil(() => !_MMFOnCloseUI.IsPlaying);
        isInteractable = true;
    }

    /// <summary>
    /// Create a image item slot when needed or update images.
    /// Call on opening the UI
    /// </summary>
    private void SetItemImages()
    {
        for (var x = 0; x < Inventory.Count; x++)
        {
            // Add slot gameobjects if there are more items than slots
            if (itemsDisplayerRotator.childCount - 1 < x)
            {
                AddNewSlotForItem();
            }
            itemsDisplayerFollowers.GetChild(x).GetComponent<Image>().sprite = cachedItemList[x].sprite;
        }
    }

    /// <summary>
    /// Creates a gameobject inside the rotator and another gameobject with Image that follows the item inside the rotator
    /// </summary>
    private void AddNewSlotForItem()
    {
        // Add a item inside the rotator
        var newRotatorItem = Instantiate(itemsDisplayerRotator.GetChild(0));
        newRotatorItem.transform.SetParent(itemsDisplayerRotator);

        // Set the sprite and follow the new rotator item
        var newDisplayerFollower = Instantiate(itemsDisplayerFollowers.GetChild(0));
        newDisplayerFollower.transform.SetParent(itemsDisplayerFollowers);
        newDisplayerFollower.GetComponent<MMFollowTarget>().Target = newRotatorItem;
    }

    /// <summary>
    /// Set the position of each item in the inventory to the position of the rotator
    /// </summary>
    void SetItemPositions()
    {
        float angle = 0f;
        int itemCount = Inventory.Count;
        for (var x = 0; x < itemCount; x++)
        {
            angle += maxAngle / itemCount;
            Vector3 pos = itemsDisplayerRotator.position;
            pos.x += radius * Mathf.Cos(angle * Mathf.Deg2Rad);
            pos.y += radius * Mathf.Sin(angle * Mathf.Deg2Rad);
            pos = transform.rotation * pos;
            itemsDisplayerRotator.GetChild(x).position = pos;
        }
    }

}
