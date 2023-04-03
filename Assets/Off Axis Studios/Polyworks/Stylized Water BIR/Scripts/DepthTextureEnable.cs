using UnityEngine;

[RequireComponent(typeof(Camera))]
[ExecuteInEditMode]
public class DepthTextureEnable : MonoBehaviour
{
    private Camera mainCam;

    void OnEnable()
    {
        if (mainCam == null)
        {
            try
            {
                mainCam = GetComponent<Camera>();
            }
            catch
            {
                mainCam = Camera.main;
            }
        }

        if (mainCam.depthTextureMode == DepthTextureMode.None)
        {
            mainCam.depthTextureMode = DepthTextureMode.Depth;
        }
    }
}
