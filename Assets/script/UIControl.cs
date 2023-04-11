using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIControl : MonoBehaviour
{
    private GameObject button;
    private GameObject image1;
    private GameObject text;
    bool flag = false;
    float timer = 0;
    // Start is called before the first frame update
    void Start()
    {
        button = GameObject.FindGameObjectWithTag("finishButton");
        text = GameObject.FindGameObjectWithTag("text0");
        text.SetActive(false);
        button.SetActive(false);
    }
    // Update is called once per frame
    void Update()
    {
        GameObject ca = GameObject.Find("Main Camera");
        GameObject cube = GameObject.FindGameObjectWithTag("Floor");
        if (ca.transform.position.y >38)
        {
            timer += Time.deltaTime;
            if (flag == false && timer>5)
            {
                show();
                flag = true;
            }
        }else if(ca.transform.position.y > 35)
        {
            cube.GetComponent<Animation>().Play("floorchange");
        }
    }
    public void show()
    {

        button.SetActive(true);
        text.SetActive(true);
    }
}
