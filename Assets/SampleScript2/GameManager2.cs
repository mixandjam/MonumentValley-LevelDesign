using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.SceneManagement;

public class GameManager2 : MonoBehaviour
{
    [SerializeField] private Transform cubeTransform;//方块的Transform组件
    private Vector3 startLocation = new Vector3(21.906f, 18.93f, 3.837f); // 初始位置

    private Vector3 endLocation = new Vector3(21.906f, 35.24f, 3.837f); // 结束位置

    private float moveDistance = 16.31f;
    private float moveDuration = 3f;

    public static GameManager2 instance;

    /*玩家*/
    public PlayerController player;

    /*可能移动的路径*/
    public List<PathCondition> pathConditions = new List<PathCondition>();
    /*场景变换*/
    public List<Transform> pivots;
    /*隐藏的方块*/

    private void Awake()
    {
        instance = this;
    }



    // Update is called once per frame
    void Update()
    {

      
        if (player.walking)
            return;

        /* rotateCube的旋转*/
        if (Input.GetKeyDown(KeyCode.RightArrow) || Input.GetKeyDown(KeyCode.LeftArrow))
        {
            int multiplier = Input.GetKey(KeyCode.RightArrow) ? 1 : -1;
            pivots[0].DOComplete();
            pivots[0].DORotate(new Vector3(0, 90 * multiplier, 0), .6f, RotateMode.WorldAxisAdd).SetEase(Ease.OutBack);
        }


        /*平面的隐藏*/


     

    }
    public  void RotatePivot()
    {
        /*平台上升*/
   
/*使用DOTWeen API设置动画*/

        cubeTransform.DOMoveY(cubeTransform.position.y+moveDistance,moveDuration).SetEase(Ease.Linear);


    
}

}

/*序列化？*/



