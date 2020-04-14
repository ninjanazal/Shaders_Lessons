﻿Shader "Unlit/MatrixRotation3DShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RotationAmount("Rotation Amount", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            half _RotationAmount;

            float3 RoatateMatrix3D(float3 vert, half angle)
            {
                half c = cos(angle);
                half s = sin(angle);

                float3x3 yaw = (c,-s,0, s,c,0, 0,1);
                float3x3 pitch = (c,0,s, 0,1,0, -s,0,c);
                float3x3 roll = (1,0,0, 0,c,-s, 0,s,c);

                //return mul(mul(yaw, mul(pitch,roll)) , vert);
                return mul(roll, vert);
                }

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex.xyz = RoatateMatrix3D(o.vertex.xyz, _RotationAmount);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
