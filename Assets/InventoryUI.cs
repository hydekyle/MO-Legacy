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
    Inventory inventory;
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

    Item SelectedItem => cachedItemList[index];

    void Start()
    {
        inventory = RPGManager.GameState.inventory;
        CloseInventory();
    }

    void Update()
    {
        if (!isInteractable) return;
        if (IsInventoryOpen)
        {
            if (Input.GetKeyDown(KeyCode.F)) CloseInventory();
            if (inventory.Count > 0)
            {
                RotateInventory();
                if (Time.time < lastTimeInput + inputDelay) return;
                if (Input.GetKeyDown(KeyCode.Space)) UseSelectedItem();
                if (Input.GetAxis("Horizontal") > 0) NextIndex();
                if (Input.GetAxis("Horizontal") < 0) PreviousIndex();
            }
        }
        else if (Input.GetKeyDown(KeyCode.F)) OpenInventory();
    }

    void UseSelectedItem()
    {
        SelectedItem.Use();
        RemoveItem();
        CloseInventory();
    }

    void RemoveItem()
    {
        if (inventory[SelectedItem] <= 1) inventory.Remove(SelectedItem);
        else inventory[SelectedItem] = inventory[SelectedItem] - 1;
    }

    void RotateInventory()
    {
        var targetRot = maxAngle / inventory.Count * index;
        itemsDisplayerRotator.rotation = Quaternion.Lerp(itemsDisplayerRotator.rotation, Quaternion.Euler(Vector3.forward * targetRot), Time.deltaTime * rotationVelocity);
    }

    void NextIndex()
    {
        if (index == inventory.Count - 1) index = 0;
        else index++;
        HighlightCurrentIndex();
        lastTimeInput = Time.time;
    }

    void PreviousIndex()
    {
        if (index == 0) index = inventory.Count - 1;
        else index--;
        HighlightCurrentIndex();
        lastTimeInput = Time.time;
    }

    void HighlightCurrentIndex()
    {
        itemName.text = SelectedItem.name;
        itemCount.text = inventory[SelectedItem].ToString();
    }

    void OpenInventory()
    {
        foreach (Transform t in itemsDisplayerFollowers) t.gameObject.SetActive(false);
        RPGManager.Instance.SetPlayerFreeze(FreezeType.FreezeAll);
        index = 0;
        _MMFOnOpenUI.PlayFeedbacks();
        cachedItemList = inventory.GetItemList();
        if (cachedItemList.Count > 0)
        {
            SetItemImages();
            SetItemPositions();
            HighlightCurrentIndex();
            isInteractable = true;
        }
        else
        {
            itemName.text = "No items";
            itemCount.text = "";
        }
    }

    void CloseInventory()
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
        for (var x = 0; x < inventory.Count; x++)
        {
            // Add slot gameobjects if there are more items than slots
            if (itemsDisplayerRotator.childCount - 1 < x)
            {
                AddNewSlotForItem();
            }
            var child = itemsDisplayerFollowers.GetChild(x);
            child.GetComponent<Image>().sprite = cachedItemList[x].sprite;
            child.gameObject.SetActive(true);
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
        int itemCount = inventory.Count;
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
