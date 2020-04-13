Shader "Custom/PixelationPostProcessingShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f input) : SV_Target
            {
                float2 positionComponent = input.uv;
                float2 sizeOfScreen = float2(0.01f, 0.01f);
                float2 pixelation = float2(positionComponent.x % sizeOfScreen.x, positionComponent.y % sizeOfScreen.x);

                float2 pixelationeffect = float2(1.0f, 1.0f);

                pixelation *= pixelationeffect;

                positionComponent -= pixelation; 
                float4 base = tex2D(_MainTex, positionComponent);
                
                return base;
                // return float4(1, 0.5, 0, 1);
            }

            ENDCG
        }
    }
}