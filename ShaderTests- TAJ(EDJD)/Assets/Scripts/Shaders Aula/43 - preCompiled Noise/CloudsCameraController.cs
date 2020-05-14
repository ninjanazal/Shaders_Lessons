using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CloudsCameraController : MonoBehaviour
{
    // 
    public Shader CloudShader;
    public float MinHeight = 0.0f;
    public float MaxHeight = 5.0f;
    public float FadeDist = 2;
    public float Scale = 5;
    public float Steps = 50;

    public Texture ValueNoiseImage;
    public Transform Sun;

    Camera _Cam;
    Material _material;

    // Custom mat getter
    public Material Material
    {
        get
        {
            if (_material == null && CloudShader == null) { _material = new Material(CloudShader); }
            if (_material != null && CloudShader == null) { DestroyImmediate(_material); }
            if (_material != null && CloudShader != null && CloudShader != _material.shader) { DestroyImmediate(_material); }
            return _material;
        }
    }

    void Start()
    {
        if (_material) DestroyImmediate(_material);
    }

    // get frustum corners
    Matrix4x4 GetFrustumCorners()
    {
        Matrix4x4 frustumCorners = Matrix4x4.identity;
        Vector3[] fCornors = new Vector3[4];

        _Cam.CalculateFrustumCorners(new Rect(0, 0, 1, 1), _Cam.farClipPlane, Camera.MonoOrStereoscopicEye.Mono, fCornors);

        frustumCorners.SetRow(0, fCornors[1]);
        frustumCorners.SetRow(1, fCornors[2]);
        frustumCorners.SetRow(2, fCornors[3]);
        frustumCorners.SetRow(3, fCornors[4]);

        return frustumCorners;
    }

    [ImageEffectOpaque]
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if(Material == null || ValueNoiseImage == null)
        {
            Graphics.Blit(source, destination);
            return;
        }

        if (_Cam == null) _Cam = GetComponent<Camera>();

        Material.SetTexture("_ValueNoise", ValueNoiseImage);
        

    }


    static void CustomGraphicsBlit(RenderTexture source,
        RenderTexture dest, Material fxMaterial, int passNr)
    {
        //set the destination of the texture about to be 
        //renderered, in this case the screen
        RenderTexture.active = dest;

        //get the current texture from the source
        //in this case the screen capture before processing 
        fxMaterial.SetTexture("_MainTex", source);

        //save current graphics transformation matrices
        //these are used to influence position, rotation and 
        //scaling
        //we are about to effect these matrices and want to 
        //remember the current state
        GL.PushMatrix();

        //switch to orthographic camera projection
        //this will basically get rid of any depth information
        //from perspective
        GL.LoadOrtho();

        //set the pass number of the image processing
        //a pass is basically a single draw call or single 
        //processing of an image
        //you can run a pass over an image multiple times
        //think of it like you would run a blur filter over
        //a photo once - that's 1 pass.  then you run blur
        //again that would be pass number 2
        fxMaterial.SetPass(passNr);

        //create a quad
        GL.Begin(GL.QUADS);

        //set the UVs of vertex 1
        GL.MultiTexCoord2(0, 0.0f, 0.0f);
        //set the vertex position of vertex 1
        GL.Vertex3(0.0f, 0.0f, 3.0f); // Back Left

        //set the UVs of vertex 2
        GL.MultiTexCoord2(0, 1.0f, 0.0f);
        //set the vertex position of vertex 2
        GL.Vertex3(1.0f, 0.0f, 2.0f); // Back Right

        //etc for all vertices of the quad
        GL.MultiTexCoord2(0, 1.0f, 1.0f);
        GL.Vertex3(1.0f, 1.0f, 1.0f); // Top Right

        GL.MultiTexCoord2(0, 0.0f, 1.0f);
        GL.Vertex3(0.0f, 1.0f, 0.0f); // Top Left

        //end the specifications of the quad
        GL.End();

        //lets remember the transformational matrix states 
        //from when we did the PushMatrix
        //so that this little bit of graphics doesn't impact
        //any other drawings
        GL.PopMatrix();
    }

    protected virtual void OnDisable()
    {
        if (_material)
            DestroyImmediate(_material);
    }
}
