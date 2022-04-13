using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FunctionsMap01 : MonoBehaviour
{
    public void _Mensaje1()
    {
        print("Hola soy un mensaje para el primer mapa de pruebas");
    }

    public void _Palanca1On()
    {
        GameManager.SetSwitch("palanca1", true);
    }

    public void _Palanca1Off()
    {
        GameManager.SetSwitch("palanca1", false);
    }
}
