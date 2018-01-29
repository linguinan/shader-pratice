using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TestRenderImage : MonoBehaviour {

	public Shader curShader;
	public float grayScaleAmount = 1.0f;
	private Material curMaterial;

	public Material material
	{
		get{
			if(curMaterial == null)
			{
				curMaterial = new Material(curShader);
				curMaterial.hideFlags = HideFlags.HideAndDontSave;
			}
			return curMaterial;
		}
	}


	// Use this for initialization
	void Start () {
		//检测平台支持性
		if(SystemInfo.supportsImageEffects == false){
			enabled = false;
			return;
		}

		if(curShader != null && curShader.isSupported == false){
			enabled = false;
		}
		
	}
	
	// Update is called once per frame
	void Update () {
		grayScaleAmount = Mathf.Clamp(grayScaleAmount, 0.0f, 1.0f);
	}

	//摄像机上的任何脚本都可以收到这个回调
	void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture){
		if(curShader != null)
		{
			material.SetFloat("_LuminosityAmount", grayScaleAmount);
			Graphics.Blit(sourceTexture, destTexture, material);//sourceTexture会成为material的_MainTex
		}else{
			Graphics.Blit(sourceTexture, destTexture);
		}
	}

	void OnDisable(){
		if(curMaterial != null)
		{
			DestroyImmediate(curMaterial);
		}
	}

}
