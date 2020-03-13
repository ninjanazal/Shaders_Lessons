// nome do ficheiro
Shader "Aulas/FirstShaderStandard"
{
	// primeiro shader(em aula)
	Properties
	{
		// inputs
		// nome no inspector, tipo de var, valor inicial
		_myColor("Base Color", Color) = (1,1,1,1)
		_emissionColor("Cor Emissao", Color) = (1,1,1,1)
		_metallicVal("Metallic", Range(0,1)) = 0.5
		_smoothVal("Smoothness", Range(0,1)) = 1

		_simpleColor("Red multiplyer" , Range(0.1,2)) = 1
	}
		SubShader
	{
		CGPROGRAM
		// defenição de informaçoes relacionadas com o comportamento s
		#pragma surface surf Standard

		// definiçao de variaveis declaradas nas propriedades de entrada
		fixed4 _myColor;		// propriedade de cor
		fixed4 _emissionColor;	// propriedade de emissao
		half _metallicVal;		// propriedade matalica
		half _smoothVal;		// propriedade smooth
		fixed _simpleColor;		// propriedade de valor de campo de cor

		// Estrutura de input
		struct Input {
			// logica de input
			float2 uvMainTex;
			float4 screenPos;	// screen positions			
			float4 _Time;		// time

			};

		// surface shader, com input nas entradas do parametro e output de surfaceOut
		void surf(Input IN, inout SurfaceOutputStandard  o) {
			
			// aplica cor determinada e aplica ao albedo do obj
			o.Albedo = _myColor.rgb;
			o.Albedo.r *= _simpleColor;
			// valor metalico
			//o.Metallic = _metallicVal;
			// aplica a emissao passada ao obj
			o.Emission = _emissionColor * 0.5f;
			// specular val
			o.Smoothness = _smoothVal;

			// using allpha to change the mat 
			o.Metallic = _myColor.a;
	}
ENDCG
	}
		FallBack "Diffuse"
}