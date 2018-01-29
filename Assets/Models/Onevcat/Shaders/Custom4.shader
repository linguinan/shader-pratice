// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Custom4" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Bump ("Bump", 2D) = "bump" {}
		_Snow ("Snow Level", Range(0, 1)) = 0
		_SnowColor ("Snow Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SnowDirection ("Snow Direction", Vector) = (0, 1, 0)
		//积雪厚度
		_SnowDepth ("Snow Depth", Range(0, 10)) = 0.1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		//更改顶点模型，增加积雪厚度
		#pragma surface surf CustomDiffuse vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Bump;

		//表面贴图追加积雪效果
		float _Snow;
		float4 _SnowColor;
		float4 _SnowDirection;
		float _SnowDepth;

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

		//修改顶点
		void vert (inout appdata_full v) {
			//transpose方法输出原矩阵的转置矩阵
			//_Object2World是Unity ShaderLab的内建值，它表示将当前模型转换到世界坐标中的矩阵
			//与积雪方向做矩阵乘积得到积雪方向在物体的世界空间中的投影
			float4 sn = mul(transpose(unity_ObjectToWorld), _SnowDirection);
			//计算这个世界坐标中实际的积雪方向和当前点的法线值的点积
			if(dot(v.normal, sn.xyz) >= lerp(1, -1, (_Snow * 2) / 3)) {
				v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;//改变该点的模型顶点高度
			}
		}

		ENDCG
	}
	FallBack "Diffuse"
}
