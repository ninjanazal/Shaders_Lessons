// nome do ficheiro
Shader "Aulas/TextureShader"
{
	// Texture using
	Properties
	{
		// inputs
		_baseTexture("Textura", 2D) = "white" {}
		_mult("Multi", Range(0,5)) = 0.5
	}
		SubShader
		{
			CGPROGRAM
			// defenição de informaçoes relacionadas com o comportamento s
			#pragma surface surf Standard fullforwardshadows
			#pragma target 3.0

			// declaraçao
			// textura de entrada
			sampler2D _baseTexture;
			half _mult;

		// Estrutura de input
		struct Input {
			// uv para a textura de entrada
			float2 uv_baseTexture;
			};

		// surface shader, com input nas entradas do parametro e output de surfaceOut
		void surf(Input IN, inout SurfaceOutputStandard  o) {
			// texture to albedo, using uv
			o.Albedo = (tex2D(_baseTexture, IN.uv_baseTexture.x * ( _SinTime))) * _mult;
		}
		ENDCG
		}
			FallBack "Diffuse"
}