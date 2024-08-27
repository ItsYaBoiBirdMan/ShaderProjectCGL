using System;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class RageModePostProcess : MonoBehaviour
{
    public Shader rageModeShader;
    private Material rageModeMaterial;

    [Header("Shader Properties")]
    public Color highlightColor = Color.red;
    [Range(0, 1)] public float tolerance = 0.2f;
    [Range(0, 5)] public float glowIntensity = 2.0f;
    public Texture2D staticTexture;
    [Range(0, 1)] public float staticIntensity = 0.5f;
    [Range(0, 2)] public float staticSpeed = 1.0f;
    [Range(0, 5)] public float randomScale = 1.0f;
    [Range(0, 5)] public float pulseSpeed = 1.0f;
    [Range(0, 0.1f)] public float pulseIntensity = 0.01f;
    [Range(0, 0.5f)] public float edgePulseIntensity = 0.1f;

    private bool _effectOn;

    private void OnEnable()
    {
        if (rageModeShader == null)
        {
            Debug.LogError("RageMode shader not assigned.");
            enabled = false;
            return;
        }

        if (!rageModeMaterial)
        {
            rageModeMaterial = new Material(rageModeShader);
            rageModeMaterial.hideFlags = HideFlags.HideAndDontSave;
        }
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.E)) _effectOn = !_effectOn;
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (rageModeMaterial != null && _effectOn)
        {
            rageModeMaterial.SetTexture("_MainTex", src);
            rageModeMaterial.SetTexture("_StaticTex", staticTexture);
            rageModeMaterial.SetColor("_HighlightColor", highlightColor);
            rageModeMaterial.SetFloat("_Tolerance", tolerance);
            rageModeMaterial.SetFloat("_GlowIntensity", glowIntensity);
            rageModeMaterial.SetFloat("_StaticIntensity", staticIntensity);
            rageModeMaterial.SetFloat("_StaticSpeed", staticSpeed);
            rageModeMaterial.SetFloat("_RandomScale", randomScale);
            rageModeMaterial.SetFloat("_PulseSpeed", pulseSpeed);
            rageModeMaterial.SetFloat("_PulseIntensity", pulseIntensity);
            rageModeMaterial.SetFloat("_EdgePulseIntensity", edgePulseIntensity);
            rageModeMaterial.SetFloat("_StaticTime", Time.time); // Update time for pulse and static effects

            Graphics.Blit(src, dest, rageModeMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
