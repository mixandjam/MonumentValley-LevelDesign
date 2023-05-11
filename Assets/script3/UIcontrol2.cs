using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIcontrol2 : MonoBehaviour
{
    private GameObject button;
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
        if (ca.transform.position.y > 38)
        {
            timer += Time.deltaTime;
            if (flag == false && timer > 1)
            {
                show();
                flag = true;
            }
        }
    }
    public void show()
    {

        button.SetActive(true);
        text.SetActive(true);
    }
}
