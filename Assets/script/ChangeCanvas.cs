using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeCanvas : MonoBehaviour
{
    public GameObject CanvasOn;//定义打开画布
    public GameObject CanvasOff;//定义关闭画布

    public void changeCanvas()//定义切换画布的方法
    {
        CanvasOn.SetActive(true);//实现打开画布
        CanvasOff.SetActive(false);//实现关闭画布
    }
}