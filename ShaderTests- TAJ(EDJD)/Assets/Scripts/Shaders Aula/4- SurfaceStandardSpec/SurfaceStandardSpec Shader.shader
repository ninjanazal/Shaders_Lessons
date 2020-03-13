﻿// nome do ficheiro
Shader "Aulas/FirstShaderStandardSpec"
{
	// primeiro shader(em aula)
	Properties
	{
		// inputs
		// nome no inspector, tipo de var, valor inicial
		_myColor("Base Color", Color) = (1,1,1,1)
		_emissionColor("Cor Emissao", Color) = (1,1,1,1)
		_smoothVal("Smoothness", Range(0,1)) = 0.5
	}
		SubShader
	{
		CGPROGRAM
		// defenição de informaçoes relacionadas com o comportamento s
		#pragma surface surf StandardSpecular

		// definiçao de variaveis declaradas nas propriedades de entrada
		fixed4 _myColor;
		fixed4 _emissionColor;
		// vector definido na entrada do shader
		fixed3 _baseNormal;

		// valor de smo0th
		float _smoothVal;

		// Estrutura de input
		struct Input {
			// logica de input
			float2 uvMainTex;
			// screen positions
			float4 screenPos;
			// time
			float4 _Time;

			};

		// surface shader, com input nas entradas do parametro e output de surfaceOut
		void surf(Input IN, inout SurfaceOutputStandardSpecular  o) {
			// aplica cor determinada e aplica ao albedo do obj
				o.Albedo = _myColor;

				// smoothValue
				o.Smoothness = _smoothVal;

				// aplica a emissao passada ao obj
				o.Emission = _emissionColor * 0.5f;
		}
	ENDCG
	}
		FallBack "Diffuse"
}