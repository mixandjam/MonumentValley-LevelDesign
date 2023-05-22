using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using DG.Tweening;
using UnityEngine.UI;

public class Load01Script : MonoBehaviour
{
    public TMP_Text text;
    public GameObject button;
    public GameObject button2;/*闪烁*/


    void Start()
    {
        text.color = new Color(1f, 1f, 1f, 0f); // 设置文字初始透明度为0
        button.SetActive(false); // 隐藏按钮
        button2.SetActive(false);

        StartCoroutine(FadeIn()); // 淡入文字   
        // 每隔1秒执行一次
        InvokeRepeating("ToggleVisibility", 0f, 1f);

    }

    IEnumerator FadeIn()
    {
        yield return new WaitForSeconds(1f); // 等待1秒
        text.DOFade(1f, 1f); // 淡入文字
        yield return new WaitForSeconds(1f); // 等待1秒
        button.SetActive(true); // 显示按钮
        button2.SetActive(true);
    }
    private void ToggleVisibility()
    {
        // 如果物体是可见的，则隐藏它
        if (button2.activeSelf)
        {
            button2.SetActive(false);
        }
        // 如果物体是隐藏的，则显示它
        else
        {
            button2.SetActive(true);
        }
    }


    public void FadeOut()
    {
        button.SetActive(false); // 隐藏按钮
        button2.SetActive(false);
        CancelInvoke("ToggleVisibility");/*停止调用*/
        text.DOFade(0f, 1f).OnComplete(() => { // 淡出文字，并在动画结束时执行回调函数
            // 在回调函数中恢复场景背景颜色
            Camera.main.backgroundColor = new Color(0.35f, 0.35f, 0.35f, 1f);
        });
        // 在淡出文字的同时，暗淡场景背景颜色
        Camera.main.DOColor(new Color(0f, 0f, 0f, 1f), 1f);


    }
}
