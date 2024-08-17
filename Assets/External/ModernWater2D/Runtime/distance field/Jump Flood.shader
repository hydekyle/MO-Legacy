Shader "Hidden/Jump Flood"
{
	Properties
	{
		_MainTex("Texture", 2D) = "black" {}
	}
		SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;

			float2 stepSize;
			float2 screenSize;

			float4 frag(v2f i) : SV_Target
			{
			
				float minDist = 1000;
				float2 minDistSeed = float2(0, 0);
				float2 screenRatio = float2(screenSize.x / screenSize.y, 1);


				
				for (int y = -1; y <= 1; ++y)
				{
					for (int x = -1; x <= 1; ++x)
					{
						float2 pos = i.uv - (float2(x, y) * stepSize.xy / screenSize.xy);
						float2 seed = tex2D(_MainTex, pos).xy;
						float dist = length((seed - i.uv) * screenRatio);
						if (seed.x != 0. && seed.y != 0. && dist < minDist)
						{
							minDist = dist;
							minDistSeed = seed;
						}
					}
				}

				float2 ba = tex2D(_MainTex, i.uv).ba;

				return float4(minDistSeed, minDist,1);
			}
			ENDCG
		}

	}
}
