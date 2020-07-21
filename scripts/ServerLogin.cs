using System.Collections;
using System.Collections.Generic;
using UnityEditor.PackageManager;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class ServerLogin : MonoBehaviour
{
    public InputField Input_user;
    public InputField Input_pass;
    public Button button_login;
    public Button button_guest;
    public Text status;
	
    // Start is called before the first frame update
    void Start()
    {
        //Everything we need to login to SQL Database
        button_login.onClick.AddListener(() => {
            StartCoroutine(WebPHPConnect.Login(Input_user.text, Input_pass.text, status));
        });
       // If someone does not have an account, or they can't log in
        button_guest.onClick.AddListener(() => {
            SceneManager.LoadScene(1);
        });
    }
}
