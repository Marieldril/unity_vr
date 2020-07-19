using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UIElements;

public class launch : MonoBehaviour
{
    public GameObject launchPanel;
    public GameObject logo;
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(LoadLogin());
    }

    IEnumerator LoadLogin()
    {
        //After 5 seconds hide logo and panel
        yield return new WaitForSeconds(5);
        launchPanel.SetActive(false);
        logo.SetActive(false);
    }
}
