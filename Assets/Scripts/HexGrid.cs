using UnityEngine;
using UnityEngine.UI;

public class HexGrid : MonoBehaviour
{
    public int width = 6;
    public int height = 6;
    public Color defaultColor = Color.white;
    public HexCell cellPrefab;
    public TMPro.TextMeshProUGUI cellLabelPrefab;
    public Texture2D noiseSource;

    HexCell[] cells;
    Canvas gridCanvas;
    HexMesh hexMesh;

    Material[] meshMaterials;
    Material wireframeMaterial;

    void OnEnable()
    {
        HexMetrics.noiseSource = noiseSource;
    }

    void Awake()
    {
        HexMetrics.noiseSource = noiseSource;
        gridCanvas = GetComponentInChildren<Canvas>();
        hexMesh = GetComponentInChildren<HexMesh>();
        wireframeMaterial = Resources.Load<Material>("Wireframe");
        meshMaterials = hexMesh.GetComponent<MeshRenderer>().materials;

        cells = new HexCell[height * width];

        for (int z = 0, i = 0; z < height; z++)
        {
            for (int x = 0; x < width; x++)
            {
                CreateCell(x, z, i++);
            }
        }
    }

    void Start()
    {
        hexMesh.Triangulate(cells);
    }

    public void Refresh()
    {
        hexMesh.Triangulate(cells);
    }

    public HexCell GetCell(Vector3 position)
    {
        position = transform.InverseTransformPoint(position);
        HexCoordinates coordinates = HexCoordinates.FromPosition(position);
        int index = coordinates.X + coordinates.Z * width + coordinates.Z / 2;

        return cells[index];
    }

    void CreateCell(int x, int z, int i)
    {
        Vector3 position;
        position.x = (x + z * 0.5f - z / 2) * (HexMetrics.innerRadius * 2f);
        position.y = 0f;
        position.z = z * (HexMetrics.outerRadius * 1.5f);

        HexCell cell = cells[i] = Instantiate<HexCell>(cellPrefab);
        cell.transform.SetParent(transform, false);
        cell.transform.localPosition = position;
        cell.coordinates = HexCoordinates.FromOffsetCoordinates(x, z);
        cell.color = defaultColor;

        if (x > 0)
        {
            cell.SetNeighbor(HexDirection.W, cells[i - 1]);
        }

        if (z > 0)
        {
            if ((z & 1) == 0)
            {
                cell.SetNeighbor(HexDirection.SE, cells[i - width]);
                if (x > 0)
                {
                    cell.SetNeighbor(HexDirection.SW, cells[i - width - 1]);
                }
            }
            else
            {
                cell.SetNeighbor(HexDirection.SW, cells[i - width]);
                if (x < width - 1)
                {
                    cell.SetNeighbor(HexDirection.SE, cells[i - width + 1]);
                }
            }
        }

        var label = Instantiate<TMPro.TextMeshProUGUI>(cellLabelPrefab);
        label.rectTransform.SetParent(gridCanvas.transform, false);
        label.rectTransform.anchoredPosition = new Vector2(position.x, position.z);
        label.text = cell.coordinates.ToStringOnSeparateLines();
        cell.uiRect = label.rectTransform;
        cell.Elevation = 0;
    }

    public void EnableWireframe(bool enabled)
    {
        var renderer = hexMesh.GetComponent<MeshRenderer>();
        Material[] newMaterials = new Material[meshMaterials.Length + (enabled ? 1 : 0)];

        for (int i = 0; i < meshMaterials.Length; i++)
        {
            newMaterials[i] = meshMaterials[i];
        }

        if (enabled)
        {
            newMaterials[meshMaterials.Length] = wireframeMaterial;
        }
      
        hexMesh.GetComponent<MeshRenderer>().materials = newMaterials;
    }
}