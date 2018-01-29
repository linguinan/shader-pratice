Shader "Custom/Custom3" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Bump ("Bump", 2D) = "bump" {}
		_Snow ("Snow Level", Range(0, 1)) = 0
		_SnowColor ("Snow Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SnowDirection ("Snow Direction", Vector) = (0, 1, 0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CustomDiffuse

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Bump;

		//表面贴图追加积雪效果
		float _Snow;
		float4 _SnowColor;
		float4 _SnowDirection;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Bump;
			float3 worldNormal; INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));

			if(dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) > lerp(1, -1, _Snow)) {
				o.Albedo = _SnowColor.rgb;
			}else{
				o.Albedo = c.rgb;
			}

			o.Alpha = c.a;
		}

		//自定义光照
		inline float4 LightingCustomDiffuse (SurfaceOutput s, fixed3 lightDir, fixed atten) {
			float difLight = max(0, dot(s.Normal, lightDir));
			float hLambert = difLight;// * 0.5 + 0.5;//增亮
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * (hLambert * atten * 2);
			col.a = s.Alpha;
			return col;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
