using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using UnityEngine;

public class Entity : MonoBehaviour
{
    public Sprite[] spriteList;
    public float movementSpeed;
    public float animationFrameTime = 0.1f;
    [HideInInspector]
    public FaceDirection faceDirection;
    SpriteRenderer spriteRenderer;
    float _lastTimeAnimationChanged = -1;
    int _indexStepAnim = 0;
    List<int> stepAnimOrder = new List<int>() { 0, 1, 2, 1 };
    public BoxCollider2D boxCollider2D;
    // 0 (down) walking
    // 1 (down) idle
    // 2 (down) walking
    // 3 (left) walking
    // 6 (right) walking
    // 9 (up) walking

    void Awake()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
        boxCollider2D = GetComponent<BoxCollider2D>();
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

    public void CastInteraction()
    {
        var castPoint = GetCastPoint();
        var hits = Physics2D.CircleCastAll(castPoint, 0.3f, Vector2.one, 1f, LayerMask.GetMask("Default"));
        var _resolvedHits = new List<int>(); // Avoid reinteract when multiple collider
        foreach (var hit in hits)
        {
            var hitID = hit.transform.GetHashCode();
            if (_resolvedHits.Contains(hitID)) return;
            if (hit && hit.transform.TryGetComponent<RPGEvent>(out RPGEvent interactedEvent))
            {
                var page = interactedEvent.GetActivePage();
                if (page.trigger == TriggerType.PlayerInteraction)
                    page.ResolveActionList(this.GetCancellationTokenOnDestroy()).Forget();
            }
            _resolvedHits.Add(hitID);
        }
        //LookAtDirection(GetFaceDirectionByMoveDirection(castPoint - transform.position));
    }

    public void CastUsableItem(ScriptableItem item)
    {
        var hit = Physics2D.CircleCast(GetCastPoint(), 1f, Vector2.one, 1f, LayerMask.GetMask("Usable Item Zone"));
        if (hit.transform.TryGetComponent<RPGUsableItemZone>(out RPGUsableItemZone usableItemZone))
        {
            usableItemZone.UsedItem(item);
        }
    }

    public void Move(Vector3 moveDirection)
    {
        transform.position = Vector3.Lerp(transform.position, transform.position + new Vector3(moveDirection.x, moveDirection.y, 0), Time.deltaTime * movementSpeed);
        AnimationWalk(moveDirection);
        spriteRenderer.sortingOrder = Helpers.GetSpriteOrderByPositionY(transform.position);
    }

    public void AnimationWalk(Vector3 moveDirection)
    {
        switch (faceDirection)
        {
            case FaceDirection.South:
                spriteRenderer.sprite = spriteList[0 + stepAnimOrder[_indexStepAnim]];
                break;
            case FaceDirection.West:
                spriteRenderer.sprite = spriteList[3 + stepAnimOrder[_indexStepAnim]];
                break;
            case FaceDirection.East:
                spriteRenderer.sprite = spriteList[6 + stepAnimOrder[_indexStepAnim]];
                break;
            case FaceDirection.North:
                spriteRenderer.sprite = spriteList[9 + stepAnimOrder[_indexStepAnim]];
                break;
        }
        // Animation Steps
        if (Time.time > _lastTimeAnimationChanged + animationFrameTime)
        {
            _indexStepAnim = _indexStepAnim < stepAnimOrder.Count - 1 ? _indexStepAnim + 1 : 0;
            _lastTimeAnimationChanged = Time.time;
            faceDirection = Entity.GetFaceDirectionByMoveDirection(moveDirection);
        }
    }

    public async UniTaskVoid StopMovement()
    {
        await UniTask.WaitUntil(() => _lastTimeAnimationChanged + animationFrameTime < Time.time, PlayerLoopTiming.LastUpdate, this.GetCancellationTokenOnDestroy());
        try { LookAtDirection(faceDirection); } catch { }
    }

    public void LookAtDirection(FaceDirection fDir)
    {
        switch (fDir)
        {
            case FaceDirection.South:
                spriteRenderer.sprite = spriteList[1];
                break;
            case FaceDirection.West:
                spriteRenderer.sprite = spriteList[4];
                break;
            case FaceDirection.East:
                spriteRenderer.sprite = spriteList[7];
                break;
            case FaceDirection.North:
                spriteRenderer.sprite = spriteList[10];
                break;
        }
        faceDirection = fDir;
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

}
