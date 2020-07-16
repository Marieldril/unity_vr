using JetBrains.Annotations;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class WebPHPConnect : MonoBehaviour
{
    public static string CurrentUser;

    // Start is called before the first frame update
    void Start()
    {
        // A correct website page.
        StartCoroutine(GetRequest("http://localhost/unity_vr_sql/data.php"));
        //StartCoroutine(Login());
    }

    public static IEnumerator GetRequest(string uri)
    {
        using (UnityWebRequest webRequest = UnityWebRequest.Get(uri))
        {
            // Request and wait for the desired page.
            yield return webRequest.SendWebRequest();

            string[] pages = uri.Split('/');
            int page = pages.Length - 1;

            if (webRequest.isNetworkError)
            {
                Debug.Log(pages[page] + ": Error: " + webRequest.error);
            }
            else
            {
                Debug.Log(pages[page] + ":\nReceived: " + webRequest.downloadHandler.text);
            }
        }
    }

    public static IEnumerator Login(string LoginString, string PasswordString, Text statusText)
    {
        WWWForm form = new WWWForm();
        form.AddField("loginUser", LoginString);
        form.AddField("loginPass", PasswordString);

        using (UnityWebRequest www = UnityWebRequest.Post("http://localhost/unity_vr_sql/data.php", form))
        {
            yield return www.SendWebRequest();
            if (www.isNetworkError || www.isHttpError)
            {
                Debug.Log(www.error);
            }
            else
            {
                Debug.Log(www.downloadHandler.text);
                statusText.text = www.downloadHandler.text;
            }

            if (www.downloadHandler.text == "Połączono z bazą. Zalogowano pomyślnie! ")
            {
                string Login_now = LoginString;
                CurrentUser = LoginString;
                SceneManager.LoadScene(2);
            }
        }
    }
}
