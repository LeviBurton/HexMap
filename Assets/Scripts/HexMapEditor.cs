using UnityEngine;
using UnityEngine.EventSystems;

public class HexMapEditor : MonoBehaviour {

	public Color[] colors;
	public HexGrid hexGrid;

    Color activeColor;
    int activeElevation;
    bool renderWireframe;

    void Awake()
    {
        SelectColor(0);
    }

    void Update()
    {
        var mouseButton = Input.GetMouseButton(0);
        var isPointerOverGameObject = EventSystem.current.IsPointerOverGameObject();

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
            EditCell(hexGrid.GetCell(hit.point));
        }
    }

    void EditCell(HexCell cell)
    {
        cell.color = activeColor;
        cell.Elevation = activeElevation;

        hexGrid.Refresh();
    }

    public void SetElevation(float elevation)
    {
        activeElevation = (int)elevation;
    }

    public void SelectColor(int index)
    {
        activeColor = colors[index];
    }

    public void EnableWireframe(bool enabled)
    {
        hexGrid.EnableWireframe(enabled);
    }
}