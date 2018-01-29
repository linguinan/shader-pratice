Shader "Custom/SurfaceDiffuseSimple" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Lambert

		fixed4 _Color;

		struct Input {
			float4 color : COLOR;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = _Color;//1;//像素的颜色0-1
		}
		ENDCG
	}
	FallBack "Diffuse"
}
