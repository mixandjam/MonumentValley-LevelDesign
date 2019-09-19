Shader "Unlit/Transparent Cutout (Shadow)" 
{
    Properties 
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Cutoff  ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader 
    {
        Tags {"Queue" = "AlphaTest" "RenderType" = "TransparentCutout"}

        Pass 
        {
            Tags {"LightMode" = "ForwardBase"}
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile_fwdbase
                #pragma fragmentoption ARB_fog_exp2
                #pragma fragmentoption ARB_precision_hint_fastest
                #pragma alphatest:_Cutoff
               
                #include "UnityCG.cginc"
                #include "AutoLight.cginc"
               
                struct v2f
                {
                    float4  pos         : SV_POSITION;
                    float2  uv          : TEXCOORD0;
                    LIGHTING_COORDS(0,1)
                };
 
                float _Cutoff;
                fixed4 _Color;
                uniform float4 _LightColor0;
                sampler2D _MainTex;
                float4 _MainTex_ST;

                v2f vert (appdata_tan v)
                {
                    v2f o;
                   
                    o.pos = UnityObjectToClipPos( v.vertex);
                    o.uv = v.texcoord.xy;
                    o.uv = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
                    TRANSFER_VERTEX_TO_FRAGMENT(o);
                    return o;
                }
               
                fixed4 frag(v2f i) : COLOR
                {
                    fixed4 color = tex2D(_MainTex, i.uv);
                    fixed4 ambient = _LightColor0 * _Color;
                    clip(color.a - _Cutoff);
                   
                    fixed atten = LIGHT_ATTENUATION(i); // Light attenuation + shadows.
                    //fixed atten = SHADOW_ATTENUATION(i); // Shadows ONLY.
                    return color * ambient * atten;
                }
            ENDCG
        }
 
        Pass 
        {
            Tags {"LightMode" = "ForwardAdd"}
            Blend OneMinusDstColor One
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile_fwdadd_fullshadows
                #pragma fragmentoption ARB_fog_exp2
                #pragma fragmentoption ARB_precision_hint_fastest
               
                #include "UnityCG.cginc"
                #include "AutoLight.cginc"
               
                struct v2f
                {
                    float4 pos         : SV_POSITION;
                    float2 uv          : TEXCOORD0;
                    fixed3 diff         : COLOR0;
                    fixed3 ambient      : COLOR1;
                    LIGHTING_COORDS(0,1)
                };
                
                float _Cutoff;
                fixed4 _Color;
                uniform float4 _LightColor0;
                sampler2D _MainTex;
                float4 _MainTex_ST;
                
                v2f vert (appdata_tan v)
                {
                    v2f o;
                   
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
                    TRANSFER_VERTEX_TO_FRAGMENT(o);
                    return o;
                }
               
                fixed4 frag(v2f i) : COLOR
                {
                    fixed4 color = tex2D(_MainTex, i.uv);
                    clip(color.a - _Cutoff);   
                                   
                    fixed atten = LIGHT_ATTENUATION(i); // Light attenuation + shadows.
                    //fixed atten = SHADOW_ATTENUATION(i); // Shadows ONLY.       

                    return tex2D(_MainTex, i.uv) * _Color * _LightColor0 * atten;
                }
            ENDCG
        }
    }
    Fallback "Transparent/Cutout/VertexLit"
}
