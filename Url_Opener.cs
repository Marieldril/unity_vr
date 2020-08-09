using UnityEngine;

public class Url_Opener : MonoBehaviour
{
   public string Url;

   public void Open()
    {
           Application.OpenURL(Url);
    }
}
