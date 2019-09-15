using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class SaveLoadItem : MonoBehaviour
{
    public SaveLoadMenu menu;

    string mapName;

    public string MapName
    {
        get
        {
            return mapName;
        }
        set
        {
            mapName = value;
            transform.GetChild(0).GetComponent<TMPro.TextMeshProUGUI>().text = value;
        }
    }


    public void Select()
    {
        menu.SelectItem(mapName);
    }
}
