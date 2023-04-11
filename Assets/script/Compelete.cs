using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Compelete : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    float speed = 3;
    float distance;
    bool flag = false;
    // Update is called once per frame
    void Update()
    {
        GameObject camera = GameObject.Find("Main Camera");
        if (flag == true)
        {
            distance = speed * Time.deltaTime;
            if(camera.transform.position.y > 36)
            {
                camera.transform.Translate(0, distance/2, 0);
            }
            else
            {
                camera.transform.Translate(0, distance, 0);
            }
        }
        if (camera.transform.position.y > 38)
        {
            flag = false;
        }
    }
    public void OnTriggerEnter(Collider other)
    {
        GameObject camera = GameObject.Find("Main Camera");
        if (camera != null)
        {
            flag = true;
        }
    }
    private void OnTriggerStay(Collider other)
    {
        
    }
}
