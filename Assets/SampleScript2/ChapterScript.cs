using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
public class ChapterScript : MonoBehaviour
{
    [Tooltip("旋转门")]
    public Transform TowerObject;
    [Tooltip("缓动距离")]
    public float floatingDistance = 0.1f;
    [Tooltip("缓动时间")]
    public float floatingTime = 1f;
    // Start is called before the first frame update
    void Start()
    {

        //将物体向上浮动并在指定时间内完成
        TowerObject.DOMoveY(TowerObject.position.y + floatingDistance, floatingTime).SetEase(Ease.InOutSine)
            .SetLoops(-1, LoopType.Yoyo);

        //将物体向下浮动并在指定时间内完成
        TowerObject.DOMoveY(TowerObject.position.y - floatingDistance, floatingTime).SetEase(Ease.InOutSine)
            .SetLoops(-1, LoopType.Yoyo);

        //将物体向左浮动并在指定时间内完成
        TowerObject.DOMoveX(TowerObject.position.x - floatingDistance, floatingTime).SetEase(Ease.InOutSine)
            .SetLoops(-1, LoopType.Yoyo);

        //将物体向右浮动并在指定时间内完成
        TowerObject.DOMoveX(TowerObject.position.x + floatingDistance, floatingTime).SetEase(Ease.InOutSine)
            .SetLoops(-1, LoopType.Yoyo);
    }

    // Update is called once per frame
    void Update()
    {
        //实现旋转门上下左右缓动效果




        if (Input.GetKeyDown(KeyCode.A) || Input.GetKeyDown(KeyCode.D))
        {
            int multiplier = Input.GetKey(KeyCode.A) ? 1 : -1;
            TowerObject.DOComplete();
            TowerObject.DORotate(new Vector3(0, 90 * multiplier, 0), .6f, RotateMode.WorldAxisAdd).SetEase(Ease.OutBack);
        }

    }
}
