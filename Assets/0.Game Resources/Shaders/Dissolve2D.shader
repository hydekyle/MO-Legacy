Shader "Custom/Dissolve2D"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _DissolveThreshold ("Dissolve Threshold", Range(0, 1)) = 0.5
        _EdgeWidth ("Edge Width", Range(0, 0.5)) = 0.1
        _EdgeColor ("Edge Color", Color) = (1, 0, 0, 1)
        _EdgeIntensity ("Edge Intensity", Range(0, 5)) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
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
            sampler2D _NoiseTex;
            float _DissolveThreshold;
            float _EdgeWidth;
            float4 _EdgeColor;
            float _EdgeIntensity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Muestrear la textura principal y el mapa de ruido
                fixed4 texColor = tex2D(_MainTex, i.uv);
                float noiseValue = tex2D(_NoiseTex, i.uv).r;

                // Aplicar el efecto de disolución
                if (noiseValue < _DissolveThreshold)
                {
                    discard; // Descartar píxeles por debajo del umbral
                }

                // Calcular el borde de la disolución
                float edge = smoothstep(_DissolveThreshold, _DissolveThreshold + _EdgeWidth, noiseValue);

                // Mezclar el color del borde con la textura original
                fixed4 edgeColor = _EdgeColor * _EdgeIntensity * edge;
                fixed4 finalColor = texColor + edgeColor;

                return finalColor;
            }
            ENDCG
        }
    }
}