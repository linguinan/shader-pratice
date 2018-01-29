Shader "Custom/SurfaceRim" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("Bumpmap (RGB)", 2D) = "bump" {}
		_RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
		_RimPower ("Rim Power", Range(0.5, 8.0)) = 3.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		//边缘光照，通过表面光线和视角方向添加发射光照

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 viewDir;
		};

		sampler2D _MainTex;
		sampler2D _BumpMap;
		float4 _RimColor;
		float _RimPower;

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;//像素的颜色
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));//像素的法向值
			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);//像素的发散颜色
			//_RimColor	指定发光色 * 强度

			//saturate	把输入值限定在[0,1]之间
			//dot		返回两个向量的点积
			//viewDir 	内置变量
			//pow 		返回输入值的指定次幂
		}
		ENDCG
	}
	FallBack "Diffuse"
}
