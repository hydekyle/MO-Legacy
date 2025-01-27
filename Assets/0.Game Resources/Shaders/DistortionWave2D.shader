Shader "Custom/DistortionWave2D"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DistortionTex ("Distortion Texture", 2D) = "bump" {}
        _DistortionStrength ("Distortion Strength", Range(0, 0.1)) = 0.05
        _WaveSpeed ("Wave Speed", Range(0, 5)) = 1
        _WaveAmplitude ("Wave Amplitude", Range(0, 0.5)) = 0.1
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
            sampler2D _DistortionTex;
            float _DistortionStrength;
            float _WaveSpeed;
            float _WaveAmplitude;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Calcular la distorsión basada en el tiempo y la textura de distorsión
                float2 distortion = tex2D(_DistortionTex, i.uv + _Time.y * _WaveSpeed).xy * 2 - 1;
                distortion *= _DistortionStrength;

                // Aplicar la distorsión a las coordenadas UV
                float2 uvDistorted = i.uv + distortion;

                // Muestrear la textura principal con las coordenadas distorsionadas
                fixed4 texColor = tex2D(_MainTex, uvDistorted);

                // Añadir un efecto de onda adicional
                float wave = sin(i.uv.y * 10 + _Time.y * _WaveSpeed) * _WaveAmplitude;
                uvDistorted.x += wave;
                texColor = tex2D(_MainTex, uvDistorted);

                return texColor;
            }
            ENDCG
        }
    }
}