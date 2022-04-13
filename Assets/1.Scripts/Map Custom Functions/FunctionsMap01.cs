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
        GameManager.SetVariable("palanquita", GameManager.GetVariable("palanquita") + 1);
    }

    public void _Palanca1Off()
    {
        GameManager.SetSwitch("palanca1", false);
        GameManager.SetVariable("palanquita", GameManager.GetVariable("palanquita") + 1);
    }
}
