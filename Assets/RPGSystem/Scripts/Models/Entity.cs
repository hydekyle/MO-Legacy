using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using RPGSystem;
using UnityEngine;

public class Entity : MonoBehaviour
{
    public Character character;
    public float movementSpeed = 5f;
    public float animationFrameTime = 0.1f;

    [Header("Entity Dependencies")]
    public BoxCollider2D boxCollider2D;
    public Rigidbody2D rb;
    public SpriteRenderer spriteRenderer;

    [HideInInspector] public FaceDirection faceDirection;
    float _lastTimeAnimationChanged = -1;
    int _indexStepAnim = 0;
    readonly List<int> stepAnimOrder = new() { 0, 1, 2, 1 };
    // 0 (down) walking
    // 1 (down) idle
    // 2 (down) walking
    // 3 (left) walking
    // 6 (right) walking
    // 9 (up) walking

    void OnValidate()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
        boxCollider2D = GetComponent<BoxCollider2D>();
        rb = GetComponent<Rigidbody2D>();
    }

    public void Run()
    {
        movementSpeed *= 2;
        animationFrameTime /= 2;
    }

    public void RunStop()
    {
        movementSpeed /= 2;
        animationFrameTime *= 2;
    }

    public void SetSortingLayer(string layerName)
    {
        spriteRenderer.sortingLayerName = layerName;
    }

    Vector3 GetCastPoint()
    {
        var castPoint = boxCollider2D.bounds.center;
        var castDistance = 0.5f;
        switch (faceDirection)
        {
            case FaceDirection.North: castPoint += Vector3.up * castDistance; break;
            case FaceDirection.East: castPoint += Vector3.right * castDistance; break;
            case FaceDirection.West: castPoint += Vector3.left * castDistance; break;
            case FaceDirection.South: castPoint += Vector3.down * castDistance; break;
        }
        return castPoint;
    }

    public void CastInteraction(int layerMask)
    {
        var castPoint = GetCastPoint();
        var hits = Physics2D.CircleCastAll(castPoint, 0.3f, Vector2.one, 1f, layerMask);
        var _resolvedHits = new List<int>(); // Avoid reinteract when multiple collider
        foreach (var hit in hits)
        {
            var hitID = hit.transform.GetHashCode();
            if (_resolvedHits.Contains(hitID)) return;
            if (hit)
            {
                // Trigger any RPGEvent from the selected layerMask
                if (hit.transform.TryGetComponent(out RPGEvent interactedEvent))
                {
                    var page = interactedEvent.ActivePage;
                    if (page.trigger == TriggerType.PlayerInteraction)
                    {
                        page.ResolveActionList(this.GetCancellationTokenOnDestroy()).Forget();
                        return;
                    }
                }

                // Trigger any Interactable from the selected layerMask
                if (hit.transform.TryGetComponent(out IInteractable _interactable))
                {
                    _interactable.InteractionFrom(this);
                    return;
                }
            }
            _resolvedHits.Add(hitID);
        }
        //LookAtDirection(GetFaceDirectionByMoveDirection(castPoint - transform.position));
    }

    public void CastUsableItem(Item item, int layerMask)
    {
        var hit = Physics2D.CircleCast(GetCastPoint(), 1f, Vector2.one, 1f, layerMask);
        if (hit.transform.TryGetComponent(out RPGUsableItemZone usableItemZone)) usableItemZone.UsedItem(item);
    }

    public void Move(Vector3 moveDirection)
    {
        rb.MovePosition(rb.position + new Vector2(moveDirection.x, moveDirection.y) * movementSpeed * Time.fixedDeltaTime);
        AnimationWalk(moveDirection);
        CheckSpriteOrderByPositionY();
    }

    public void CheckSpriteOrderByPositionY()
    {
        try
        {
            spriteRenderer.sortingOrder = GetSpriteOrderByPositionY(transform.position);
        }
        catch
        {
            GetComponent<SpriteRenderer>().sortingOrder = GetSpriteOrderByPositionY(transform.position);
        }
    }

    public void AnimationWalk(Vector3 moveDirection)
    {
        switch (faceDirection)
        {
            case FaceDirection.South:
                spriteRenderer.sprite = character.spriteList[0 + stepAnimOrder[_indexStepAnim]];
                break;
            case FaceDirection.West:
                spriteRenderer.sprite = character.spriteList[3 + stepAnimOrder[_indexStepAnim]];
                break;
            case FaceDirection.East:
                spriteRenderer.sprite = character.spriteList[6 + stepAnimOrder[_indexStepAnim]];
                break;
            case FaceDirection.North:
                spriteRenderer.sprite = character.spriteList[9 + stepAnimOrder[_indexStepAnim]];
                break;
        }
        // Animation Steps
        if (Time.time > _lastTimeAnimationChanged + animationFrameTime * (2 - Mathf.Clamp(moveDirection.magnitude, 0f, 1f)))
        {
            _indexStepAnim = _indexStepAnim < stepAnimOrder.Count - 1 ? _indexStepAnim + 1 : 0;
            _lastTimeAnimationChanged = Time.time;
            faceDirection = GetFaceDirectionByMoveDirection(moveDirection);
        }
    }

    public void LookAtDirection(FaceDirection fDir)
    {
        switch (fDir)
        {
            case FaceDirection.South:
                spriteRenderer.sprite = character.spriteList[1];
                break;
            case FaceDirection.West:
                spriteRenderer.sprite = character.spriteList[4];
                break;
            case FaceDirection.East:
                spriteRenderer.sprite = character.spriteList[7];
                break;
            case FaceDirection.North:
                spriteRenderer.sprite = character.spriteList[10];
                break;
        }
        faceDirection = fDir;
    }

    public async UniTaskVoid StopMovement()
    {
        await UniTask.WaitUntil(() => _lastTimeAnimationChanged + animationFrameTime < Time.time, PlayerLoopTiming.LastUpdate, this.GetCancellationTokenOnDestroy());
        try { LookAtDirection(faceDirection); } catch { }
    }

    public void LookAtWorldPosition(Vector3 worldPosition)
    {
        var vDif = worldPosition - transform.position;
        LookAtDirection(GetFaceDirectionByMoveDirection(vDif));
    }

    public static FaceDirection GetFaceDirectionByMoveDirection(Vector3 dir)
    {
        // Face priority by higher axis
        if (Mathf.Abs(dir.x) > Mathf.Abs(dir.y))
        {
            if (dir.x < 0) return FaceDirection.West;
            else if (dir.x > 0) return FaceDirection.East;
            else if (dir.y < 0) return FaceDirection.South;
            else return FaceDirection.North;
        }
        else
        {
            if (dir.y < 0) return FaceDirection.South;
            else if (dir.y > 0) return FaceDirection.North;
            else if (dir.x < 0) return FaceDirection.West;
            else return FaceDirection.East;
        }
    }

    public static int GetSpriteOrderByPositionY(Vector3 position)
    {
        return (int)(-position.y * 10); // We remove the first decimal point
    }

}
