Shader "Test/TestFeature"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
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
			// make fog work	//为处理不同的雾效类型（off/linear/exp/exp2）扩展了多个变体。
			#pragma multi_compile_fog	
			
			//与multi_compile唯一的区别在于shader_feature不会将不用的shader变体添加到程序中去。
			//shader_feature更适用于材质的关键字，而multi_compile更适用于代码设置的全局关键字。
			#pragma shader_feature __ KEY_F
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);

				//test
				col.rgb = col.rgb * _Color;

				#ifdef KEY_F
					col.rgb = col.rgb * 0;
				#else
					col.rgb = col.rgb * 1;
				#endif

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
