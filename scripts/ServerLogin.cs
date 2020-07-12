using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ServerLogin : MonoBehaviour
{
    public InputField Input_user;
    public InputField Input_pass;
    public Button button_login;
    // Start is called before the first frame update
    void Start()
    {
        button_login.onClick.AddListener(() => {
            StartCoroutine(WebPHPConnect.Login(Input_user.text, Input_pass.text));
        });
    }
}
