using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LevelLoader : MonoBehaviour
{
    // Start is called before the first frame update
    public Animator transition;
    public float transitionTime = 1f;

    // Update is called once per frame
    void Update()
    {
        if(Input.GetMouseButtonDown(0))
        {
            LoadNextLevel();
        }
    }
    public void LoadNextLevel()
    {
       StartCoroutine( LoadLevel(SceneManager.GetActiveScene().buildIndex + 1));
      
    }    
/*”Œœ∑≥°æ∞*/
IEnumerator LoadLevel(int levelIndex)
        {
            //Play animation
            transition.SetTrigger("Start");

            //wait
            yield return new WaitForSeconds(transitionTime);

            //Load scene
            SceneManager.LoadScene(levelIndex);
        }

    }

