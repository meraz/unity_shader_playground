Shader "Custom/MaterialPixelationEffectImageEffectBase"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
		Tags
		{ 
			"Queue"="Transparent"
        }

        GrabPass
        {
            "_BackgroundTexture"
        }

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
                float4 vertex : SV_POSITION;
                float4 screenVertex : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            // Properties
            sampler2D _MainTex;
            sampler2D _Noise;
            sampler2D _StrengthFilter;
            sampler2D _BackgroundTexture;
            float     _Strength;
            float     _Speed;
            v2f vert (appdata i)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(i.vertex);
                o.screenVertex = ComputeGrabScreenPos(o.vertex);
                o.uv = i.uv;
                return o;
            }

            // https://www.wolframalpha.com/input/?i=cos%5E2%28pi%2F2*x%29
            float cos2TimeInterpolation(float value)
            {
                const float Pi = 3.141592653589793238462f;
                const float HalfPi =  1.57079632679f;
                float cosValue = cos(HalfPi*value);
                return cosValue * cosValue;
            }

            // https://www.wolframalpha.com/input/?i=-x%5E2%2Bx
            float computeWeight05Highest(float value)
            {
                value = clamp(value, 0.0f, 1.0f);
                return -(value*value) + value;
            }
           
            fixed4 frag (v2f i) : SV_Target
            {
                //float border = 0.1;

                //if(i.uv.x > (1-border) || i.uv.x < border || i.uv.y > (1-border) || i.uv.y < border)
                {
                  //  return 1 - tex2Dproj(_BackgroundTexture, i.screenVertex);
                }
                //else
                {
                    // Compute pixelated uv positions
                    float2 pixelatedUv = i.uv;
                    float2 sizeOfScreen = float2(0.1f, 0.1f);
                    float2 pixelation = float2(pixelatedUv.x % sizeOfScreen.x, pixelatedUv.y % sizeOfScreen.x);
                    float2 pixelationeffect = float2(1.0f, 1.0f);
                    pixelation *= pixelationeffect;
                    pixelatedUv -= pixelation; 
                    
                    float xWeight = computeWeight05Highest(pixelatedUv.x);
                    float yWeight = computeWeight05Highest(pixelatedUv.y);
                    float weight = lerp(xWeight, yWeight, 0.5f);
                    return weight + tex2Dproj(_BackgroundTexture, i.screenVertex);
                }
            }
            ENDCG
        }
    }
}
