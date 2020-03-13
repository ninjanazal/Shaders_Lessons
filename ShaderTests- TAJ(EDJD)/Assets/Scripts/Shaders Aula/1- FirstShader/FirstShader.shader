// nome do ficheiro
Shader "Aulas/FirstShader"
{
	// primeiro shader(em aula)
	Properties
	{
		// inputs
		// nome no inspector, tipo de var, valor inicial
		_myColor("Base Color", Color) = (1,1,1,1)
		_emissionColor("Cor Emissao", Color) = (1,1,1,1)

	}
		SubShader
	{
		CGPROGRAM
		// defenição de informaçoes relacionadas com o comportamento s
		#pragma surface surf Lambert

		// definiçao de variaveis declaradas nas propriedades de entrada
		fixed4 _myColor;
		fixed4 _emissionColor;
		// vector definido na entrada do shader
		fixed3 _baseNormal;


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
		void surf(Input IN, inout SurfaceOutput o) {
			// aplica cor determinada e aplica ao albedo do obj
				o.Albedo = _myColor;

				// aplica a emissao passada ao obj
				o.Emission = _emissionColor;
		}
	ENDCG
	}
		FallBack "Diffuse"
}
