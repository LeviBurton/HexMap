using UnityEngine;
using UnityEngine.EventSystems;

public class HexMapEditor : MonoBehaviour {

	public Color[] colors;

	public HexGrid hexGrid;

	private Color activeColor;

	void Awake()
    {
        SelectColor(0);
    }

    void Update()
    {
        var mouseButton = Input.GetMouseButton(0);
        var isPointerOverGameObject = EventSystem.current.IsPointerOverGameObject();

        //Debug.Log(mouseButton.ToString() + ", " + isPointerOverGameObject);

        if (mouseButton && !isPointerOverGameObject)
        {
            HandleInput();
        }
    }

    void HandleInput()
    {
        Ray inputRay = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if (Physics.Raycast(inputRay, out hit))
        {
            Debug.Log("hit a hex");

            hexGrid.ColorCell(hit.point, activeColor);
        }
    }

    public void SelectColor(int index)
    {
        activeColor = colors[index];
    }
}