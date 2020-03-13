Shader "Personal/Test"
{
	// Input fields
	Properties
	{
		// cor de albedo
		_myColor("Cor", Color) = (1,1,1,1)
		_myEmission("Emission", Color) = (1,1,1,1)
	}
		SubShader
	{
		CGPROGRAM
		#pragma surface surf Lambert

		// estrutura de input
		struct Input {
			float2 uvMainTex;
		};

	// defeniçao de vars a usar na logica do shader
	fixed4 _myColor;
	fixed4 _myEmission;

	// surface shader
	void surf(Input IN, inout SurfaceOutput o) {
		// define a cor do albedo
		o.Albedo = _myColor.rgb;

		// define a cor de emissao
		o.Emission = _myEmission;
	}

	ENDCG
	}
		FallBack "Diffuse"
}
