using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Walkable : MonoBehaviour
{

   /*创建一个WalkPath类的新列表*/
/*用于手动设置路径的可读性*/
    public List<WalkPath> possiblePaths = new List<WalkPath>();

    [Space]

    public Transform previousBlock;

    [Space]

    [Header("Booleans")]
    public bool isStair = false;
    public bool movingGround = false;
    public bool isButton;
    public bool dontRotate;

    [Space]

    [Header("Offsets")]
    public float walkPointOffset = .5f;
    public float stairOffset = .4f;

    public Vector3 GetWalkPoint()
    {
/*通过跟踪偏移变量来确定行走点*/
        float stair = isStair ? stairOffset : 0;
        return transform.position + transform.up * walkPointOffset - transform.up * stair;
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.gray;
        float stair = isStair ? .4f : 0;
        Gizmos.DrawSphere(GetWalkPoint(), .1f);

        if (possiblePaths == null)
            return;

        foreach (WalkPath p in possiblePaths)
        {
            if (p.target == null)
                return;
            Gizmos.color = p.active ? Color.black : Color.clear;
            Gizmos.DrawLine(GetWalkPoint(), p.target.GetComponent<Walkable>().GetWalkPoint());
        }
    }
}

[System.Serializable]

/*用于确定玩家从每个对象可能行走的方向*/
public class WalkPath
{
    public Transform target;
/*布尔值检查路径是否被激活*/
    public bool active = true;
}
