using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InsideArea : MonoBehaviour
{
    Color targetColor;
    SpriteRenderer spriteRenderer;

    void Start()
    {
        spriteRenderer = spriteRenderer ?? GetComponent<SpriteRenderer>();
        targetColor = ColorClose();
    }

    void Update()
    {
        spriteRenderer.color = Color.Lerp(spriteRenderer.color, targetColor, Time.deltaTime * 3);
    }

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
            targetColor = ColorOpen();
        if (other.TryGetComponent<Entity>(out var entity))
            entity.SetSortingLayer("Inside");
    }

    void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
            targetColor = ColorClose();
        if (other.TryGetComponent<Entity>(out var entity))
            entity.SetSortingLayer("Outside");
    }

    Color ColorOpen()
    {
        return new Color(spriteRenderer.color.r, spriteRenderer.color.g, spriteRenderer.color.b, 0);
    }

    Color ColorClose()
    {
        return new Color(spriteRenderer.color.r, spriteRenderer.color.g, spriteRenderer.color.b, 1);
    }
}
