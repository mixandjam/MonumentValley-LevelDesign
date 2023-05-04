using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.SceneManagement;

public class GameManager2 : MonoBehaviour
{

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

        /*路径变换*/
        foreach (PathCondition pc in pathConditions)
        {
            int count = 0;
            for (int i = 0; i < pc.conditions.Count; i++)
            {
                if (pc.conditions[i].conditionObject.eulerAngles == pc.conditions[i].eulerAngle)
                {
                    count++;
                }
            }
            foreach (SinglePath sp in pc.paths)
                sp.block.possiblePaths[sp.index].active = (count == pc.conditions.Count);
        }




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


        /*按钮平台的上升*/



    }

    /*序列化？*/

    [System.Serializable]
    public class PathCondition
    {
        public string pathConditionName;
        public List<Condition> conditions;
        public List<SinglePath> paths;
    }
    [System.Serializable]
    public class Condition
    {
        public Transform conditionObject;
        public Vector3 eulerAngle;

    }
    [System.Serializable]
    public class SinglePath
    {
        public Walkable block;
        public int index;
    }

}

