using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TestMultiCompile : MonoBehaviour {

	public Material material;

	public MeshRenderer meshRenderer;

	/// <summary>
	/// Awake is called when the script instance is being loaded.
	/// </summary>
	void Awake()
	{
		if(material == null && meshRenderer != null)
		{
			material = meshRenderer.material;
		}
	}

	/// <summary>
	/// Start is called on the frame when a script is enabled just before
	/// any of the Update methods is called the first time.
	/// </summary>
	void Start()
	{
		// Shader.DisableKeyword("KEY_B");
		// Shader.DisableKeyword("KEY_C");

		// 经过实验，Keyword默认值是没指定的，记录的是最后的状态
	}
	
	public void Click_A_On(){
		material.EnableKeyword("KEY_A");
	}

	public void Click_A_Off(){
		material.DisableKeyword("KEY_A");
	}

	public void Global_A_On(){
		Shader.EnableKeyword("KEY_A");
	}

	public void Global_A_Off(){
		Shader.DisableKeyword("KEY_A");
	}

	public void ToggleB(Toggle toggle)
	{
		Debug.Log("ToggleB : " + toggle.isOn);
		if(toggle.isOn)
		{
			Shader.EnableKeyword("KEY_B");
		}else{
			Shader.DisableKeyword("KEY_B");
		}
	}

	public void ToggleC(Toggle toggle)
	{
		Debug.Log("ToggleC : " + toggle.isOn);
		if(toggle.isOn)
		{
			Shader.EnableKeyword("KEY_C");
		}else{
			Shader.DisableKeyword("KEY_C");
		}
	}

	public void ToggleF(Toggle toggle)
	{
		Debug.Log("ToggleF : " + toggle.isOn);
		if(toggle.isOn)
		{
			Shader.EnableKeyword("KEY_F");
		}else{
			Shader.DisableKeyword("KEY_F");
		}
	}

}
