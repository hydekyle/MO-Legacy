using System.Collections.Generic;
using MoreMountains.Tools;
using RPGSystem;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class InventoryUI : MonoBehaviour
{
    Inventory Inventory { get => RPGManager.GameState.inventory; set => RPGManager.GameState.inventory = value; }
    List<Item> cachedItemList;

    public Canvas inventoryUI;
    public TMP_Text itemName, itemCount;
    public Transform itemsDisplayerRotator;
    public Transform itemsDisplayerFollowers;
    public float rotationVelocity = 10f;

    public float radius = 100f;
    public int index;

    void Awake()
    {
        CloseUI();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1)) OpenUI();
        if (Input.GetKeyDown(KeyCode.F2)) CloseUI();
        if (Input.GetKeyDown(KeyCode.F3)) NextIndex();
        if (Input.GetKeyDown(KeyCode.F4)) PreviousIndex();
        RotateInventory();
    }

    void RotateInventory()
    {
        var targetRot = 180 / Inventory.Count * index;
        itemsDisplayerRotator.rotation = Quaternion.Lerp(itemsDisplayerRotator.rotation, Quaternion.Euler(Vector3.forward * targetRot), Time.deltaTime * rotationVelocity);
    }

    void NextIndex()
    {
        if (index == Inventory.Count - 1) index = 0;
        else index++;
        HighlightCurrentIndex();
    }

    void PreviousIndex()
    {
        if (index == 0) index = Inventory.Count - 1;
        else index--;
        HighlightCurrentIndex();
    }

    void HighlightCurrentIndex()
    {
        itemName.text = cachedItemList[index].name;
        itemCount.text = Inventory[cachedItemList[index]].ToString();
    }

    void OpenUI()
    {
        inventoryUI.enabled = true;
        cachedItemList = Inventory.GetItemList();
        SetItemImages();
        SetItemPositions();
        HighlightCurrentIndex();
    }

    /// <summary>
    /// Create a image item slot when needed or update images
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
            angle += 180 / itemCount;
            Vector3 pos = itemsDisplayerRotator.position;
            pos.x += radius * Mathf.Cos(angle * Mathf.Deg2Rad);
            pos.y += radius * Mathf.Sin(angle * Mathf.Deg2Rad);
            // TODO : Cambiar a 2D amigo
            pos = transform.rotation * pos;
            itemsDisplayerRotator.GetChild(x).position = pos;
        }
    }

    void CloseUI()
    {
        inventoryUI.enabled = false;
    }
}
