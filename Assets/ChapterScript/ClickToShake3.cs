using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class ClickToShake3 : MonoBehaviour
{
    // Start is called before the first frame update
    public Camera mainCamera;
    public float shakeDuration = 1.5f;
    public float shakeStrength = 0.6f;
    private void OnMouseDown()

    {

        /*shake carema*/

        mainCamera.transform.DOShakePosition(shakeDuration, shakeStrength);
        /*delay  1.5s*/
        DOVirtual.DelayedCall(shakeDuration, () =>
        {
            UnityEngine.SceneManagement.SceneManager.LoadScene("SampleScene3");
        });

    }
}
