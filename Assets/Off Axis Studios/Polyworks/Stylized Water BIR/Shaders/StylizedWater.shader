Shader "Off Axis Studios/Stylized Water (Built-In)"
{
    Properties
    {
        [Header(Waves System 1)]
        _Wave1Dir("Direction", Range(0, 1)) = 0.65
        _Wave1Amps("Amplitude", float) = 0.1
        _Wave1Length("Wavelength", float) = 1.5
        _Wave1Speed("Speed", float) = 0.1

        [Header(Wave System 2)]
        _Wave2Dir("Direction", Range(0, 1)) = 0.7
        _Wave2Amps("Amplitude", float) = 0.15
        _Wave2Length("Wavelength", float) = 5
        _Wave2Speed("Speed", float) = 0.75

        [Header(Color and Depth)]
        [HDR]
        _ShallowColor("Shallow Water", Color) = (0.91, 0.98, 1.0, 1.0)
        [HDR]
        _DeepColor("Deep Water", Color) = (0.0, 0.72, 0.71, 1.0)
        _WaterDepth("Water Depth", Range(0.0, 1.0)) = 0.2
        [HDR]
        _DistanceColor("Distance Cutoff Color", Color) = (0.04, 0.24, 0.67, 1.0)
        _DistanceCutoff("Distance Cutoff", Range(0.0, 1.0)) = 0.06
        [HDR]
        _SubSurfColor("Subsurface Scattering Color", Color) = (1.0, 0.6, 0.47, 1)
        [HDR]
        _SpecColor("Sun Specular Color", Color) = (1.0, 0.35, 0.15, 1.0)
        _SunSpecularPower("Specular Power", float) = 30
        _ReflectionPower("Reflection Power", Range(0.0, 1.0)) = 0.4

        [Header(Edge Foam)]
        [NoScaleOffset]
        _EdgeFoamTexture("Edge Foam Texture", 2D) = "white"{}
        [HDR]
        _EdgeFoamColor("Edge Foam Color", Color) = (0.19, 0.19, 0.19, 1.0)
        _EdgeFoamSize("Edge Foam Size", float) = 0.1

        [Header(Waves)]
        [NoScaleOffset]
        _WaveNormalMap ("Flow Map", 2D) = "bump"{}
        _WaveNormalScale ("Wave Scale", float) = 50.0
        _WaveNormalSpeed ("Wave Speed", float) = 0.02

        [Header(Foam Glint)]
        [NoScaleOffset]
        _GlintNormalMap("Foam Glint Map", 2D) = "bump"{}
        [HDR]
        _GlintColor("Foam Glint Color", Color) = (0.47, 0.47, 0.47, 1.0)
        _GlintScale("Foam Glint Scale", float) = 20
        _GlintSpeed("Foam Glint Speed", float) = 0.01
        _GlintPower("Foam Glint Power", float) = 50

        [Header(Caustics)]
        [NoScaleOffset]
        _CausticsTexture ("Caustics Texture", 2D) = "black"{}
        _CausticsScale ("Caustics Scale", float) = 12
        _CausticsSpeed ("Caustics Speed", float) = 0.1
        _CausticsPower("Caustics Power", Range(0.0, 1.0)) = 1.0
        _CausticsNoiseScale ("Noise Scale", Range(0.0, 1.0)) = 0.01
    }
    SubShader
    {
        LOD 100

        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }

        GrabPass
        {
            "_GrabTexture"
        }

        Pass
        {
            Tags
            {
                "LightMode" = "Always" 
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float _WaterDepth;
            float _DistanceCutoff;
            sampler2D _WaveNormalMap;
            float _WaveNormalScale;
            float _WaveNormalSpeed;
            float4 _ShallowColor;
            float4 _DeepColor;
            float4 _DistanceColor;
            float _ReflectionPower;
            float4 _SubSurfColor;
            sampler2D _CausticsTexture;
            float _CausticsScale;
            float _CausticsNoiseScale;
            float _CausticsSpeed;
            float _CausticsPower;
            float4 _SpecColor;
            float _SunSpecularPower;
            sampler2D _GlintNormalMap;
            float _GlintScale;
            float _GlintSpeed;
            float _GlintPower;
            float4 _GlintColor;
            sampler2D _EdgeFoamTexture;
            float4 _EdgeFoamColor;
            float _EdgeFoamSize;        
            sampler2D _MainShadowMap;
            float _Wave1Dir;
            float _Wave1Amps;
            float _Wave1Length;
            float _Wave1Speed;
            float _Wave2Dir;
            float _Wave2Amps;
            float _Wave2Length;
            float _Wave2Speed;
            sampler2D _GrabTexture;
            sampler2D _CameraDepthTexture;

            struct appdata
            {
                float4 vert : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vert : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float4 grabPos : TEXCOORD2;
                UNITY_FOG_COORDS(3)
            };

            float3 UEFourWayGlint(sampler2D tex, float2 uv, float4 coordScale, float speed)
            {
                float2 uv1 = (uv * coordScale.x) + normalize(float2(0.1, 0.1)) * speed * _Time.y;
                float2 uv2 = (uv * coordScale.y) + normalize(float2(-0.1, -0.1)) * speed * _Time.y;
                float2 uv3 = (uv * coordScale.z) + normalize(float2(-0.1, 0.1)) * speed * _Time.y;
                float2 uv4 = (uv * coordScale.w) + normalize(float2(0.1, -0.1)) * speed * _Time.y;
                float3 s1 = UnpackNormal(tex2D(tex, uv1)).rgb;
                float3 s2 = UnpackNormal(tex2D(tex, uv2)).rgb;
                float3 s3 = UnpackNormal(tex2D(tex, uv3)).rgb;
                float3 s4 = UnpackNormal(tex2D(tex, uv4)).rgb;
                float3 norm1 = float3(s1.x, s2.y, 1);
                float3 norm2 = float3(s3.x, s4.y, 1);

                return normalize(float3((norm1 + norm2).xy, (norm1 * norm2).z));
            }

            float3 UEFourWayChaos(sampler2D tex, float2 uv, float speed, bool unpack)
            {
                float3 s1;
                float3 s2;
                float3 s3;
                float3 s4;
                float2 uv1 = (uv + float2(0.000, 0.000)) + normalize(float2(0.1, 0.1)) * speed * _Time.y;
                float2 uv2 = (uv + float2(0.418, 0.355)) + normalize(float2(-0.1, -0.1)) * speed * _Time.y;
                float2 uv3 = (uv + float2(0.865, 0.148)) + normalize(float2(-0.1, 0.1)) * speed * _Time.y;
                float2 uv4 = (uv + float2(0.651, 0.752)) + normalize(float2(0.1, -0.1)) * speed * _Time.y;

                if (unpack)
                {
                    s1 = UnpackNormal(tex2D(tex, uv1)).rgb;
                    s2 = UnpackNormal(tex2D(tex, uv2)).rgb;
                    s3 = UnpackNormal(tex2D(tex, uv3)).rgb;
                    s4 = UnpackNormal(tex2D(tex, uv4)).rgb;

                    return normalize(s1 + s2 + s3 + s4);
                }
                else
                {
                    s1 = tex2D(tex, uv1).rgb;
                    s2 = tex2D(tex, uv2).rgb;
                    s3 = tex2D(tex, uv3).rgb;
                    s4 = tex2D(tex, uv4).rgb;

                    return (s1 + s2 + s3 + s4) / 4.0;
                }
            }

            float BasicWave(float2 pos, float2 dir, float length, float amp, float speed)
            {
                float x = 3.142 * dot(pos, dir) / length;
                float dist = speed * _Time.y;
                return amp * sin(x + dist);
                return amp * (1 - abs(sin(x + dist)));
            }

            float CorrectDepth(float rawDepth)
            {
                float z = _ProjectionParams.z;
                #if defined(UNITY_REVERSED_Z)
                z = 1.0f - _ProjectionParams.z;
                #endif
                float persp = LinearEyeDepth(rawDepth);
                float ortho = (z - _ProjectionParams.y) * (1 - rawDepth) + _ProjectionParams.y;
                return lerp(persp, ortho, unity_OrthoParams.w);
            }

            float WaveHeight(float2 worldPos)
            {
                float2 dir1 = float2(cos(3.142 * _Wave1Dir), sin(3.142 * _Wave1Dir));
                float2 dir2 = float2(cos(3.142 * _Wave2Dir), sin(3.142 * _Wave2Dir));
                float wave1 = BasicWave(worldPos, dir1, _Wave1Length, _Wave1Amps, _Wave1Speed);
                float wave2 = BasicWave(worldPos, dir2, _Wave2Length, _Wave2Amps, _Wave2Speed);
                return wave1 + wave2;
            }

            float3x3 WaveTBNMatrix(float2 worldPos, float d)
            {
                float height = WaveHeight(worldPos);
                float heightDX = WaveHeight(worldPos - float2(d, 0));
                float heightDZ = WaveHeight(worldPos - float2(0, d));

                float3 tangent = normalize(float3(0, height - heightDZ, d));
                float3 binorm = normalize(float3(d, height - heightDX, 0));

                float3 normal = normalize(cross(binorm, tangent));
                return transpose(float3x3(tangent, binorm, normal));
            }

            v2f vert (appdata v)
            {
                v2f o;

                o.worldPos = mul(unity_ObjectToWorld, v.vert).xyz;
                o.worldPos.y += WaveHeight(o.worldPos.xz);
                o.vert = mul(UNITY_MATRIX_VP, float4(o.worldPos, 1));
                o.grabPos = ComputeGrabScreenPos(o.vert);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vert);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float shadowMask = 1.0;

                float3 viewDir = normalize(i.worldPos - _WorldSpaceCameraPos);

                float3x3 worldTang = WaveTBNMatrix(i.worldPos.xz, 0.01);

                float3 timeNorm = UEFourWayChaos(_WaveNormalMap, i.worldPos.xz/_WaveNormalScale, _WaveNormalSpeed, true);
                float3 normalWS = mul(worldTang, timeNorm);

                float2 screenPos = i.grabPos.xy / i.grabPos.w;

                float4 fragCol = tex2D(_GrabTexture, screenPos.xy).rgba;
                float fragDepth = tex2D(_CameraDepthTexture, screenPos.xy).x;

                float depthOpto = abs(CorrectDepth(fragDepth) - CorrectDepth(i.vert.z));
                float depthT = exp(-_WaterDepth * depthOpto);

                float distMask = exp((-_DistanceCutoff / 10) * length(i.worldPos - _WorldSpaceCameraPos));

                float4 mainCol = fragCol * _ShallowColor;
                mainCol = lerp(_DeepColor, mainCol, depthT * max(0.5, shadowMask));
                mainCol = lerp(_DistanceColor, mainCol, distMask);

                float fresMask = 0.0 + 1.0 * pow(1.0 + dot(normalWS, -viewDir), 5.0);

                float4 reflectedCol = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, reflect(viewDir, normalWS));

                reflectedCol = reflectedCol * fresMask * distMask * shadowMask;
                reflectedCol = reflectedCol * _ReflectionPower;

                float4 subsurfCol = _SubSurfColor * WaveHeight(i.worldPos.xz);

                subsurfCol *= saturate(dot(viewDir, _WorldSpaceLightPos0.xyz));

                float2 foamUV = (i.worldPos.xz / _CausticsScale) + (_CausticsNoiseScale * timeNorm.xz);

                float3 foamBaseCol = UEFourWayChaos(_CausticsTexture, foamUV, _CausticsSpeed, false);
                foamBaseCol = foamBaseCol * distMask * shadowMask;
                foamBaseCol = foamBaseCol * _CausticsPower;
                float4 foamCol = float4(foamBaseCol.r, foamBaseCol.g, foamBaseCol.b, 1);

                float3 reflView = reflect(viewDir, normalWS);

                float specMask = saturate(dot(reflView, _WorldSpaceLightPos0));
                specMask = round(saturate(pow(specMask, _SunSpecularPower * 100)));
                specMask = specMask * shadowMask;

                float4 specCol = lerp(0, _SpecColor, specMask);

                float3 glintMain = UEFourWayGlint(_GlintNormalMap, i.worldPos.xz / (_GlintScale * 10), float4(1,2,3,4), _GlintSpeed);
                float3 glintSub = UEFourWayGlint(_GlintNormalMap, i.worldPos.xz / (_GlintScale * 10), float4(1,0.5,2.5,2), _GlintSpeed);

                float glintMask = dot(glintMain, glintSub) * saturate(3.0 * sqrt(saturate(dot(glintMain.x, glintSub.x))));
                glintMask = ceil(saturate(pow(glintMask, _GlintPower * 1000))) * shadowMask * distMask;

                float4 glintCol = lerp(0, _GlintColor, glintMask);

                float4 edgeFoamTex = tex2D(_EdgeFoamTexture, i.worldPos.xz);
                float edgeFoamMask = round(exp(-depthOpto / _EdgeFoamSize));
                float4 edgeFoamCol = lerp(0, _EdgeFoamColor, edgeFoamMask);
                edgeFoamCol = edgeFoamCol * edgeFoamTex;

                float4 finalCol = mainCol + reflectedCol + subsurfCol + foamCol;
                finalCol += specCol + glintCol + edgeFoamCol;

                UNITY_APPLY_FOG(i.fogCoord, finalCol);

                return float4(finalCol.r, finalCol.g, finalCol.b, 1);
            }
            ENDCG
        }
    }
}