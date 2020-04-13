Shader "Custom/BasicSurfaceShadingShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _ColorTint("Color tint color", Color) = (1,1,1,1)
        _Specular("Specular color", Color) = (1,1,1,1)
        _Emission("Emission", Color) = (1,1,1,1)
        _Smoothness("Smoothness", Range(0,1)) = 0.5
        _Occlusion("Occlusion", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        CGPROGRAM
        
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface customSurfaceShaderName StandardSpecular fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _ColorTint;
        fixed4 _Specular;
        fixed4 _Emission;
        half _Smoothness;
        half _Occlusion;

        struct Input // Name must be "Input"
        {
            float2 uv_MainTex;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void customSurfaceShaderName(Input surfaceInput, inout SurfaceOutputStandardSpecular output)
        {
            fixed4 color = tex2D (_MainTex, surfaceInput.uv_MainTex) * _ColorTint;
            output.Albedo = color.rgb;
            output.Specular = _Specular;
            // output.Normal =;
            output.Emission = _Emission;
            output.Smoothness = _Smoothness;
            output.Occlusion = _Occlusion;
            output.Alpha = color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
