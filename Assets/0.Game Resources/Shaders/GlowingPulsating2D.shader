Shader "Custom/GlowingPulsating2D"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _GlowColor ("Glow Color", Color) = (1, 1, 1, 1)
        _GlowIntensity ("Glow Intensity", Range(0, 5)) = 1
        _PulseSpeed ("Pulse Speed", Range(0, 5)) = 1
        _PulseAmplitude ("Pulse Amplitude", Range(0, 1)) = 0.5
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
            float4 _GlowColor;
            float _GlowIntensity;
            float _PulseSpeed;
            float _PulseAmplitude;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Sample the texture
                fixed4 texColor = tex2D(_MainTex, i.uv);

                // Calculate the pulse effect
                float pulse = sin(_Time.y * _PulseSpeed) * _PulseAmplitude + 1.0;

                // Apply glow color and intensity
                fixed4 glow = _GlowColor * _GlowIntensity * pulse;

                // Combine texture color with glow
                fixed4 finalColor = texColor + glow;
                finalColor.a = texColor.a; // Preserve original alpha

                return finalColor;
            }
            ENDCG
        }
    }
}