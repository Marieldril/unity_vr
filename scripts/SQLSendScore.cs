using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class SQLSendScore : MonoBehaviour
{
    public Button button_send;
    
    
    void Start()
    {
        // Convert index of scene to string
        int IntScene = SceneManager.GetActiveScene().buildIndex;
        string StrScene = IntScene.ToString();

        // A correct website page.
        StartCoroutine(WebPHPConnect.GetRequest("http://localhost/unity_vr_sql/sendScore.php"));

        // Send UserID, Question number and Points to SQL Function
        button_send.onClick.AddListener(() => {
            StartCoroutine(WebPHPConnect.Send(WebPHPConnect.CurrentID, StrScene, "1"));
        });
    }
}
