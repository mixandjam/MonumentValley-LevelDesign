using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Controlscript3 : MonoBehaviour
{
    public float moveDuration = 1f;
    public float moveDistanceY = 1.5f;
    public float moveDistanceZ = 0.5f;
    public string sceneName = "SampleScen3";
    public GameObject gameObject02;

    private bool isMoving = false;

    private void OnMouseDown()
    {
        if (!isMoving)
        {
            isMoving = true;
            transform.DOMoveZ(transform.position.z - moveDistanceZ, moveDuration)
                .SetEase(Ease.Linear)
                .OnComplete(() =>
                {
                    transform.DOMoveY(transform.position.y + moveDistanceY, moveDuration)
                        .SetEase(Ease.Linear)
                     /*  .OnComplete(() =>
                       {
                           UnityEngine.SceneManagement.SceneManager.LoadScene(sceneName);
                       });*/
                     .OnComplete(() =>
                     {
                         // ÒÆ¶¯gameObject02
                         gameObject02.transform.DOMoveY(gameObject02.transform.position.y - 10f, 2.5f)
                             .OnComplete(() =>
                             {
                                 isMoving = false;
                             });
                     });
                });
        }
    }
}

