using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

[ExecuteInEditMode]
public class ComputeShading : MonoBehaviour
{
    public ComputeShader shader;
    public Material material;
    RenderTexture tex;

    void Start()
    {
        RunShader();
    }

    void RunShader()
    {
        tex = new RenderTexture(256, 256, 1);
        tex.enableRandomWrite = true;
        tex.Create();

        int kernelHandle = shader.FindKernel("ComputeShaderTest1");
        shader.SetTexture(kernelHandle, "Result", tex);
        shader.Dispatch(kernelHandle, 256 / 8, 256 / 8, 1);

        //Camera.main.SetTargetBuffers(tex.colorBuffer, tex.depthBuffer);

        // Use computed texture in material
        material.SetTexture("_MainTex", tex);
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        //    destination.
        //   RenderTexture a = new RenderTexture();
        //  Assert.IsTrue();
        // Graphics.Blit(source, destination, material);
    }
}
