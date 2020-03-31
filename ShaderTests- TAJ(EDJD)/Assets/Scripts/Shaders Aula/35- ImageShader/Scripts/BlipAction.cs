using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class BlipAction : MonoBehaviour
{

    [SerializeField] private Material fromTOMat = null;
    [SerializeField] private Material InvetColorMat = null;

    [SerializeField, Range(0, 1)] private float range = 0;
    private void Start()
    {
        // activa o depth render
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture temp = RenderTexture.GetTemporary(source.width, source.height);

        if (fromTOMat != null)
        {
            fromTOMat.SetFloat("_Amount", range);
            Graphics.Blit(source, temp, fromTOMat);

            if (InvetColorMat != null)            
                Graphics.Blit(temp, destination, InvetColorMat);            
            else
                Graphics.Blit(temp, destination);
        }
        else
            Graphics.Blit(source, destination);

        RenderTexture.ReleaseTemporary(temp);
    }
}
