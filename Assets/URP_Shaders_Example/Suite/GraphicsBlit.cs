using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GraphicsBlit : MonoBehaviour
{
    public Material distanceToCameraMaterial;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        distanceToCameraMaterial.SetVector("_CamPos", transform.position);

        Graphics.Blit(source, destination, distanceToCameraMaterial);
    }
}
