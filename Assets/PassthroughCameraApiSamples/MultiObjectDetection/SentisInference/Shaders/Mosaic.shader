Shader "Custom/Mosaic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MosaicScale ("Mosaic Scale", Float) = 50.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
            float _MosaicScale;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Calculate block size based on scale
                float2 blockPos = floor(i.uv * _MosaicScale);
                float2 blockCenter = blockPos / _MosaicScale + (0.5 / _MosaicScale);
                
                // Sample texture at the center of the block
                fixed4 col = tex2D(_MainTex, blockCenter);
                return col;
            }
            ENDCG
        }
    }
}
