using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;
using UnityEngine.SceneManagement;
using static Unity.IO.LowLevel.Unsafe.AsyncReadManagerMetrics;

public class btnclick : MonoBehaviour
{
    private Animator anim;
    // Start is called before the first frame update
    void Start()
    {
    }
    float timer = 0;
    bool flag = false;
    // Update is called once per frame
    void Update()
    {
        timer += Time.deltaTime;
        if (flag == true && timer > 1)
        {
            SceneManager.LoadScene("GameScene");
            flag = false;
        }
    }
    public void nextGame()
    {
        flag = true;
    }
}
