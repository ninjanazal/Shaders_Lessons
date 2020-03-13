Shader "Aulas/FightingShader"
{
	Properties
	{
		// base Color
		_Color("Color", Color) = (1,1,1,1)
		// Main Texture
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		// Normal Map 
		_NormalTex("Normal", 2D) = "white" {}
		// Multiplication
		_BoolActivation("Multiplication", Range(0,5)) = 1
		// checkBox
		[Toggle] _FlipColors("Chance Colors", Float) = 0
	}
	SubShader
	{
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;		// textura base
		fixed4 _Color;			// cor base
		sampler2D _NormalTex;	// Normal tex
		half _BoolActivation;	// altera jogador
		float _FlipColors;		// toggle para alteraçao de cores

		struct Input
		{
			// uvs para a textura principal
			float2 uv_MainTex;
			// uvs para a textura de normais
			float2 uv_NormalTex;
		};


		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			// guarda a emissao de acordo com as uvs multiplicando pela emissao
			fixed4 emiss = tex2D(_NormalTex, IN.uv_NormalTex) * _BoolActivation;

			// defeniçao da cor
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex * 20) * _Color * 3;
			// caso o toggle esteja desactivado
			if (!_FlipColors) {
				// atribui apenas o valor de x á emissao
				o.Emission = emiss.x;
			}
			else if(_FlipColors){
				// caso tenha a atribuiçao activada no toogle
				// atribui o valor total da emissao
				o.Emission = emiss;	
			}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
