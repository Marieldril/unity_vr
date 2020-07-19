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
    public static string CurrentID;

    // Start is called before the first frame update
    void Start()
    {
        // A correct website page.
        StartCoroutine(GetRequest("http://localhost/unity_vr_sql/data.php"));
        //StartCoroutine(Login());
    }

    // Connect to SQL, check if everything is OK
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

    // Login with data from ServerLogin.cs
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
            }

            if (www.downloadHandler.text != "Niepoprawny Login lub Hasło. " && www.downloadHandler.text != "Użytkownik nie istnieje. ")
            {
                CurrentID = www.downloadHandler.text;
                CurrentUser = LoginString;
                SceneManager.LoadScene(1);
            } else
                statusText.text = "Niepoprawny e-mail lub hasło.";
        }
    }

    // Send User score from SQLSendScore.cs
    public static IEnumerator Send(string UserID, string Question, string Points)
    {
        WWWForm form = new WWWForm();
        form.AddField("UserID", UserID);
        form.AddField("Question", Question);
        form.AddField("Points", Points);

        using (UnityWebRequest www = UnityWebRequest.Post("http://localhost/unity_vr_sql/sendScore.php", form))
        {
            yield return www.SendWebRequest();
            if (www.isNetworkError || www.isHttpError)
            {
                Debug.Log(www.error);
            }
            else
            {
                Debug.Log(www.downloadHandler.text);
            }
        }
    }
}
