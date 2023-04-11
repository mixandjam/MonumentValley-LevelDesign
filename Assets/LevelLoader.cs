using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LevelLoader : MonoBehaviour
{

    public Animator transition;
    [Tooltip("¹ý¶ÉÊ±¼ä")]
    public float transitionTime = 2f;

    // Start is called before the first frame update
    

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKey(KeyCode.K))
        {
            LoadNextLevel();
        }
        
    }
    public   void   LoadNextLevel()
    {
       StartCoroutine( LoadLevel( SceneManager.GetActiveScene().buildIndex+1));
      

    }
    IEnumerator LoadLevel(int levleIndex)
    {
        //Play anmation
        transition.SetTrigger("Start");

        //Wait
        yield return new WaitForSeconds(transitionTime);

        //Load scene
        SceneManager.LoadScene(levleIndex);
        
    }
}
