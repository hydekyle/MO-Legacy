Shader "2DStylizedShadows"
{
    Properties
    {
        _shadowBaseColor("shadowBaseColor", Color) = (0, 0, 0, 0)
        _shadowBaseAlpha("shadowBaseAlpha", Float) = 1
        _shadowReflectiveness("shadowReflectiveness", Float) = 0.2
        [ToggleUI]_falloff("falloff", Float) = 1
        _shadowNarrowing("shadowNarrowing", Float) = 0.6
        _shadowFalloff("shadowFalloff", Float) = 3
        [ToggleUI]_vonroiTex("vonroiTex", Float) = 0
        [ToggleUI]_shadowTexture("shadowTexture", Float) = 0
        [ToggleUI]_afrigesTex("afrigesTex", Float) = 1
        [NoScaleOffset]_shadowTex("shadowTex", 2D) = "white" {}
        [ToggleUI]_fakeRefraction("fakeRefraction", Float) = 0
        _fastAntyaliasing("fastAntyaliasing", Range(0, 1)) = 0.5
        _edgeColor("edgeColor", Color) = (0.9716981, 0.6551973, 0.3529281, 0)
        _colorMlpRGB("colorMlpRGB", Vector) = (1, 1, 1, 0)
        _directional("_directional", Float) = 1
        [MainTexture][NoScaleOffset]_MainTex("_MainTex", 2D) = "white" {}
        [ToggleUI]_sceneLighten("_sceneLighten", Float) = 0
        [NoScaleOffset]_RenderText("RenderText", 2D) = "white" {}
        [ToggleUI]_enableBlur("enableBlur", Float) = 0
        _blurStrength("blurStrength", Range(0, 32)) = 1
        _blurArea("blurArea", Range(0, 32)) = 4
        _blurDir("blurDir", Vector) = (1, 1, 0, 0)
        [ToggleUI]_onlyRenderIn2DLight("_onlyRenderIn2DLight", Float) = 0
        _2DLightMLP("2DLightMLP", Float) = 2
        _2DLightMinAlpha("2DLightMinAlpha", Float) = 0
        [ToggleUI]_useClosestPointLightForDirection("_useClosestPointLightForDirection", Float) = 1
        [NonModifiableTextureData][NoScaleOffset]_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1("Texture2D", 2D) = "white" {}
        [NonModifiableTextureData][NoScaleOffset]_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1("Texture2D", 2D) = "white" {}
        [NonModifiableTextureData][NoScaleOffset]_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1("Texture2D", 2D) = "white" {}
        [NonModifiableTextureData][NoScaleOffset]_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1("Texture2D", 2D) = "white" {}
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"=""
        }

         Stencil {
		        Ref 4
		        Comp NotEqual
		        Pass Replace
		    }

        Pass
        {
            Name "Sprite Lit"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
            // Render State
            Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            #pragma multi_compile_fragment _ DEBUG_DISPLAY
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define ATTRIBUTES_NEED_TEXCOORD3
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD3
            #define VARYINGS_NEED_COLOR
            #define VARYINGS_NEED_SCREENPOSITION
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SPRITELIT
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
             float4 texCoord3;
             float4 color;
             float4 screenPosition;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 uv0;
             float4 uv1;
             float4 uv2;
             float4 uv3;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
             float4 interp5 : INTERP5;
             float4 interp6 : INTERP6;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.texCoord1;
            output.interp3.xyzw =  input.texCoord2;
            output.interp4.xyzw =  input.texCoord3;
            output.interp5.xyzw =  input.color;
            output.interp6.xyzw =  input.screenPosition;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.texCoord1 = input.interp2.xyzw;
            output.texCoord2 = input.interp3.xyzw;
            output.texCoord3 = input.interp4.xyzw;
            output.color = input.interp5.xyzw;
            output.screenPosition = input.interp6.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1_TexelSize;
        float4 _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1_TexelSize;
        float4 _SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1_TexelSize;
        float4 _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1_TexelSize;
        float4 _MainTex_TexelSize;
        float _shadowBaseAlpha;
        float _shadowReflectiveness;
        float _shadowNarrowing;
        float _shadowFalloff;
        float _shadowTexture;
        float4 _shadowTex_TexelSize;
        float _directional;
        float _fastAntyaliasing;
        float4 _edgeColor;
        float4 _RenderText_TexelSize;
        float3 _colorMlpRGB;
        float4 _shadowBaseColor;
        float _vonroiTex;
        float _afrigesTex;
        float _sceneLighten;
        float _falloff;
        float _fakeRefraction;
        float _enableBlur;
        float _blurStrength;
        float _blurArea;
        float4x4 _camProj;
        float4x4 _camWorldToCam;
        float2 _blurDir;
        float _onlyRenderIn2DLight;
        float _useClosestPointLightForDirection;
        float _2DLightMLP;
        float _2DLightMinAlpha;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Mirror);
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Point_Clamp);
        TEXTURE2D(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1);
        SAMPLER(sampler_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1);
        TEXTURE2D(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1);
        SAMPLER(sampler_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1);
        TEXTURE2D(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1);
        SAMPLER(sampler_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1);
        TEXTURE2D(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1);
        SAMPLER(sampler_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1);
        TEXTURE2D(_ShapeLightTexture0);
        SAMPLER(sampler_ShapeLightTexture0);
        float4 _ShapeLightTexture0_TexelSize;
        TEXTURE2D(_ShapeLightTexture1);
        SAMPLER(sampler_ShapeLightTexture1);
        float4 _ShapeLightTexture1_TexelSize;
        TEXTURE2D(_ShapeLightTexture2);
        SAMPLER(sampler_ShapeLightTexture2);
        float4 _ShapeLightTexture2_TexelSize;
        TEXTURE2D(_ShapeLightTexture3);
        SAMPLER(sampler_ShapeLightTexture3);
        float4 _ShapeLightTexture3_TexelSize;
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_shadowTex);
        SAMPLER(sampler_shadowTex);
        float2 _distMinMax;
        float3 _source;
        TEXTURE2D(_RenderText);
        SAMPLER(sampler_RenderText);
        float _minX;
        float _maxX;
        float _maxY;
        float _minY;
        float _fromSS;
        TEXTURE2D(_ModernShadowMask);
        SAMPLER(sampler_ModernShadowMask);
        float4 _ModernShadowMask_TexelSize;
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float4x4_float4x4(float4x4 A, float4x4 B, out float4x4 Out)
        {
        Out = mul(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
        {
        Out = mul(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        struct Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float
        {
        float3 WorldSpacePosition;
        };
        
        void SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(float4x4 _projectionMatrix, float4x4 _worldToCamMatrix, Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float IN, out float2 OutVector2_1)
        {
        float4x4 _Property_5e250b4a0f6742d492e1ffaa326ca712_Out_0 = _projectionMatrix;
        float4x4 _Property_b38ed1c9e33148539fa2aa331fad3e1e_Out_0 = _worldToCamMatrix;
        float4x4 _Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2;
        Unity_Multiply_float4x4_float4x4(_Property_5e250b4a0f6742d492e1ffaa326ca712_Out_0, _Property_b38ed1c9e33148539fa2aa331fad3e1e_Out_0, _Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2);
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_R_1 = IN.WorldSpacePosition[0];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_G_2 = IN.WorldSpacePosition[1];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_B_3 = IN.WorldSpacePosition[2];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_A_4 = 0;
        float4 _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4;
        float3 _Combine_b12c047fc90143598606bddcbbd3235c_RGB_5;
        float2 _Combine_b12c047fc90143598606bddcbbd3235c_RG_6;
        Unity_Combine_float(_Split_b28438aa8fd74da8879ec59ca390c4cb_R_1, _Split_b28438aa8fd74da8879ec59ca390c4cb_G_2, _Split_b28438aa8fd74da8879ec59ca390c4cb_B_3, 1, _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4, _Combine_b12c047fc90143598606bddcbbd3235c_RGB_5, _Combine_b12c047fc90143598606bddcbbd3235c_RG_6);
        float4 _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2;
        Unity_Multiply_float4x4_float4(_Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2, _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4, _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2);
        float _Split_eea358322a8b41d293cd1bbe8f795d83_R_1 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[0];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_G_2 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[1];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_B_3 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[2];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_A_4 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[3];
        float _Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2;
        Unity_Divide_float(_Split_eea358322a8b41d293cd1bbe8f795d83_R_1, _Split_eea358322a8b41d293cd1bbe8f795d83_A_4, _Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2);
        float _Add_8870e08ad8dc441aabe116e7732263ea_Out_2;
        Unity_Add_float(_Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2, 1, _Add_8870e08ad8dc441aabe116e7732263ea_Out_2);
        float _Multiply_990533093df5477c870cf76611148a17_Out_2;
        Unity_Multiply_float_float(_Add_8870e08ad8dc441aabe116e7732263ea_Out_2, 0.5, _Multiply_990533093df5477c870cf76611148a17_Out_2);
        float _Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2;
        Unity_Divide_float(_Split_eea358322a8b41d293cd1bbe8f795d83_G_2, _Split_eea358322a8b41d293cd1bbe8f795d83_A_4, _Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2);
        float _Add_5e3971a220d6404eab9366f74c9b69ea_Out_2;
        Unity_Add_float(_Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2, 1, _Add_5e3971a220d6404eab9366f74c9b69ea_Out_2);
        float _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2;
        Unity_Multiply_float_float(_Add_5e3971a220d6404eab9366f74c9b69ea_Out_2, 0.5, _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2);
        float2 _Vector2_061b57261ebb4976a044de3c8350d020_Out_0 = float2(_Multiply_990533093df5477c870cf76611148a17_Out_2, _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2);
        OutVector2_1 = _Vector2_061b57261ebb4976a044de3c8350d020_Out_0;
        }
        
        void Box_blur_float(UnityTexture2D tex, float2 UV, float2 texelS, float area, float strength, float2 dir, float2 pos, out float4 col){
        float4 o = 0;
        
        float sum = 0;
        
        float2 uvOffset;
        
        float weight = 1;
        
        
        float4 oc =  tex2D(tex,UV).xyzw;
        
        if(pos.x < 0.001 || pos.x > 0.999 || pos.y < 0.001 || pos.y > 0.999 ) col = tex2D(tex, UV);
        else{
        for(int x = - area / 2; x <= area / 2; ++x)
        
        {
        
        
        	for(int y = - area / 2; y <= area / 2; ++y)
        
        	{
        
        		uvOffset = UV;
        
        		uvOffset.x += dir.x *  ((x) *1/ texelS.x);
        
        		uvOffset.y +=dir.y *  ((y) * 1/texelS.y);
        
        		o += tex2Dlod(tex, float4(uvOffset.xy,1,1)) * weight;
        
        		sum += weight;
        
        	}
        
        
        }
        
        o *= (1.0f / sum);
        
        col = col  = lerp( oc , o , strength);
        }
        }
        
        struct Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float
        {
        };
        
        void SG_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float(UnityTexture2D _MainTex2, float2 _uv, float2 _texelS, float _area, float _sigmaX, float2 _dir, float2 _pos, Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float IN, out float4 col_1)
        {
        UnityTexture2D _Property_7b2e56d44efd4399bcf6bbbd21d74b66_Out_0 = _MainTex2;
        float2 _Property_b9ec06981d75414bba0afd20bdd9de9c_Out_0 = _uv;
        float2 _Property_56e4b5fb23744ef899acefff47f35e49_Out_0 = _texelS;
        float _Property_4271e8b1fb344e109adbcec48df8eac4_Out_0 = _area;
        float _Property_6c7096cbbb374fb2ad4280093f02c412_Out_0 = _sigmaX;
        float2 _Property_77ed7a1a234140cdb128ae9f188ef889_Out_0 = _dir;
        float2 _Property_9f9d5a72bffd4c8aaa578bd8b3a100a1_Out_0 = _pos;
        float4 _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4;
        Box_blur_float(_Property_7b2e56d44efd4399bcf6bbbd21d74b66_Out_0, _Property_b9ec06981d75414bba0afd20bdd9de9c_Out_0, _Property_56e4b5fb23744ef899acefff47f35e49_Out_0, _Property_4271e8b1fb344e109adbcec48df8eac4_Out_0, _Property_6c7096cbbb374fb2ad4280093f02c412_Out_0, _Property_77ed7a1a234140cdb128ae9f188ef889_Out_0, _Property_9f9d5a72bffd4c8aaa578bd8b3a100a1_Out_0, _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4);
        col_1 = _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4;
        }
        
        void Unity_ColorspaceConversion_RGB_HSV_float(float3 In, out float3 Out)
        {
            float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
            float4 P = lerp(float4(In.bg, K.wz), float4(In.gb, K.xy), step(In.b, In.g));
            float4 Q = lerp(float4(P.xyw, In.r), float4(In.r, P.yzx), step(P.x, In.r));
            float D = Q.x - min(Q.w, Q.y);
            float  E = 1e-10;
            float V = (D == 0) ? Q.x : (Q.x + E);
            Out = float3(abs(Q.z + (Q.w - Q.y)/(6.0 * D + E)), D / (Q.x + E), V);
        }
        
        void Unity_ColorspaceConversion_HSV_RGB_float(float3 In, out float3 Out)
        {
            float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
            float3 P = abs(frac(In.xxx + K.xyz) * 6.0 - K.www);
            Out = In.z * lerp(K.xxx, saturate(P - K.xxx), In.y);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float3(float3 In, out float3 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_DDXY_06eaa0d2fa7d4e1fa8820dc0c8697336_float(float In, out float Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING)
                    #error 'DDXY' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            Out = abs(ddx(In)) + abs(ddy(In));
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float
        {
        };
        
        void SG_getSpriteUV_28898200da561d54c95498da7ec1387b_float(float _isFromSpriteSheet, float2 _uv, float _minX, float _maxX, float _minY, float _maxY, Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float IN, out float2 UV_1)
        {
        float _Property_59629b1305f34389b5ac2ae936e1d97a_Out_0 = _isFromSpriteSheet;
        float2 _Property_d386229f3dbd464c8b50826a8175c772_Out_0 = _uv;
        float _Split_aeed631f945444d188e965907d53f468_R_1 = _Property_d386229f3dbd464c8b50826a8175c772_Out_0[0];
        float _Split_aeed631f945444d188e965907d53f468_G_2 = _Property_d386229f3dbd464c8b50826a8175c772_Out_0[1];
        float _Split_aeed631f945444d188e965907d53f468_B_3 = 0;
        float _Split_aeed631f945444d188e965907d53f468_A_4 = 0;
        float _Property_3d13d310f40c4a38978749b541492e7e_Out_0 = _minX;
        float _Subtract_14c500329721426892410b2ffe30cc75_Out_2;
        Unity_Subtract_float(_Split_aeed631f945444d188e965907d53f468_R_1, _Property_3d13d310f40c4a38978749b541492e7e_Out_0, _Subtract_14c500329721426892410b2ffe30cc75_Out_2);
        float _Property_4b8021ce9c1f44d2b60bfff4c7d3c6d5_Out_0 = _maxX;
        float _Property_0c3a9984187940adb91e772580242719_Out_0 = _minX;
        float _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2;
        Unity_Subtract_float(_Property_4b8021ce9c1f44d2b60bfff4c7d3c6d5_Out_0, _Property_0c3a9984187940adb91e772580242719_Out_0, _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2);
        float _Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2;
        Unity_Divide_float(_Subtract_14c500329721426892410b2ffe30cc75_Out_2, _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2, _Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2);
        float _Property_fc2e7f28e6324e83ae0f9f10c53a4712_Out_0 = _minY;
        float _Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2;
        Unity_Subtract_float(_Split_aeed631f945444d188e965907d53f468_G_2, _Property_fc2e7f28e6324e83ae0f9f10c53a4712_Out_0, _Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2);
        float _Property_db14e0563c964d5db8b1c4b2265606be_Out_0 = _maxY;
        float _Property_f5f38a602035427790bc38042352fa9c_Out_0 = _minY;
        float _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2;
        Unity_Subtract_float(_Property_db14e0563c964d5db8b1c4b2265606be_Out_0, _Property_f5f38a602035427790bc38042352fa9c_Out_0, _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2);
        float _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2;
        Unity_Divide_float(_Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2, _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2, _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2);
        float4 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGBA_4;
        float3 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGB_5;
        float2 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6;
        Unity_Combine_float(_Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2, _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2, 0, 0, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGBA_4, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGB_5, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6);
        float2 _Property_b83213148b3746ada7e8c109a157d5eb_Out_0 = _uv;
        float2 _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3;
        Unity_Branch_float2(_Property_59629b1305f34389b5ac2ae936e1d97a_Out_0, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6, _Property_b83213148b3746ada7e8c109a157d5eb_Out_0, _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3);
        UV_1 = _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3;
        }
        
        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Saturate_float4(float4 In, out float4 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Blend_Overlay_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            float4 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float4 result2 = 2.0 * Base * Blend;
            float4 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Blend_Multiply_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Distance_float2(float2 A, float2 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_DDXY_4c15eab26cdc46fcb709d614ebea98aa_float(float In, out float Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING)
                    #error 'DDXY' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            Out = abs(ddx(In)) + abs(ddy(In));
        }
        
        void Unity_InverseLerp_float(float A, float B, float T, out float Out)
        {
            Out = (T - A)/(B - A);
        }
        
        struct Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float
        {
        half4 uv0;
        };
        
        void SG_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float(float _fastAntyaliasing, UnityTexture2D _MainTex, Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float IN, out float OutVector1_1)
        {
        float _Property_df7f9d1e6f3644bcbb0570916415aa00_Out_0 = _fastAntyaliasing;
        UnityTexture2D _Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0 = _MainTex;
        float4 _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0 = SAMPLE_TEXTURE2D(_Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Point_Clamp).samplerstate, _Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0.GetTransformedUV(IN.uv0.xy));
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_R_4 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.r;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_G_5 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.g;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_B_6 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.b;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.a;
        float _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1;
        Unity_DDXY_4c15eab26cdc46fcb709d614ebea98aa_float(_SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7, _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1);
        float _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2;
        Unity_Multiply_float_float(_Property_df7f9d1e6f3644bcbb0570916415aa00_Out_0, _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1, _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2);
        float _InverseLerp_394949f6e03a449798553a3a5429204a_Out_3;
        Unity_InverseLerp_float(1, 0, _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2, _InverseLerp_394949f6e03a449798553a3a5429204a_Out_3);
        float _Multiply_645ac89284924907975d95479e12d3a8_Out_2;
        Unity_Multiply_float_float(_InverseLerp_394949f6e03a449798553a3a5429204a_Out_3, _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7, _Multiply_645ac89284924907975d95479e12d3a8_Out_2);
        OutVector1_1 = _Multiply_645ac89284924907975d95479e12d3a8_Out_2;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Minimum_float(float A, float B, out float Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Blend_Multiply_float(float Base, float Blend, out float Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Maximum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void GetAlpha_float(float alphaBase, float light, float mlp, float minAlpha, out float4 res){
        res = min(1.0, max(minAlpha, alphaBase * (light/10) * mlp ));
        }
        
        struct Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float
        {
        float3 WorldSpacePosition;
        };
        
        void SG_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float(float _shadow_alpha, float _2DLightMLP, float _2DLightMinAlpha, float _onlyRenderIn2DLight, float4x4 _camProj, float4x4 _camWorldToCam, Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float IN, out float4 OutVector4_1)
        {
        float _Property_3e1a6e8cf6c7482ba86cf4139dd7c69e_Out_0 = _onlyRenderIn2DLight;
        float _Property_a24ed8de38314c7b91fc5501a78e320a_Out_0 = _shadow_alpha;
        float4x4 _Property_022e2f884d7542508c664e14f0ca6b89_Out_0 = _camProj;
        float4x4 _Property_ea154a1dce9248de95cc6ae98b5a49f4_Out_0 = _camWorldToCam;
        Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767;
        _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767.WorldSpacePosition = IN.WorldSpacePosition;
        float2 _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1;
        SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_022e2f884d7542508c664e14f0ca6b89_Out_0, _Property_ea154a1dce9248de95cc6ae98b5a49f4_Out_0, _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767, _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1);
        float4 _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_R_4 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.r;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_G_5 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.g;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_B_6 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.b;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_A_7 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.a;
        float4 _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_R_4 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.r;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_G_5 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.g;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_B_6 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.b;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_A_7 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.a;
        float4 _Maximum_600d428159ef4ae19733009631d8183e_Out_2;
        Unity_Maximum_float4(_SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0, _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0, _Maximum_600d428159ef4ae19733009631d8183e_Out_2);
        float4 _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_R_4 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.r;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_G_5 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.g;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_B_6 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.b;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_A_7 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.a;
        float4 _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_R_4 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.r;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_G_5 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.g;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_B_6 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.b;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_A_7 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.a;
        float4 _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2;
        Unity_Maximum_float4(_SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0, _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0, _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2);
        float4 _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2;
        Unity_Maximum_float4(_Maximum_600d428159ef4ae19733009631d8183e_Out_2, _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2, _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2);
        float _Split_079a7389553a46f6b2e083de5ab0ec35_R_1 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[0];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_G_2 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[1];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_B_3 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[2];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_A_4 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[3];
        float _Maximum_459027f3b3df4840b45351867af70ed1_Out_2;
        Unity_Maximum_float(_Split_079a7389553a46f6b2e083de5ab0ec35_B_3, _Split_079a7389553a46f6b2e083de5ab0ec35_G_2, _Maximum_459027f3b3df4840b45351867af70ed1_Out_2);
        float _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2;
        Unity_Maximum_float(_Maximum_459027f3b3df4840b45351867af70ed1_Out_2, _Split_079a7389553a46f6b2e083de5ab0ec35_R_1, _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2);
        float _Property_111bb76eab7a41619d344262fafa3895_Out_0 = _2DLightMLP;
        float _Property_070598259d31416e98256505bbb2b2de_Out_0 = _2DLightMinAlpha;
        float4 _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0;
        GetAlpha_float(_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0, _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2, _Property_111bb76eab7a41619d344262fafa3895_Out_0, _Property_070598259d31416e98256505bbb2b2de_Out_0, _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0);
        float4 _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2;
        Unity_Multiply_float4_float4((_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0.xxxx), _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0, _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2);
        float4 _Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3;
        Unity_Branch_float4(_Property_3e1a6e8cf6c7482ba86cf4139dd7c69e_Out_0, _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2, (_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0.xxxx), _Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3);
        float4 _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1;
        Unity_Saturate_float4(_Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3, _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1);
        OutVector4_1 = _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreSurface' */
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float4 SpriteMask;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_266f14f34a3c468e99c82838d2327dc3_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_ae79c0121c0442198ad8a19481d850c8_Out_0 = IN.uv0;
            float _TexelSize_86396267145246039524276a2683b94d_Width_0 = _Property_266f14f34a3c468e99c82838d2327dc3_Out_0.texelSize.z;
            float _TexelSize_86396267145246039524276a2683b94d_Height_2 = _Property_266f14f34a3c468e99c82838d2327dc3_Out_0.texelSize.w;
            float2 _Vector2_adbf5eb295764b359c895d572e0af102_Out_0 = float2(_TexelSize_86396267145246039524276a2683b94d_Width_0, _TexelSize_86396267145246039524276a2683b94d_Height_2);
            float _Property_1a28fa3b35dd4e1193848f9373679a25_Out_0 = _blurArea;
            float _Property_840bd827292044b297da6b2206472467_Out_0 = _blurStrength;
            float2 _Property_747cea1fc384479a8ebbb6c75f25a52b_Out_0 = _blurDir;
            float4x4 _Property_e97cf15c65fe40818e58b226aa758447_Out_0 = _camProj;
            float4x4 _Property_52c5f0665044443c9ea9e1b36de2aa09_Out_0 = _camWorldToCam;
            Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075;
            _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075.WorldSpacePosition = IN.WorldSpacePosition;
            float2 _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1;
            SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_e97cf15c65fe40818e58b226aa758447_Out_0, _Property_52c5f0665044443c9ea9e1b36de2aa09_Out_0, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1);
            Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float _BoxBlur_146e8bef57604c11860c784ef32014b2;
            float4 _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1;
            SG_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float(_Property_266f14f34a3c468e99c82838d2327dc3_Out_0, (_UV_ae79c0121c0442198ad8a19481d850c8_Out_0.xy), _Vector2_adbf5eb295764b359c895d572e0af102_Out_0, _Property_1a28fa3b35dd4e1193848f9373679a25_Out_0, _Property_840bd827292044b297da6b2206472467_Out_0, _Property_747cea1fc384479a8ebbb6c75f25a52b_Out_0, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1, _BoxBlur_146e8bef57604c11860c784ef32014b2, _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1);
            float3 _Swizzle_fed63552fea74a82b1fe0ca74edd6df4_Out_1 = _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1.xyz;
            float3 _ColorspaceConversion_17aac4afc7e149f9bd1dbcdc53fc982e_Out_1;
            Unity_ColorspaceConversion_RGB_HSV_float(_Swizzle_fed63552fea74a82b1fe0ca74edd6df4_Out_1, _ColorspaceConversion_17aac4afc7e149f9bd1dbcdc53fc982e_Out_1);
            float _Split_58c8750204e647bbb36cd50373d931d0_R_1 = _ColorspaceConversion_17aac4afc7e149f9bd1dbcdc53fc982e_Out_1[0];
            float _Split_58c8750204e647bbb36cd50373d931d0_G_2 = _ColorspaceConversion_17aac4afc7e149f9bd1dbcdc53fc982e_Out_1[1];
            float _Split_58c8750204e647bbb36cd50373d931d0_B_3 = _ColorspaceConversion_17aac4afc7e149f9bd1dbcdc53fc982e_Out_1[2];
            float _Split_58c8750204e647bbb36cd50373d931d0_A_4 = 0;
            float _Property_a578b672ef8d499fb71fe871f97f5967_Out_0 = _shadowReflectiveness;
            float _Multiply_855c629b4232431faf5da90b7e1fecaf_Out_2;
            Unity_Multiply_float_float(_Property_a578b672ef8d499fb71fe871f97f5967_Out_0, _Split_58c8750204e647bbb36cd50373d931d0_B_3, _Multiply_855c629b4232431faf5da90b7e1fecaf_Out_2);
            float4 _Combine_8ff61a2c12b2488c9e4bd77966993c5f_RGBA_4;
            float3 _Combine_8ff61a2c12b2488c9e4bd77966993c5f_RGB_5;
            float2 _Combine_8ff61a2c12b2488c9e4bd77966993c5f_RG_6;
            Unity_Combine_float(_Split_58c8750204e647bbb36cd50373d931d0_R_1, _Split_58c8750204e647bbb36cd50373d931d0_G_2, _Multiply_855c629b4232431faf5da90b7e1fecaf_Out_2, 0, _Combine_8ff61a2c12b2488c9e4bd77966993c5f_RGBA_4, _Combine_8ff61a2c12b2488c9e4bd77966993c5f_RGB_5, _Combine_8ff61a2c12b2488c9e4bd77966993c5f_RG_6);
            float3 _ColorspaceConversion_17f1b3c9081a4bbb8b932084b94bec3c_Out_1;
            Unity_ColorspaceConversion_HSV_RGB_float(_Combine_8ff61a2c12b2488c9e4bd77966993c5f_RGB_5, _ColorspaceConversion_17f1b3c9081a4bbb8b932084b94bec3c_Out_1);
            float _Property_b669c699f87947f8a1994a3bfbc526b0_Out_0 = _shadowReflectiveness;
            float3 _Lerp_3d9460391c064094a9d8a8c0b5e5ee5a_Out_3;
            Unity_Lerp_float3(float3(0, 0, 0), _ColorspaceConversion_17f1b3c9081a4bbb8b932084b94bec3c_Out_1, (_Property_b669c699f87947f8a1994a3bfbc526b0_Out_0.xxx), _Lerp_3d9460391c064094a9d8a8c0b5e5ee5a_Out_3);
            float4 _Property_0cc90261cefa4060a85a5079cc35c8de_Out_0 = _shadowBaseColor;
            float3 _Add_3b9123a3910e40c19bb017a6a7688f39_Out_2;
            Unity_Add_float3(_Lerp_3d9460391c064094a9d8a8c0b5e5ee5a_Out_3, (_Property_0cc90261cefa4060a85a5079cc35c8de_Out_0.xyz), _Add_3b9123a3910e40c19bb017a6a7688f39_Out_2);
            float3 _Saturate_5084b46603f04a9ab574325246783dec_Out_1;
            Unity_Saturate_float3(_Add_3b9123a3910e40c19bb017a6a7688f39_Out_2, _Saturate_5084b46603f04a9ab574325246783dec_Out_1);
            float _Property_3f7b82f885f44557b465281f8981a5f2_Out_0 = _fakeRefraction;
            float _Property_f943282d6b89438bba06715ad06c2dfd_Out_0 = _shadowBaseAlpha;
            float4 _Property_bd156a3353cf4a5ea9ee80677f475bbd_Out_0 = _edgeColor;
            UnityTexture2D _Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_R_4 = _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_RGBA_0.r;
            float _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_G_5 = _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_RGBA_0.g;
            float _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_B_6 = _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_RGBA_0.b;
            float _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_A_7 = _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_RGBA_0.a;
            float _DDXY_06eaa0d2fa7d4e1fa8820dc0c8697336_Out_1;
            Unity_DDXY_06eaa0d2fa7d4e1fa8820dc0c8697336_float(_SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_A_7, _DDXY_06eaa0d2fa7d4e1fa8820dc0c8697336_Out_1);
            float _Step_952b6b4b91ee4888b3689e780f4a2f99_Out_2;
            Unity_Step_float(0.2, _DDXY_06eaa0d2fa7d4e1fa8820dc0c8697336_Out_1, _Step_952b6b4b91ee4888b3689e780f4a2f99_Out_2);
            float4 _Multiply_1d24ec9d7dec4657b07215729ec61576_Out_2;
            Unity_Multiply_float4_float4(_Property_bd156a3353cf4a5ea9ee80677f475bbd_Out_0, (_Step_952b6b4b91ee4888b3689e780f4a2f99_Out_2.xxxx), _Multiply_1d24ec9d7dec4657b07215729ec61576_Out_2);
            float4 _Multiply_6d78c9e4af5f4530bdac2ce6a0a4f639_Out_2;
            Unity_Multiply_float4_float4((_Property_f943282d6b89438bba06715ad06c2dfd_Out_0.xxxx), _Multiply_1d24ec9d7dec4657b07215729ec61576_Out_2, _Multiply_6d78c9e4af5f4530bdac2ce6a0a4f639_Out_2);
            float4 _Branch_d9eeb1a612a2410e9208d631a6ec0087_Out_3;
            Unity_Branch_float4(_Property_3f7b82f885f44557b465281f8981a5f2_Out_0, _Multiply_6d78c9e4af5f4530bdac2ce6a0a4f639_Out_2, float4(0, 0, 0, 0), _Branch_d9eeb1a612a2410e9208d631a6ec0087_Out_3);
            float3 _Add_d2ad54b0bbee4e26ac3523f057019bfd_Out_2;
            Unity_Add_float3(_Saturate_5084b46603f04a9ab574325246783dec_Out_1, (_Branch_d9eeb1a612a2410e9208d631a6ec0087_Out_3.xyz), _Add_d2ad54b0bbee4e26ac3523f057019bfd_Out_2);
            float3 _Saturate_c4375e7e98c549c1adaed9e32ff3586a_Out_1;
            Unity_Saturate_float3(_Add_d2ad54b0bbee4e26ac3523f057019bfd_Out_2, _Saturate_c4375e7e98c549c1adaed9e32ff3586a_Out_1);
            float _Property_39a0c80a760d442e92412ca9c31ccaf5_Out_0 = _shadowBaseAlpha;
            float _Property_65c6a4cc5d374f13b91cd81a27486ba3_Out_0 = _shadowTexture;
            float _Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1 = _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1.w;
            UnityTexture2D _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0 = UnityBuildTexture2DStructNoScale(_shadowTex);
            float4 _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.tex, _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.samplerstate, _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_R_4 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.r;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_G_5 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.g;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_B_6 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.b;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_A_7 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.a;
            float4 _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2;
            Unity_Multiply_float4_float4((_Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1.xxxx), _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0, _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2);
            float4 _Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3;
            Unity_Branch_float4(_Property_65c6a4cc5d374f13b91cd81a27486ba3_Out_0, _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2, (_Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1.xxxx), _Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3);
            float _Property_269f6df3fbd447efaeeb85f3a462424a_Out_0 = _falloff;
            float _Property_02de571028bb4a16975e641e43976cd2_Out_0 = _fromSS;
            float4 _UV_db00e0a911d64679b4c6580b6b1418df_Out_0 = IN.uv0;
            float _Property_24bc71ec982a439ca0ddc1247924bbe0_Out_0 = _minX;
            float _Property_24635cb30088450b914780cf23c64e07_Out_0 = _maxX;
            float _Property_517af63683904c6aafb247552ff3a011_Out_0 = _minY;
            float _Property_9fc5fb11323f4477912a01e1f9c6ab76_Out_0 = _maxY;
            Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1;
            float2 _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1;
            SG_getSpriteUV_28898200da561d54c95498da7ec1387b_float(_Property_02de571028bb4a16975e641e43976cd2_Out_0, (_UV_db00e0a911d64679b4c6580b6b1418df_Out_0.xy), _Property_24bc71ec982a439ca0ddc1247924bbe0_Out_0, _Property_24635cb30088450b914780cf23c64e07_Out_0, _Property_517af63683904c6aafb247552ff3a011_Out_0, _Property_9fc5fb11323f4477912a01e1f9c6ab76_Out_0, _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1, _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1);
            float _Property_38c07cfd50364af59198ace5a1218e1c_Out_0 = _shadowNarrowing;
            float2 _Vector2_30d73056b259424a903bb0260189385c_Out_0 = float2(0.5, _Property_38c07cfd50364af59198ace5a1218e1c_Out_0);
            float2 _Rotate_354f1e875f8142599da0f89a879950cf_Out_3;
            Unity_Rotate_Degrees_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, _Vector2_30d73056b259424a903bb0260189385c_Out_0, 180, _Rotate_354f1e875f8142599da0f89a879950cf_Out_3);
            float4 _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).GetTransformedUV(_Rotate_354f1e875f8142599da0f89a879950cf_Out_3));
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_R_4 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.r;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_G_5 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.g;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_B_6 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.b;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_A_7 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.a;
            float4 _Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2;
            Unity_Divide_float4(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0, float4(1, 1, 1, 1), _Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2);
            float2 _TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3;
            Unity_TilingAndOffset_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, float2 (1, 1), float2 (0, 0), _TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3);
            float _Property_3de54516355e446b941821236b3a5539_Out_0 = _shadowNarrowing;
            float2 _Vector2_5490d5e7275944b2a1d3e15aa999783d_Out_0 = float2(0.5, _Property_3de54516355e446b941821236b3a5539_Out_0);
            float2 _Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3, _Vector2_5490d5e7275944b2a1d3e15aa999783d_Out_0, 90, _Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3);
            float4 _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).GetTransformedUV(_Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3));
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_R_4 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.r;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_G_5 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.g;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_B_6 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.b;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_A_7 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.a;
            float2 _TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3;
            Unity_TilingAndOffset_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, float2 (1, 1), float2 (0, 0), _TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3);
            float _Property_053ef645b525429eb8514144a5f0d8a5_Out_0 = _shadowNarrowing;
            float2 _Vector2_9e0a92a790e6479782cb7f44e5e39a96_Out_0 = float2(0.5, _Property_053ef645b525429eb8514144a5f0d8a5_Out_0);
            float2 _Rotate_937724de82cd4b709bafc850c9efdd35_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3, _Vector2_9e0a92a790e6479782cb7f44e5e39a96_Out_0, -90, _Rotate_937724de82cd4b709bafc850c9efdd35_Out_3);
            float4 _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).GetTransformedUV(_Rotate_937724de82cd4b709bafc850c9efdd35_Out_3));
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_R_4 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.r;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_G_5 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.g;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_B_6 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.b;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_A_7 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.a;
            float4 _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0, _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0, _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2);
            float4 _Multiply_4274a6a328994084b1b182cd09384636_Out_2;
            Unity_Multiply_float4_float4(_Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2, _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2, _Multiply_4274a6a328994084b1b182cd09384636_Out_2);
            float _Property_8846c22cbd2548d79b405c31433a0bf6_Out_0 = _shadowFalloff;
            float4 _Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2;
            Unity_Multiply_float4_float4(_Multiply_4274a6a328994084b1b182cd09384636_Out_2, (_Property_8846c22cbd2548d79b405c31433a0bf6_Out_0.xxxx), _Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2);
            float4 _Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1;
            Unity_Saturate_float4(_Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2, _Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1);
            float4 _Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2;
            Unity_Multiply_float4_float4(_Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1, float4(2, 2, 2, 2), _Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2);
            float _Property_8f9cd0c877224528832afbf49c0eca9c_Out_0 = _afrigesTex;
            float _Property_d3b4849aa43442b9b501c852f80974ee_Out_0 = _shadowBaseAlpha;
            float2 _TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.3, 0.3), (IN.WorldSpacePosition.xy), _TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3);
            float2 _Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3, float2 (0.5, 0.5), 0, _Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3);
            float4 _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1).tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Mirror).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1).GetTransformedUV(_Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3));
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_R_4 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.r;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_G_5 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.g;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_B_6 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.b;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_A_7 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.a;
            float _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2;
            Unity_Multiply_float_float(_Property_d3b4849aa43442b9b501c852f80974ee_Out_0, _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_R_4, _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2);
            float _Branch_15f412beaf5e46b19f8226a5db075124_Out_3;
            Unity_Branch_float(_Property_8f9cd0c877224528832afbf49c0eca9c_Out_0, _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2, 1, _Branch_15f412beaf5e46b19f8226a5db075124_Out_3);
            float4 _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2;
            Unity_Multiply_float4_float4(_Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2, (_Branch_15f412beaf5e46b19f8226a5db075124_Out_3.xxxx), _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2);
            float4 _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2;
            Unity_Blend_Overlay_float4(_Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2, _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2, _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2, 0.2);
            float4 _Branch_66a6d2861e6d4f6089053a6772d86451_Out_3;
            Unity_Branch_float4(_Property_269f6df3fbd447efaeeb85f3a462424a_Out_0, _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2, float4(1, 1, 1, 1), _Branch_66a6d2861e6d4f6089053a6772d86451_Out_3);
            float _Property_045f4a7a2af440bd8b474a9a895a430c_Out_0 = _vonroiTex;
            float _Property_c04500d7725947a69a1cf465b73beaf6_Out_0 = _shadowBaseAlpha;
            float2 _TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.3, 0.3), (IN.WorldSpacePosition.xy), _TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3);
            float _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3;
            float _Voronoi_5185d06e2788480f9f5edfeac380e38e_Cells_4;
            Unity_Voronoi_float(_TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3, 2, 1, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Cells_4);
            float _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3;
            Unity_Smoothstep_float(0.3, 1, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3, _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3);
            float _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3;
            Unity_Smoothstep_float(0, 0.5, _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3, _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3);
            float _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2;
            Unity_Multiply_float_float(_Property_c04500d7725947a69a1cf465b73beaf6_Out_0, _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3, _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2);
            float _Branch_a08b046aadf043aa821d5d9e70298163_Out_3;
            Unity_Branch_float(_Property_045f4a7a2af440bd8b474a9a895a430c_Out_0, _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2, 1, _Branch_a08b046aadf043aa821d5d9e70298163_Out_3);
            float4 _Blend_16b43719a5d34dac880346881fe9f272_Out_2;
            Unity_Blend_Multiply_float4(_Branch_66a6d2861e6d4f6089053a6772d86451_Out_3, (_Branch_a08b046aadf043aa821d5d9e70298163_Out_3.xxxx), _Blend_16b43719a5d34dac880346881fe9f272_Out_2, 0.1);
            float4 _Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2;
            Unity_Multiply_float4_float4(_Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3, _Blend_16b43719a5d34dac880346881fe9f272_Out_2, _Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2);
            float _Property_1bc6b0136e3442f2bd0c835a17615a34_Out_0 = _directional;
            float _Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2;
            Unity_Comparison_Greater_float(_Property_1bc6b0136e3442f2bd0c835a17615a34_Out_0, 0.5, _Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2);
            float _Property_32038686d7c6415ba0e518addc902f38_Out_0 = _useClosestPointLightForDirection;
            float _Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2;
            Unity_Or_float(_Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2, _Property_32038686d7c6415ba0e518addc902f38_Out_0, _Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2);
            float2 _Swizzle_9179ff07d7164d409a2342edc50e4390_Out_1 = IN.WorldSpacePosition.xy;
            float3 _Property_414892493f164994ba130276c6cb2dc6_Out_0 = _source;
            float2 _Swizzle_aa67dcd65c5e4b98acb2bb10a34ef37d_Out_1 = _Property_414892493f164994ba130276c6cb2dc6_Out_0.xy;
            float _Distance_82ab97a70bec43dfab653173af856737_Out_2;
            Unity_Distance_float2(_Swizzle_9179ff07d7164d409a2342edc50e4390_Out_1, _Swizzle_aa67dcd65c5e4b98acb2bb10a34ef37d_Out_1, _Distance_82ab97a70bec43dfab653173af856737_Out_2);
            float2 _Property_9b36c1d04153475d95525b4c285bc80b_Out_0 = _distMinMax;
            float _Split_88cecf19cf4d4c149324206c388fe6cb_R_1 = _Property_9b36c1d04153475d95525b4c285bc80b_Out_0[0];
            float _Split_88cecf19cf4d4c149324206c388fe6cb_G_2 = _Property_9b36c1d04153475d95525b4c285bc80b_Out_0[1];
            float _Split_88cecf19cf4d4c149324206c388fe6cb_B_3 = 0;
            float _Split_88cecf19cf4d4c149324206c388fe6cb_A_4 = 0;
            float _Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3;
            Unity_Clamp_float(_Distance_82ab97a70bec43dfab653173af856737_Out_2, 0, _Split_88cecf19cf4d4c149324206c388fe6cb_G_2, _Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3);
            float2 _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0 = _distMinMax;
            float _Split_715f243a60c9433990660b04d84633e2_R_1 = _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0[0];
            float _Split_715f243a60c9433990660b04d84633e2_G_2 = _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0[1];
            float _Split_715f243a60c9433990660b04d84633e2_B_3 = 0;
            float _Split_715f243a60c9433990660b04d84633e2_A_4 = 0;
            float _Divide_b4f326bea5de462a992c509de3e5e831_Out_2;
            Unity_Divide_float(_Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3, _Split_715f243a60c9433990660b04d84633e2_G_2, _Divide_b4f326bea5de462a992c509de3e5e831_Out_2);
            float _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3;
            Unity_Lerp_float(0, 1, _Divide_b4f326bea5de462a992c509de3e5e831_Out_2, _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3);
            float _Branch_17569a76eab4481eb16fbe1782242f1d_Out_3;
            Unity_Branch_float(_Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2, 1, _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3, _Branch_17569a76eab4481eb16fbe1782242f1d_Out_3);
            float4 _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2;
            Unity_Blend_Multiply_float4(_Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2, (_Branch_17569a76eab4481eb16fbe1782242f1d_Out_3.xxxx), _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2, 1);
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_R_1 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[0];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_G_2 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[1];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_B_3 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[2];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_A_4 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[3];
            float _Property_a440c1c925654a4eb8f15fca48f5aa3d_Out_0 = _fastAntyaliasing;
            Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a;
            _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a.uv0 = IN.uv0;
            float _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1;
            SG_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float(_Property_a440c1c925654a4eb8f15fca48f5aa3d_Out_0, _Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1);
            float _Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2;
            Unity_Multiply_float_float(_Split_e085e2b7b0b9447cb31c3bedff43d4fa_R_1, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1, _Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2);
            float _Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0 = _sceneLighten;
            float3 _Property_a979b50a4dd341529f45439596b6ff98_Out_0 = _colorMlpRGB;
            float _Split_bd2a7871af334e818a970f83ab0fdce8_R_1 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[0];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_G_2 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[1];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_B_3 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[2];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_A_4 = 0;
            UnityTexture2D _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0 = UnityBuildTexture2DStructNoScale(_RenderText);
            float4x4 _Property_668393ac9856480ba5e4de219cd36c78_Out_0 = _camProj;
            float4x4 _Property_e0169419f075483c9fa9548fe401a2fe_Out_0 = _camWorldToCam;
            Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd;
            _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd.WorldSpacePosition = IN.WorldSpacePosition;
            float2 _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1;
            SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_668393ac9856480ba5e4de219cd36c78_Out_0, _Property_e0169419f075483c9fa9548fe401a2fe_Out_0, _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd, _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1);
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.tex, _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.samplerstate, _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.GetTransformedUV(_CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1), 1);
            #endif
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_R_5 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.r;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_G_6 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.g;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_B_7 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.b;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_A_8 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.a;
            float _Remap_fef0fe01a3a44d209390feb636d87117_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_R_5, float2 (0, 1), float2 (0, 2), _Remap_fef0fe01a3a44d209390feb636d87117_Out_3);
            float _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1;
            Unity_OneMinus_float(_Remap_fef0fe01a3a44d209390feb636d87117_Out_3, _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1);
            float _Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_R_1, _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1, _Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2);
            float _Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_G_6, float2 (0, 1), float2 (0, 2), _Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3);
            float _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1;
            Unity_OneMinus_float(_Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3, _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1);
            float _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_G_2, _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1, _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2);
            float _Minimum_881608b72fe747f49bb49799d4218a36_Out_2;
            Unity_Minimum_float(_Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2, _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2, _Minimum_881608b72fe747f49bb49799d4218a36_Out_2);
            float _Remap_c579a88bcefd49558c8688613e80f533_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_B_7, float2 (0, 1), float2 (0, 2), _Remap_c579a88bcefd49558c8688613e80f533_Out_3);
            float _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1;
            Unity_OneMinus_float(_Remap_c579a88bcefd49558c8688613e80f533_Out_3, _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1);
            float _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_B_3, _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1, _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2);
            float _Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2;
            Unity_Minimum_float(_Minimum_881608b72fe747f49bb49799d4218a36_Out_2, _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2, _Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2);
            float _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1;
            Unity_Saturate_float(_Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2, _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1);
            float _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3;
            Unity_Branch_float(_Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0, _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1, 0, _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3);
            float _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3;
            Unity_Branch_float(_Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0, 0.9, 0, _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3);
            float _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2;
            Unity_Blend_Multiply_float(_Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2, _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3, _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2, _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3);
            float _Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2;
            Unity_Multiply_float_float(_Property_39a0c80a760d442e92412ca9c31ccaf5_Out_0, _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2, _Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2);
            float _Property_5aaa24741fb4458496fadf63aabb26c7_Out_0 = _2DLightMLP;
            float _Property_664012205b8b47e3bddf2b78909fbdb5_Out_0 = _2DLightMinAlpha;
            float _Property_ee43ff1e651e4766a9d7825b4a41563e_Out_0 = _onlyRenderIn2DLight;
            float4x4 _Property_d9bbf4f126844f9691d1b659f2618f60_Out_0 = _camProj;
            float4x4 _Property_dcc5cca994d44486b344bbfaa27d94af_Out_0 = _camWorldToCam;
            Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99;
            _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99.WorldSpacePosition = IN.WorldSpacePosition;
            float4 _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1;
            SG_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float(_Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2, _Property_5aaa24741fb4458496fadf63aabb26c7_Out_0, _Property_664012205b8b47e3bddf2b78909fbdb5_Out_0, _Property_ee43ff1e651e4766a9d7825b4a41563e_Out_0, _Property_d9bbf4f126844f9691d1b659f2618f60_Out_0, _Property_dcc5cca994d44486b344bbfaa27d94af_Out_0, _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99, _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1);
            surface.BaseColor = _Saturate_c4375e7e98c549c1adaed9e32ff3586a_Out_1;
            surface.Alpha = (_ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1).x;
            surface.SpriteMask = IsGammaSpace() ? float4(1, 1, 1, 1) : float4 (SRGBToLinear(float3(1, 1, 1)), 1);
            if(surface.Alpha<0.05)
            {
                discard;
            }
            
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
        
        
            output.WorldSpacePosition =                         input.positionWS;
            output.uv0 =                                        input.texCoord0;
            output.uv1 =                                        input.texCoord1;
            output.uv2 =                                        input.texCoord2;
            output.uv3 =                                        input.texCoord3;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteUnlitPass.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "Sprite Normal"
            Tags
            {
                "LightMode" = "NormalsRendering"
            }
        
            // Render State
            Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define ATTRIBUTES_NEED_TEXCOORD3
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD3
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SPRITENORMAL
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/NormalsRenderingShared.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 uv3 : TEXCOORD3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
             float4 texCoord3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 uv0;
             float4 uv1;
             float4 uv2;
             float4 uv3;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
             float4 interp5 : INTERP5;
             float4 interp6 : INTERP6;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.texCoord1;
            output.interp5.xyzw =  input.texCoord2;
            output.interp6.xyzw =  input.texCoord3;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.texCoord1 = input.interp4.xyzw;
            output.texCoord2 = input.interp5.xyzw;
            output.texCoord3 = input.interp6.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1_TexelSize;
        float4 _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1_TexelSize;
        float4 _SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1_TexelSize;
        float4 _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1_TexelSize;
        float4 _MainTex_TexelSize;
        float _shadowBaseAlpha;
        float _shadowReflectiveness;
        float _shadowNarrowing;
        float _shadowFalloff;
        float _shadowTexture;
        float4 _shadowTex_TexelSize;
        float _directional;
        float _fastAntyaliasing;
        float4 _edgeColor;
        float4 _RenderText_TexelSize;
        float3 _colorMlpRGB;
        float4 _shadowBaseColor;
        float _vonroiTex;
        float _afrigesTex;
        float _sceneLighten;
        float _falloff;
        float _fakeRefraction;
        float _enableBlur;
        float _blurStrength;
        float _blurArea;
        float4x4 _camProj;
        float4x4 _camWorldToCam;
        float2 _blurDir;
        float _onlyRenderIn2DLight;
        float _useClosestPointLightForDirection;
        float _2DLightMLP;
        float _2DLightMinAlpha;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Mirror);
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Point_Clamp);
        TEXTURE2D(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1);
        SAMPLER(sampler_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1);
        TEXTURE2D(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1);
        SAMPLER(sampler_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1);
        TEXTURE2D(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1);
        SAMPLER(sampler_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1);
        TEXTURE2D(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1);
        SAMPLER(sampler_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1);
        TEXTURE2D(_ShapeLightTexture0);
        SAMPLER(sampler_ShapeLightTexture0);
        float4 _ShapeLightTexture0_TexelSize;
        TEXTURE2D(_ShapeLightTexture1);
        SAMPLER(sampler_ShapeLightTexture1);
        float4 _ShapeLightTexture1_TexelSize;
        TEXTURE2D(_ShapeLightTexture2);
        SAMPLER(sampler_ShapeLightTexture2);
        float4 _ShapeLightTexture2_TexelSize;
        TEXTURE2D(_ShapeLightTexture3);
        SAMPLER(sampler_ShapeLightTexture3);
        float4 _ShapeLightTexture3_TexelSize;
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_shadowTex);
        SAMPLER(sampler_shadowTex);
        float2 _distMinMax;
        float3 _source;
        TEXTURE2D(_RenderText);
        SAMPLER(sampler_RenderText);
        float _minX;
        float _maxX;
        float _maxY;
        float _minY;
        float _fromSS;
        TEXTURE2D(_ModernShadowMask);
        SAMPLER(sampler_ModernShadowMask);
        float4 _ModernShadowMask_TexelSize;
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float4x4_float4x4(float4x4 A, float4x4 B, out float4x4 Out)
        {
        Out = mul(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
        {
        Out = mul(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        struct Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float
        {
        float3 WorldSpacePosition;
        };
        
        void SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(float4x4 _projectionMatrix, float4x4 _worldToCamMatrix, Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float IN, out float2 OutVector2_1)
        {
        float4x4 _Property_5e250b4a0f6742d492e1ffaa326ca712_Out_0 = _projectionMatrix;
        float4x4 _Property_b38ed1c9e33148539fa2aa331fad3e1e_Out_0 = _worldToCamMatrix;
        float4x4 _Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2;
        Unity_Multiply_float4x4_float4x4(_Property_5e250b4a0f6742d492e1ffaa326ca712_Out_0, _Property_b38ed1c9e33148539fa2aa331fad3e1e_Out_0, _Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2);
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_R_1 = IN.WorldSpacePosition[0];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_G_2 = IN.WorldSpacePosition[1];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_B_3 = IN.WorldSpacePosition[2];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_A_4 = 0;
        float4 _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4;
        float3 _Combine_b12c047fc90143598606bddcbbd3235c_RGB_5;
        float2 _Combine_b12c047fc90143598606bddcbbd3235c_RG_6;
        Unity_Combine_float(_Split_b28438aa8fd74da8879ec59ca390c4cb_R_1, _Split_b28438aa8fd74da8879ec59ca390c4cb_G_2, _Split_b28438aa8fd74da8879ec59ca390c4cb_B_3, 1, _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4, _Combine_b12c047fc90143598606bddcbbd3235c_RGB_5, _Combine_b12c047fc90143598606bddcbbd3235c_RG_6);
        float4 _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2;
        Unity_Multiply_float4x4_float4(_Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2, _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4, _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2);
        float _Split_eea358322a8b41d293cd1bbe8f795d83_R_1 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[0];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_G_2 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[1];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_B_3 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[2];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_A_4 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[3];
        float _Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2;
        Unity_Divide_float(_Split_eea358322a8b41d293cd1bbe8f795d83_R_1, _Split_eea358322a8b41d293cd1bbe8f795d83_A_4, _Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2);
        float _Add_8870e08ad8dc441aabe116e7732263ea_Out_2;
        Unity_Add_float(_Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2, 1, _Add_8870e08ad8dc441aabe116e7732263ea_Out_2);
        float _Multiply_990533093df5477c870cf76611148a17_Out_2;
        Unity_Multiply_float_float(_Add_8870e08ad8dc441aabe116e7732263ea_Out_2, 0.5, _Multiply_990533093df5477c870cf76611148a17_Out_2);
        float _Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2;
        Unity_Divide_float(_Split_eea358322a8b41d293cd1bbe8f795d83_G_2, _Split_eea358322a8b41d293cd1bbe8f795d83_A_4, _Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2);
        float _Add_5e3971a220d6404eab9366f74c9b69ea_Out_2;
        Unity_Add_float(_Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2, 1, _Add_5e3971a220d6404eab9366f74c9b69ea_Out_2);
        float _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2;
        Unity_Multiply_float_float(_Add_5e3971a220d6404eab9366f74c9b69ea_Out_2, 0.5, _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2);
        float2 _Vector2_061b57261ebb4976a044de3c8350d020_Out_0 = float2(_Multiply_990533093df5477c870cf76611148a17_Out_2, _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2);
        OutVector2_1 = _Vector2_061b57261ebb4976a044de3c8350d020_Out_0;
        }
        
        void Box_blur_float(UnityTexture2D tex, float2 UV, float2 texelS, float area, float strength, float2 dir, float2 pos, out float4 col){
        float4 o = 0;
        
        float sum = 0;
        
        float2 uvOffset;
        
        float weight = 1;
        
        
        float4 oc =  tex2D(tex,UV).xyzw;
        
        if(pos.x < 0.001 || pos.x > 0.999 || pos.y < 0.001 || pos.y > 0.999 ) col = tex2D(tex, UV);
        else{
        for(int x = - area / 2; x <= area / 2; ++x)
        
        {
        
        
        	for(int y = - area / 2; y <= area / 2; ++y)
        
        	{
        
        		uvOffset = UV;
        
        		uvOffset.x += dir.x *  ((x) *1/ texelS.x);
        
        		uvOffset.y +=dir.y *  ((y) * 1/texelS.y);
        
        		o += tex2Dlod(tex, float4(uvOffset.xy,1,1)) * weight;
        
        		sum += weight;
        
        	}
        
        
        }
        
        o *= (1.0f / sum);
        
        col = col  = lerp( oc , o , strength);
        }
        }
        
        struct Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float
        {
        };
        
        void SG_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float(UnityTexture2D _MainTex2, float2 _uv, float2 _texelS, float _area, float _sigmaX, float2 _dir, float2 _pos, Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float IN, out float4 col_1)
        {
        UnityTexture2D _Property_7b2e56d44efd4399bcf6bbbd21d74b66_Out_0 = _MainTex2;
        float2 _Property_b9ec06981d75414bba0afd20bdd9de9c_Out_0 = _uv;
        float2 _Property_56e4b5fb23744ef899acefff47f35e49_Out_0 = _texelS;
        float _Property_4271e8b1fb344e109adbcec48df8eac4_Out_0 = _area;
        float _Property_6c7096cbbb374fb2ad4280093f02c412_Out_0 = _sigmaX;
        float2 _Property_77ed7a1a234140cdb128ae9f188ef889_Out_0 = _dir;
        float2 _Property_9f9d5a72bffd4c8aaa578bd8b3a100a1_Out_0 = _pos;
        float4 _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4;
        Box_blur_float(_Property_7b2e56d44efd4399bcf6bbbd21d74b66_Out_0, _Property_b9ec06981d75414bba0afd20bdd9de9c_Out_0, _Property_56e4b5fb23744ef899acefff47f35e49_Out_0, _Property_4271e8b1fb344e109adbcec48df8eac4_Out_0, _Property_6c7096cbbb374fb2ad4280093f02c412_Out_0, _Property_77ed7a1a234140cdb128ae9f188ef889_Out_0, _Property_9f9d5a72bffd4c8aaa578bd8b3a100a1_Out_0, _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4);
        col_1 = _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float
        {
        };
        
        void SG_getSpriteUV_28898200da561d54c95498da7ec1387b_float(float _isFromSpriteSheet, float2 _uv, float _minX, float _maxX, float _minY, float _maxY, Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float IN, out float2 UV_1)
        {
        float _Property_59629b1305f34389b5ac2ae936e1d97a_Out_0 = _isFromSpriteSheet;
        float2 _Property_d386229f3dbd464c8b50826a8175c772_Out_0 = _uv;
        float _Split_aeed631f945444d188e965907d53f468_R_1 = _Property_d386229f3dbd464c8b50826a8175c772_Out_0[0];
        float _Split_aeed631f945444d188e965907d53f468_G_2 = _Property_d386229f3dbd464c8b50826a8175c772_Out_0[1];
        float _Split_aeed631f945444d188e965907d53f468_B_3 = 0;
        float _Split_aeed631f945444d188e965907d53f468_A_4 = 0;
        float _Property_3d13d310f40c4a38978749b541492e7e_Out_0 = _minX;
        float _Subtract_14c500329721426892410b2ffe30cc75_Out_2;
        Unity_Subtract_float(_Split_aeed631f945444d188e965907d53f468_R_1, _Property_3d13d310f40c4a38978749b541492e7e_Out_0, _Subtract_14c500329721426892410b2ffe30cc75_Out_2);
        float _Property_4b8021ce9c1f44d2b60bfff4c7d3c6d5_Out_0 = _maxX;
        float _Property_0c3a9984187940adb91e772580242719_Out_0 = _minX;
        float _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2;
        Unity_Subtract_float(_Property_4b8021ce9c1f44d2b60bfff4c7d3c6d5_Out_0, _Property_0c3a9984187940adb91e772580242719_Out_0, _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2);
        float _Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2;
        Unity_Divide_float(_Subtract_14c500329721426892410b2ffe30cc75_Out_2, _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2, _Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2);
        float _Property_fc2e7f28e6324e83ae0f9f10c53a4712_Out_0 = _minY;
        float _Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2;
        Unity_Subtract_float(_Split_aeed631f945444d188e965907d53f468_G_2, _Property_fc2e7f28e6324e83ae0f9f10c53a4712_Out_0, _Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2);
        float _Property_db14e0563c964d5db8b1c4b2265606be_Out_0 = _maxY;
        float _Property_f5f38a602035427790bc38042352fa9c_Out_0 = _minY;
        float _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2;
        Unity_Subtract_float(_Property_db14e0563c964d5db8b1c4b2265606be_Out_0, _Property_f5f38a602035427790bc38042352fa9c_Out_0, _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2);
        float _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2;
        Unity_Divide_float(_Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2, _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2, _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2);
        float4 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGBA_4;
        float3 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGB_5;
        float2 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6;
        Unity_Combine_float(_Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2, _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2, 0, 0, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGBA_4, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGB_5, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6);
        float2 _Property_b83213148b3746ada7e8c109a157d5eb_Out_0 = _uv;
        float2 _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3;
        Unity_Branch_float2(_Property_59629b1305f34389b5ac2ae936e1d97a_Out_0, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6, _Property_b83213148b3746ada7e8c109a157d5eb_Out_0, _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3);
        UV_1 = _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3;
        }
        
        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Saturate_float4(float4 In, out float4 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Blend_Overlay_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            float4 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float4 result2 = 2.0 * Base * Blend;
            float4 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Blend_Multiply_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Distance_float2(float2 A, float2 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_DDXY_4c15eab26cdc46fcb709d614ebea98aa_float(float In, out float Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING)
                    #error 'DDXY' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            Out = abs(ddx(In)) + abs(ddy(In));
        }
        
        void Unity_InverseLerp_float(float A, float B, float T, out float Out)
        {
            Out = (T - A)/(B - A);
        }
        
        struct Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float
        {
        half4 uv0;
        };
        
        void SG_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float(float _fastAntyaliasing, UnityTexture2D _MainTex, Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float IN, out float OutVector1_1)
        {
        float _Property_df7f9d1e6f3644bcbb0570916415aa00_Out_0 = _fastAntyaliasing;
        UnityTexture2D _Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0 = _MainTex;
        float4 _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0 = SAMPLE_TEXTURE2D(_Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Point_Clamp).samplerstate, _Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0.GetTransformedUV(IN.uv0.xy));
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_R_4 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.r;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_G_5 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.g;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_B_6 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.b;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.a;
        float _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1;
        Unity_DDXY_4c15eab26cdc46fcb709d614ebea98aa_float(_SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7, _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1);
        float _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2;
        Unity_Multiply_float_float(_Property_df7f9d1e6f3644bcbb0570916415aa00_Out_0, _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1, _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2);
        float _InverseLerp_394949f6e03a449798553a3a5429204a_Out_3;
        Unity_InverseLerp_float(1, 0, _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2, _InverseLerp_394949f6e03a449798553a3a5429204a_Out_3);
        float _Multiply_645ac89284924907975d95479e12d3a8_Out_2;
        Unity_Multiply_float_float(_InverseLerp_394949f6e03a449798553a3a5429204a_Out_3, _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7, _Multiply_645ac89284924907975d95479e12d3a8_Out_2);
        OutVector1_1 = _Multiply_645ac89284924907975d95479e12d3a8_Out_2;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Minimum_float(float A, float B, out float Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Blend_Multiply_float(float Base, float Blend, out float Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Maximum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void GetAlpha_float(float alphaBase, float light, float mlp, float minAlpha, out float4 res){
        res = min(1.0, max(minAlpha, alphaBase * (light/10) * mlp ));
        }
        
        struct Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float
        {
        float3 WorldSpacePosition;
        };
        
        void SG_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float(float _shadow_alpha, float _2DLightMLP, float _2DLightMinAlpha, float _onlyRenderIn2DLight, float4x4 _camProj, float4x4 _camWorldToCam, Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float IN, out float4 OutVector4_1)
        {
        float _Property_3e1a6e8cf6c7482ba86cf4139dd7c69e_Out_0 = _onlyRenderIn2DLight;
        float _Property_a24ed8de38314c7b91fc5501a78e320a_Out_0 = _shadow_alpha;
        float4x4 _Property_022e2f884d7542508c664e14f0ca6b89_Out_0 = _camProj;
        float4x4 _Property_ea154a1dce9248de95cc6ae98b5a49f4_Out_0 = _camWorldToCam;
        Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767;
        _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767.WorldSpacePosition = IN.WorldSpacePosition;
        float2 _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1;
        SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_022e2f884d7542508c664e14f0ca6b89_Out_0, _Property_ea154a1dce9248de95cc6ae98b5a49f4_Out_0, _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767, _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1);
        float4 _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_R_4 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.r;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_G_5 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.g;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_B_6 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.b;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_A_7 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.a;
        float4 _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_R_4 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.r;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_G_5 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.g;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_B_6 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.b;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_A_7 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.a;
        float4 _Maximum_600d428159ef4ae19733009631d8183e_Out_2;
        Unity_Maximum_float4(_SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0, _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0, _Maximum_600d428159ef4ae19733009631d8183e_Out_2);
        float4 _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_R_4 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.r;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_G_5 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.g;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_B_6 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.b;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_A_7 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.a;
        float4 _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_R_4 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.r;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_G_5 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.g;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_B_6 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.b;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_A_7 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.a;
        float4 _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2;
        Unity_Maximum_float4(_SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0, _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0, _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2);
        float4 _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2;
        Unity_Maximum_float4(_Maximum_600d428159ef4ae19733009631d8183e_Out_2, _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2, _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2);
        float _Split_079a7389553a46f6b2e083de5ab0ec35_R_1 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[0];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_G_2 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[1];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_B_3 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[2];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_A_4 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[3];
        float _Maximum_459027f3b3df4840b45351867af70ed1_Out_2;
        Unity_Maximum_float(_Split_079a7389553a46f6b2e083de5ab0ec35_B_3, _Split_079a7389553a46f6b2e083de5ab0ec35_G_2, _Maximum_459027f3b3df4840b45351867af70ed1_Out_2);
        float _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2;
        Unity_Maximum_float(_Maximum_459027f3b3df4840b45351867af70ed1_Out_2, _Split_079a7389553a46f6b2e083de5ab0ec35_R_1, _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2);
        float _Property_111bb76eab7a41619d344262fafa3895_Out_0 = _2DLightMLP;
        float _Property_070598259d31416e98256505bbb2b2de_Out_0 = _2DLightMinAlpha;
        float4 _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0;
        GetAlpha_float(_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0, _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2, _Property_111bb76eab7a41619d344262fafa3895_Out_0, _Property_070598259d31416e98256505bbb2b2de_Out_0, _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0);
        float4 _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2;
        Unity_Multiply_float4_float4((_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0.xxxx), _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0, _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2);
        float4 _Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3;
        Unity_Branch_float4(_Property_3e1a6e8cf6c7482ba86cf4139dd7c69e_Out_0, _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2, (_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0.xxxx), _Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3);
        float4 _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1;
        Unity_Saturate_float4(_Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3, _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1);
        OutVector4_1 = _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreSurface' */
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float3 NormalTS;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_39a0c80a760d442e92412ca9c31ccaf5_Out_0 = _shadowBaseAlpha;
            float _Property_65c6a4cc5d374f13b91cd81a27486ba3_Out_0 = _shadowTexture;
            UnityTexture2D _Property_266f14f34a3c468e99c82838d2327dc3_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_ae79c0121c0442198ad8a19481d850c8_Out_0 = IN.uv0;
            float _TexelSize_86396267145246039524276a2683b94d_Width_0 = _Property_266f14f34a3c468e99c82838d2327dc3_Out_0.texelSize.z;
            float _TexelSize_86396267145246039524276a2683b94d_Height_2 = _Property_266f14f34a3c468e99c82838d2327dc3_Out_0.texelSize.w;
            float2 _Vector2_adbf5eb295764b359c895d572e0af102_Out_0 = float2(_TexelSize_86396267145246039524276a2683b94d_Width_0, _TexelSize_86396267145246039524276a2683b94d_Height_2);
            float _Property_1a28fa3b35dd4e1193848f9373679a25_Out_0 = _blurArea;
            float _Property_840bd827292044b297da6b2206472467_Out_0 = _blurStrength;
            float2 _Property_747cea1fc384479a8ebbb6c75f25a52b_Out_0 = _blurDir;
            float4x4 _Property_e97cf15c65fe40818e58b226aa758447_Out_0 = _camProj;
            float4x4 _Property_52c5f0665044443c9ea9e1b36de2aa09_Out_0 = _camWorldToCam;
            Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075;
            _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075.WorldSpacePosition = IN.WorldSpacePosition;
            float2 _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1;
            SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_e97cf15c65fe40818e58b226aa758447_Out_0, _Property_52c5f0665044443c9ea9e1b36de2aa09_Out_0, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1);
            Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float _BoxBlur_146e8bef57604c11860c784ef32014b2;
            float4 _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1;
            SG_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float(_Property_266f14f34a3c468e99c82838d2327dc3_Out_0, (_UV_ae79c0121c0442198ad8a19481d850c8_Out_0.xy), _Vector2_adbf5eb295764b359c895d572e0af102_Out_0, _Property_1a28fa3b35dd4e1193848f9373679a25_Out_0, _Property_840bd827292044b297da6b2206472467_Out_0, _Property_747cea1fc384479a8ebbb6c75f25a52b_Out_0, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1, _BoxBlur_146e8bef57604c11860c784ef32014b2, _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1);
            float _Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1 = _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1.w;
            UnityTexture2D _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0 = UnityBuildTexture2DStructNoScale(_shadowTex);
            float4 _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.tex, _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.samplerstate, _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_R_4 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.r;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_G_5 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.g;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_B_6 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.b;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_A_7 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.a;
            float4 _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2;
            Unity_Multiply_float4_float4((_Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1.xxxx), _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0, _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2);
            float4 _Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3;
            Unity_Branch_float4(_Property_65c6a4cc5d374f13b91cd81a27486ba3_Out_0, _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2, (_Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1.xxxx), _Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3);
            float _Property_269f6df3fbd447efaeeb85f3a462424a_Out_0 = _falloff;
            float _Property_02de571028bb4a16975e641e43976cd2_Out_0 = _fromSS;
            float4 _UV_db00e0a911d64679b4c6580b6b1418df_Out_0 = IN.uv0;
            float _Property_24bc71ec982a439ca0ddc1247924bbe0_Out_0 = _minX;
            float _Property_24635cb30088450b914780cf23c64e07_Out_0 = _maxX;
            float _Property_517af63683904c6aafb247552ff3a011_Out_0 = _minY;
            float _Property_9fc5fb11323f4477912a01e1f9c6ab76_Out_0 = _maxY;
            Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1;
            float2 _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1;
            SG_getSpriteUV_28898200da561d54c95498da7ec1387b_float(_Property_02de571028bb4a16975e641e43976cd2_Out_0, (_UV_db00e0a911d64679b4c6580b6b1418df_Out_0.xy), _Property_24bc71ec982a439ca0ddc1247924bbe0_Out_0, _Property_24635cb30088450b914780cf23c64e07_Out_0, _Property_517af63683904c6aafb247552ff3a011_Out_0, _Property_9fc5fb11323f4477912a01e1f9c6ab76_Out_0, _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1, _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1);
            float _Property_38c07cfd50364af59198ace5a1218e1c_Out_0 = _shadowNarrowing;
            float2 _Vector2_30d73056b259424a903bb0260189385c_Out_0 = float2(0.5, _Property_38c07cfd50364af59198ace5a1218e1c_Out_0);
            float2 _Rotate_354f1e875f8142599da0f89a879950cf_Out_3;
            Unity_Rotate_Degrees_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, _Vector2_30d73056b259424a903bb0260189385c_Out_0, 180, _Rotate_354f1e875f8142599da0f89a879950cf_Out_3);
            float4 _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).GetTransformedUV(_Rotate_354f1e875f8142599da0f89a879950cf_Out_3));
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_R_4 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.r;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_G_5 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.g;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_B_6 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.b;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_A_7 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.a;
            float4 _Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2;
            Unity_Divide_float4(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0, float4(1, 1, 1, 1), _Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2);
            float2 _TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3;
            Unity_TilingAndOffset_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, float2 (1, 1), float2 (0, 0), _TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3);
            float _Property_3de54516355e446b941821236b3a5539_Out_0 = _shadowNarrowing;
            float2 _Vector2_5490d5e7275944b2a1d3e15aa999783d_Out_0 = float2(0.5, _Property_3de54516355e446b941821236b3a5539_Out_0);
            float2 _Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3, _Vector2_5490d5e7275944b2a1d3e15aa999783d_Out_0, 90, _Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3);
            float4 _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).GetTransformedUV(_Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3));
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_R_4 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.r;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_G_5 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.g;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_B_6 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.b;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_A_7 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.a;
            float2 _TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3;
            Unity_TilingAndOffset_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, float2 (1, 1), float2 (0, 0), _TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3);
            float _Property_053ef645b525429eb8514144a5f0d8a5_Out_0 = _shadowNarrowing;
            float2 _Vector2_9e0a92a790e6479782cb7f44e5e39a96_Out_0 = float2(0.5, _Property_053ef645b525429eb8514144a5f0d8a5_Out_0);
            float2 _Rotate_937724de82cd4b709bafc850c9efdd35_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3, _Vector2_9e0a92a790e6479782cb7f44e5e39a96_Out_0, -90, _Rotate_937724de82cd4b709bafc850c9efdd35_Out_3);
            float4 _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).GetTransformedUV(_Rotate_937724de82cd4b709bafc850c9efdd35_Out_3));
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_R_4 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.r;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_G_5 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.g;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_B_6 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.b;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_A_7 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.a;
            float4 _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0, _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0, _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2);
            float4 _Multiply_4274a6a328994084b1b182cd09384636_Out_2;
            Unity_Multiply_float4_float4(_Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2, _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2, _Multiply_4274a6a328994084b1b182cd09384636_Out_2);
            float _Property_8846c22cbd2548d79b405c31433a0bf6_Out_0 = _shadowFalloff;
            float4 _Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2;
            Unity_Multiply_float4_float4(_Multiply_4274a6a328994084b1b182cd09384636_Out_2, (_Property_8846c22cbd2548d79b405c31433a0bf6_Out_0.xxxx), _Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2);
            float4 _Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1;
            Unity_Saturate_float4(_Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2, _Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1);
            float4 _Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2;
            Unity_Multiply_float4_float4(_Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1, float4(2, 2, 2, 2), _Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2);
            float _Property_8f9cd0c877224528832afbf49c0eca9c_Out_0 = _afrigesTex;
            float _Property_d3b4849aa43442b9b501c852f80974ee_Out_0 = _shadowBaseAlpha;
            float2 _TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.3, 0.3), (IN.WorldSpacePosition.xy), _TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3);
            float2 _Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3, float2 (0.5, 0.5), 0, _Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3);
            float4 _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1).tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Mirror).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1).GetTransformedUV(_Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3));
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_R_4 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.r;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_G_5 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.g;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_B_6 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.b;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_A_7 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.a;
            float _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2;
            Unity_Multiply_float_float(_Property_d3b4849aa43442b9b501c852f80974ee_Out_0, _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_R_4, _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2);
            float _Branch_15f412beaf5e46b19f8226a5db075124_Out_3;
            Unity_Branch_float(_Property_8f9cd0c877224528832afbf49c0eca9c_Out_0, _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2, 1, _Branch_15f412beaf5e46b19f8226a5db075124_Out_3);
            float4 _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2;
            Unity_Multiply_float4_float4(_Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2, (_Branch_15f412beaf5e46b19f8226a5db075124_Out_3.xxxx), _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2);
            float4 _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2;
            Unity_Blend_Overlay_float4(_Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2, _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2, _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2, 0.2);
            float4 _Branch_66a6d2861e6d4f6089053a6772d86451_Out_3;
            Unity_Branch_float4(_Property_269f6df3fbd447efaeeb85f3a462424a_Out_0, _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2, float4(1, 1, 1, 1), _Branch_66a6d2861e6d4f6089053a6772d86451_Out_3);
            float _Property_045f4a7a2af440bd8b474a9a895a430c_Out_0 = _vonroiTex;
            float _Property_c04500d7725947a69a1cf465b73beaf6_Out_0 = _shadowBaseAlpha;
            float2 _TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.3, 0.3), (IN.WorldSpacePosition.xy), _TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3);
            float _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3;
            float _Voronoi_5185d06e2788480f9f5edfeac380e38e_Cells_4;
            Unity_Voronoi_float(_TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3, 2, 1, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Cells_4);
            float _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3;
            Unity_Smoothstep_float(0.3, 1, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3, _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3);
            float _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3;
            Unity_Smoothstep_float(0, 0.5, _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3, _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3);
            float _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2;
            Unity_Multiply_float_float(_Property_c04500d7725947a69a1cf465b73beaf6_Out_0, _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3, _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2);
            float _Branch_a08b046aadf043aa821d5d9e70298163_Out_3;
            Unity_Branch_float(_Property_045f4a7a2af440bd8b474a9a895a430c_Out_0, _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2, 1, _Branch_a08b046aadf043aa821d5d9e70298163_Out_3);
            float4 _Blend_16b43719a5d34dac880346881fe9f272_Out_2;
            Unity_Blend_Multiply_float4(_Branch_66a6d2861e6d4f6089053a6772d86451_Out_3, (_Branch_a08b046aadf043aa821d5d9e70298163_Out_3.xxxx), _Blend_16b43719a5d34dac880346881fe9f272_Out_2, 0.1);
            float4 _Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2;
            Unity_Multiply_float4_float4(_Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3, _Blend_16b43719a5d34dac880346881fe9f272_Out_2, _Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2);
            float _Property_1bc6b0136e3442f2bd0c835a17615a34_Out_0 = _directional;
            float _Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2;
            Unity_Comparison_Greater_float(_Property_1bc6b0136e3442f2bd0c835a17615a34_Out_0, 0.5, _Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2);
            float _Property_32038686d7c6415ba0e518addc902f38_Out_0 = _useClosestPointLightForDirection;
            float _Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2;
            Unity_Or_float(_Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2, _Property_32038686d7c6415ba0e518addc902f38_Out_0, _Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2);
            float2 _Swizzle_9179ff07d7164d409a2342edc50e4390_Out_1 = IN.WorldSpacePosition.xy;
            float3 _Property_414892493f164994ba130276c6cb2dc6_Out_0 = _source;
            float2 _Swizzle_aa67dcd65c5e4b98acb2bb10a34ef37d_Out_1 = _Property_414892493f164994ba130276c6cb2dc6_Out_0.xy;
            float _Distance_82ab97a70bec43dfab653173af856737_Out_2;
            Unity_Distance_float2(_Swizzle_9179ff07d7164d409a2342edc50e4390_Out_1, _Swizzle_aa67dcd65c5e4b98acb2bb10a34ef37d_Out_1, _Distance_82ab97a70bec43dfab653173af856737_Out_2);
            float2 _Property_9b36c1d04153475d95525b4c285bc80b_Out_0 = _distMinMax;
            float _Split_88cecf19cf4d4c149324206c388fe6cb_R_1 = _Property_9b36c1d04153475d95525b4c285bc80b_Out_0[0];
            float _Split_88cecf19cf4d4c149324206c388fe6cb_G_2 = _Property_9b36c1d04153475d95525b4c285bc80b_Out_0[1];
            float _Split_88cecf19cf4d4c149324206c388fe6cb_B_3 = 0;
            float _Split_88cecf19cf4d4c149324206c388fe6cb_A_4 = 0;
            float _Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3;
            Unity_Clamp_float(_Distance_82ab97a70bec43dfab653173af856737_Out_2, 0, _Split_88cecf19cf4d4c149324206c388fe6cb_G_2, _Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3);
            float2 _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0 = _distMinMax;
            float _Split_715f243a60c9433990660b04d84633e2_R_1 = _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0[0];
            float _Split_715f243a60c9433990660b04d84633e2_G_2 = _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0[1];
            float _Split_715f243a60c9433990660b04d84633e2_B_3 = 0;
            float _Split_715f243a60c9433990660b04d84633e2_A_4 = 0;
            float _Divide_b4f326bea5de462a992c509de3e5e831_Out_2;
            Unity_Divide_float(_Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3, _Split_715f243a60c9433990660b04d84633e2_G_2, _Divide_b4f326bea5de462a992c509de3e5e831_Out_2);
            float _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3;
            Unity_Lerp_float(0, 1, _Divide_b4f326bea5de462a992c509de3e5e831_Out_2, _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3);
            float _Branch_17569a76eab4481eb16fbe1782242f1d_Out_3;
            Unity_Branch_float(_Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2, 1, _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3, _Branch_17569a76eab4481eb16fbe1782242f1d_Out_3);
            float4 _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2;
            Unity_Blend_Multiply_float4(_Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2, (_Branch_17569a76eab4481eb16fbe1782242f1d_Out_3.xxxx), _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2, 1);
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_R_1 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[0];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_G_2 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[1];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_B_3 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[2];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_A_4 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[3];
            float _Property_a440c1c925654a4eb8f15fca48f5aa3d_Out_0 = _fastAntyaliasing;
            UnityTexture2D _Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a;
            _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a.uv0 = IN.uv0;
            float _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1;
            SG_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float(_Property_a440c1c925654a4eb8f15fca48f5aa3d_Out_0, _Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1);
            float _Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2;
            Unity_Multiply_float_float(_Split_e085e2b7b0b9447cb31c3bedff43d4fa_R_1, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1, _Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2);
            float _Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0 = _sceneLighten;
            float3 _Property_a979b50a4dd341529f45439596b6ff98_Out_0 = _colorMlpRGB;
            float _Split_bd2a7871af334e818a970f83ab0fdce8_R_1 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[0];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_G_2 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[1];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_B_3 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[2];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_A_4 = 0;
            UnityTexture2D _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0 = UnityBuildTexture2DStructNoScale(_RenderText);
            float4x4 _Property_668393ac9856480ba5e4de219cd36c78_Out_0 = _camProj;
            float4x4 _Property_e0169419f075483c9fa9548fe401a2fe_Out_0 = _camWorldToCam;
            Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd;
            _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd.WorldSpacePosition = IN.WorldSpacePosition;
            float2 _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1;
            SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_668393ac9856480ba5e4de219cd36c78_Out_0, _Property_e0169419f075483c9fa9548fe401a2fe_Out_0, _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd, _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1);
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.tex, _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.samplerstate, _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.GetTransformedUV(_CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1), 1);
            #endif
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_R_5 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.r;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_G_6 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.g;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_B_7 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.b;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_A_8 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.a;
            float _Remap_fef0fe01a3a44d209390feb636d87117_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_R_5, float2 (0, 1), float2 (0, 2), _Remap_fef0fe01a3a44d209390feb636d87117_Out_3);
            float _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1;
            Unity_OneMinus_float(_Remap_fef0fe01a3a44d209390feb636d87117_Out_3, _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1);
            float _Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_R_1, _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1, _Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2);
            float _Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_G_6, float2 (0, 1), float2 (0, 2), _Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3);
            float _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1;
            Unity_OneMinus_float(_Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3, _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1);
            float _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_G_2, _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1, _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2);
            float _Minimum_881608b72fe747f49bb49799d4218a36_Out_2;
            Unity_Minimum_float(_Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2, _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2, _Minimum_881608b72fe747f49bb49799d4218a36_Out_2);
            float _Remap_c579a88bcefd49558c8688613e80f533_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_B_7, float2 (0, 1), float2 (0, 2), _Remap_c579a88bcefd49558c8688613e80f533_Out_3);
            float _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1;
            Unity_OneMinus_float(_Remap_c579a88bcefd49558c8688613e80f533_Out_3, _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1);
            float _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_B_3, _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1, _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2);
            float _Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2;
            Unity_Minimum_float(_Minimum_881608b72fe747f49bb49799d4218a36_Out_2, _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2, _Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2);
            float _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1;
            Unity_Saturate_float(_Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2, _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1);
            float _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3;
            Unity_Branch_float(_Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0, _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1, 0, _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3);
            float _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3;
            Unity_Branch_float(_Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0, 0.9, 0, _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3);
            float _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2;
            Unity_Blend_Multiply_float(_Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2, _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3, _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2, _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3);
            float _Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2;
            Unity_Multiply_float_float(_Property_39a0c80a760d442e92412ca9c31ccaf5_Out_0, _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2, _Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2);
            float _Property_5aaa24741fb4458496fadf63aabb26c7_Out_0 = _2DLightMLP;
            float _Property_664012205b8b47e3bddf2b78909fbdb5_Out_0 = _2DLightMinAlpha;
            float _Property_ee43ff1e651e4766a9d7825b4a41563e_Out_0 = _onlyRenderIn2DLight;
            float4x4 _Property_d9bbf4f126844f9691d1b659f2618f60_Out_0 = _camProj;
            float4x4 _Property_dcc5cca994d44486b344bbfaa27d94af_Out_0 = _camWorldToCam;
            Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99;
            _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99.WorldSpacePosition = IN.WorldSpacePosition;
            float4 _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1;
            SG_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float(_Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2, _Property_5aaa24741fb4458496fadf63aabb26c7_Out_0, _Property_664012205b8b47e3bddf2b78909fbdb5_Out_0, _Property_ee43ff1e651e4766a9d7825b4a41563e_Out_0, _Property_d9bbf4f126844f9691d1b659f2618f60_Out_0, _Property_dcc5cca994d44486b344bbfaa27d94af_Out_0, _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99, _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1);
            surface.Alpha = (_ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1).x;
            surface.NormalTS = IN.TangentSpaceNormal;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
            output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition =                         input.positionWS;
            output.uv0 =                                        input.texCoord0;
            output.uv1 =                                        input.texCoord1;
            output.uv2 =                                        input.texCoord2;
            output.uv3 =                                        input.texCoord3;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteNormalPass.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
            // Render State
            Cull Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define ATTRIBUTES_NEED_TEXCOORD3
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD3
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 uv3 : TEXCOORD3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
             float4 texCoord3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 uv0;
             float4 uv1;
             float4 uv2;
             float4 uv3;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.texCoord1;
            output.interp3.xyzw =  input.texCoord2;
            output.interp4.xyzw =  input.texCoord3;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.texCoord1 = input.interp2.xyzw;
            output.texCoord2 = input.interp3.xyzw;
            output.texCoord3 = input.interp4.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1_TexelSize;
        float4 _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1_TexelSize;
        float4 _SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1_TexelSize;
        float4 _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1_TexelSize;
        float4 _MainTex_TexelSize;
        float _shadowBaseAlpha;
        float _shadowReflectiveness;
        float _shadowNarrowing;
        float _shadowFalloff;
        float _shadowTexture;
        float4 _shadowTex_TexelSize;
        float _directional;
        float _fastAntyaliasing;
        float4 _edgeColor;
        float4 _RenderText_TexelSize;
        float3 _colorMlpRGB;
        float4 _shadowBaseColor;
        float _vonroiTex;
        float _afrigesTex;
        float _sceneLighten;
        float _falloff;
        float _fakeRefraction;
        float _enableBlur;
        float _blurStrength;
        float _blurArea;
        float4x4 _camProj;
        float4x4 _camWorldToCam;
        float2 _blurDir;
        float _onlyRenderIn2DLight;
        float _useClosestPointLightForDirection;
        float _2DLightMLP;
        float _2DLightMinAlpha;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Mirror);
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Point_Clamp);
        TEXTURE2D(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1);
        SAMPLER(sampler_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1);
        TEXTURE2D(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1);
        SAMPLER(sampler_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1);
        TEXTURE2D(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1);
        SAMPLER(sampler_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1);
        TEXTURE2D(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1);
        SAMPLER(sampler_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1);
        TEXTURE2D(_ShapeLightTexture0);
        SAMPLER(sampler_ShapeLightTexture0);
        float4 _ShapeLightTexture0_TexelSize;
        TEXTURE2D(_ShapeLightTexture1);
        SAMPLER(sampler_ShapeLightTexture1);
        float4 _ShapeLightTexture1_TexelSize;
        TEXTURE2D(_ShapeLightTexture2);
        SAMPLER(sampler_ShapeLightTexture2);
        float4 _ShapeLightTexture2_TexelSize;
        TEXTURE2D(_ShapeLightTexture3);
        SAMPLER(sampler_ShapeLightTexture3);
        float4 _ShapeLightTexture3_TexelSize;
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_shadowTex);
        SAMPLER(sampler_shadowTex);
        float2 _distMinMax;
        float3 _source;
        TEXTURE2D(_RenderText);
        SAMPLER(sampler_RenderText);
        float _minX;
        float _maxX;
        float _maxY;
        float _minY;
        float _fromSS;
        TEXTURE2D(_ModernShadowMask);
        SAMPLER(sampler_ModernShadowMask);
        float4 _ModernShadowMask_TexelSize;
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float4x4_float4x4(float4x4 A, float4x4 B, out float4x4 Out)
        {
        Out = mul(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
        {
        Out = mul(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        struct Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float
        {
        float3 WorldSpacePosition;
        };
        
        void SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(float4x4 _projectionMatrix, float4x4 _worldToCamMatrix, Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float IN, out float2 OutVector2_1)
        {
        float4x4 _Property_5e250b4a0f6742d492e1ffaa326ca712_Out_0 = _projectionMatrix;
        float4x4 _Property_b38ed1c9e33148539fa2aa331fad3e1e_Out_0 = _worldToCamMatrix;
        float4x4 _Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2;
        Unity_Multiply_float4x4_float4x4(_Property_5e250b4a0f6742d492e1ffaa326ca712_Out_0, _Property_b38ed1c9e33148539fa2aa331fad3e1e_Out_0, _Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2);
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_R_1 = IN.WorldSpacePosition[0];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_G_2 = IN.WorldSpacePosition[1];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_B_3 = IN.WorldSpacePosition[2];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_A_4 = 0;
        float4 _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4;
        float3 _Combine_b12c047fc90143598606bddcbbd3235c_RGB_5;
        float2 _Combine_b12c047fc90143598606bddcbbd3235c_RG_6;
        Unity_Combine_float(_Split_b28438aa8fd74da8879ec59ca390c4cb_R_1, _Split_b28438aa8fd74da8879ec59ca390c4cb_G_2, _Split_b28438aa8fd74da8879ec59ca390c4cb_B_3, 1, _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4, _Combine_b12c047fc90143598606bddcbbd3235c_RGB_5, _Combine_b12c047fc90143598606bddcbbd3235c_RG_6);
        float4 _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2;
        Unity_Multiply_float4x4_float4(_Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2, _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4, _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2);
        float _Split_eea358322a8b41d293cd1bbe8f795d83_R_1 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[0];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_G_2 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[1];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_B_3 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[2];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_A_4 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[3];
        float _Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2;
        Unity_Divide_float(_Split_eea358322a8b41d293cd1bbe8f795d83_R_1, _Split_eea358322a8b41d293cd1bbe8f795d83_A_4, _Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2);
        float _Add_8870e08ad8dc441aabe116e7732263ea_Out_2;
        Unity_Add_float(_Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2, 1, _Add_8870e08ad8dc441aabe116e7732263ea_Out_2);
        float _Multiply_990533093df5477c870cf76611148a17_Out_2;
        Unity_Multiply_float_float(_Add_8870e08ad8dc441aabe116e7732263ea_Out_2, 0.5, _Multiply_990533093df5477c870cf76611148a17_Out_2);
        float _Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2;
        Unity_Divide_float(_Split_eea358322a8b41d293cd1bbe8f795d83_G_2, _Split_eea358322a8b41d293cd1bbe8f795d83_A_4, _Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2);
        float _Add_5e3971a220d6404eab9366f74c9b69ea_Out_2;
        Unity_Add_float(_Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2, 1, _Add_5e3971a220d6404eab9366f74c9b69ea_Out_2);
        float _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2;
        Unity_Multiply_float_float(_Add_5e3971a220d6404eab9366f74c9b69ea_Out_2, 0.5, _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2);
        float2 _Vector2_061b57261ebb4976a044de3c8350d020_Out_0 = float2(_Multiply_990533093df5477c870cf76611148a17_Out_2, _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2);
        OutVector2_1 = _Vector2_061b57261ebb4976a044de3c8350d020_Out_0;
        }
        
        void Box_blur_float(UnityTexture2D tex, float2 UV, float2 texelS, float area, float strength, float2 dir, float2 pos, out float4 col){
        float4 o = 0;
        
        float sum = 0;
        
        float2 uvOffset;
        
        float weight = 1;
        
        
        float4 oc =  tex2D(tex,UV).xyzw;
        
        if(pos.x < 0.001 || pos.x > 0.999 || pos.y < 0.001 || pos.y > 0.999 ) col = tex2D(tex, UV);
        else{
        for(int x = - area / 2; x <= area / 2; ++x)
        
        {
        
        
        	for(int y = - area / 2; y <= area / 2; ++y)
        
        	{
        
        		uvOffset = UV;
        
        		uvOffset.x += dir.x *  ((x) *1/ texelS.x);
        
        		uvOffset.y +=dir.y *  ((y) * 1/texelS.y);
        
        		o += tex2Dlod(tex, float4(uvOffset.xy,1,1)) * weight;
        
        		sum += weight;
        
        	}
        
        
        }
        
        o *= (1.0f / sum);
        
        col = col  = lerp( oc , o , strength);
        }
        }
        
        struct Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float
        {
        };
        
        void SG_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float(UnityTexture2D _MainTex2, float2 _uv, float2 _texelS, float _area, float _sigmaX, float2 _dir, float2 _pos, Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float IN, out float4 col_1)
        {
        UnityTexture2D _Property_7b2e56d44efd4399bcf6bbbd21d74b66_Out_0 = _MainTex2;
        float2 _Property_b9ec06981d75414bba0afd20bdd9de9c_Out_0 = _uv;
        float2 _Property_56e4b5fb23744ef899acefff47f35e49_Out_0 = _texelS;
        float _Property_4271e8b1fb344e109adbcec48df8eac4_Out_0 = _area;
        float _Property_6c7096cbbb374fb2ad4280093f02c412_Out_0 = _sigmaX;
        float2 _Property_77ed7a1a234140cdb128ae9f188ef889_Out_0 = _dir;
        float2 _Property_9f9d5a72bffd4c8aaa578bd8b3a100a1_Out_0 = _pos;
        float4 _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4;
        Box_blur_float(_Property_7b2e56d44efd4399bcf6bbbd21d74b66_Out_0, _Property_b9ec06981d75414bba0afd20bdd9de9c_Out_0, _Property_56e4b5fb23744ef899acefff47f35e49_Out_0, _Property_4271e8b1fb344e109adbcec48df8eac4_Out_0, _Property_6c7096cbbb374fb2ad4280093f02c412_Out_0, _Property_77ed7a1a234140cdb128ae9f188ef889_Out_0, _Property_9f9d5a72bffd4c8aaa578bd8b3a100a1_Out_0, _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4);
        col_1 = _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float
        {
        };
        
        void SG_getSpriteUV_28898200da561d54c95498da7ec1387b_float(float _isFromSpriteSheet, float2 _uv, float _minX, float _maxX, float _minY, float _maxY, Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float IN, out float2 UV_1)
        {
        float _Property_59629b1305f34389b5ac2ae936e1d97a_Out_0 = _isFromSpriteSheet;
        float2 _Property_d386229f3dbd464c8b50826a8175c772_Out_0 = _uv;
        float _Split_aeed631f945444d188e965907d53f468_R_1 = _Property_d386229f3dbd464c8b50826a8175c772_Out_0[0];
        float _Split_aeed631f945444d188e965907d53f468_G_2 = _Property_d386229f3dbd464c8b50826a8175c772_Out_0[1];
        float _Split_aeed631f945444d188e965907d53f468_B_3 = 0;
        float _Split_aeed631f945444d188e965907d53f468_A_4 = 0;
        float _Property_3d13d310f40c4a38978749b541492e7e_Out_0 = _minX;
        float _Subtract_14c500329721426892410b2ffe30cc75_Out_2;
        Unity_Subtract_float(_Split_aeed631f945444d188e965907d53f468_R_1, _Property_3d13d310f40c4a38978749b541492e7e_Out_0, _Subtract_14c500329721426892410b2ffe30cc75_Out_2);
        float _Property_4b8021ce9c1f44d2b60bfff4c7d3c6d5_Out_0 = _maxX;
        float _Property_0c3a9984187940adb91e772580242719_Out_0 = _minX;
        float _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2;
        Unity_Subtract_float(_Property_4b8021ce9c1f44d2b60bfff4c7d3c6d5_Out_0, _Property_0c3a9984187940adb91e772580242719_Out_0, _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2);
        float _Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2;
        Unity_Divide_float(_Subtract_14c500329721426892410b2ffe30cc75_Out_2, _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2, _Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2);
        float _Property_fc2e7f28e6324e83ae0f9f10c53a4712_Out_0 = _minY;
        float _Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2;
        Unity_Subtract_float(_Split_aeed631f945444d188e965907d53f468_G_2, _Property_fc2e7f28e6324e83ae0f9f10c53a4712_Out_0, _Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2);
        float _Property_db14e0563c964d5db8b1c4b2265606be_Out_0 = _maxY;
        float _Property_f5f38a602035427790bc38042352fa9c_Out_0 = _minY;
        float _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2;
        Unity_Subtract_float(_Property_db14e0563c964d5db8b1c4b2265606be_Out_0, _Property_f5f38a602035427790bc38042352fa9c_Out_0, _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2);
        float _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2;
        Unity_Divide_float(_Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2, _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2, _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2);
        float4 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGBA_4;
        float3 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGB_5;
        float2 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6;
        Unity_Combine_float(_Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2, _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2, 0, 0, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGBA_4, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGB_5, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6);
        float2 _Property_b83213148b3746ada7e8c109a157d5eb_Out_0 = _uv;
        float2 _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3;
        Unity_Branch_float2(_Property_59629b1305f34389b5ac2ae936e1d97a_Out_0, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6, _Property_b83213148b3746ada7e8c109a157d5eb_Out_0, _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3);
        UV_1 = _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3;
        }
        
        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Saturate_float4(float4 In, out float4 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Blend_Overlay_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            float4 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float4 result2 = 2.0 * Base * Blend;
            float4 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Blend_Multiply_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Distance_float2(float2 A, float2 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_DDXY_4c15eab26cdc46fcb709d614ebea98aa_float(float In, out float Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING)
                    #error 'DDXY' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            Out = abs(ddx(In)) + abs(ddy(In));
        }
        
        void Unity_InverseLerp_float(float A, float B, float T, out float Out)
        {
            Out = (T - A)/(B - A);
        }
        
        struct Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float
        {
        half4 uv0;
        };
        
        void SG_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float(float _fastAntyaliasing, UnityTexture2D _MainTex, Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float IN, out float OutVector1_1)
        {
        float _Property_df7f9d1e6f3644bcbb0570916415aa00_Out_0 = _fastAntyaliasing;
        UnityTexture2D _Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0 = _MainTex;
        float4 _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0 = SAMPLE_TEXTURE2D(_Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Point_Clamp).samplerstate, _Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0.GetTransformedUV(IN.uv0.xy));
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_R_4 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.r;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_G_5 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.g;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_B_6 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.b;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.a;
        float _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1;
        Unity_DDXY_4c15eab26cdc46fcb709d614ebea98aa_float(_SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7, _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1);
        float _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2;
        Unity_Multiply_float_float(_Property_df7f9d1e6f3644bcbb0570916415aa00_Out_0, _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1, _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2);
        float _InverseLerp_394949f6e03a449798553a3a5429204a_Out_3;
        Unity_InverseLerp_float(1, 0, _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2, _InverseLerp_394949f6e03a449798553a3a5429204a_Out_3);
        float _Multiply_645ac89284924907975d95479e12d3a8_Out_2;
        Unity_Multiply_float_float(_InverseLerp_394949f6e03a449798553a3a5429204a_Out_3, _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7, _Multiply_645ac89284924907975d95479e12d3a8_Out_2);
        OutVector1_1 = _Multiply_645ac89284924907975d95479e12d3a8_Out_2;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Minimum_float(float A, float B, out float Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Blend_Multiply_float(float Base, float Blend, out float Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Maximum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void GetAlpha_float(float alphaBase, float light, float mlp, float minAlpha, out float4 res){
        res = min(1.0, max(minAlpha, alphaBase * (light/10) * mlp ));
        }
        
        struct Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float
        {
        float3 WorldSpacePosition;
        };
        
        void SG_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float(float _shadow_alpha, float _2DLightMLP, float _2DLightMinAlpha, float _onlyRenderIn2DLight, float4x4 _camProj, float4x4 _camWorldToCam, Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float IN, out float4 OutVector4_1)
        {
        float _Property_3e1a6e8cf6c7482ba86cf4139dd7c69e_Out_0 = _onlyRenderIn2DLight;
        float _Property_a24ed8de38314c7b91fc5501a78e320a_Out_0 = _shadow_alpha;
        float4x4 _Property_022e2f884d7542508c664e14f0ca6b89_Out_0 = _camProj;
        float4x4 _Property_ea154a1dce9248de95cc6ae98b5a49f4_Out_0 = _camWorldToCam;
        Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767;
        _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767.WorldSpacePosition = IN.WorldSpacePosition;
        float2 _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1;
        SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_022e2f884d7542508c664e14f0ca6b89_Out_0, _Property_ea154a1dce9248de95cc6ae98b5a49f4_Out_0, _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767, _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1);
        float4 _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_R_4 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.r;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_G_5 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.g;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_B_6 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.b;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_A_7 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.a;
        float4 _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_R_4 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.r;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_G_5 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.g;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_B_6 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.b;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_A_7 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.a;
        float4 _Maximum_600d428159ef4ae19733009631d8183e_Out_2;
        Unity_Maximum_float4(_SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0, _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0, _Maximum_600d428159ef4ae19733009631d8183e_Out_2);
        float4 _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_R_4 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.r;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_G_5 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.g;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_B_6 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.b;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_A_7 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.a;
        float4 _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_R_4 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.r;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_G_5 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.g;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_B_6 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.b;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_A_7 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.a;
        float4 _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2;
        Unity_Maximum_float4(_SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0, _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0, _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2);
        float4 _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2;
        Unity_Maximum_float4(_Maximum_600d428159ef4ae19733009631d8183e_Out_2, _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2, _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2);
        float _Split_079a7389553a46f6b2e083de5ab0ec35_R_1 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[0];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_G_2 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[1];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_B_3 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[2];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_A_4 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[3];
        float _Maximum_459027f3b3df4840b45351867af70ed1_Out_2;
        Unity_Maximum_float(_Split_079a7389553a46f6b2e083de5ab0ec35_B_3, _Split_079a7389553a46f6b2e083de5ab0ec35_G_2, _Maximum_459027f3b3df4840b45351867af70ed1_Out_2);
        float _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2;
        Unity_Maximum_float(_Maximum_459027f3b3df4840b45351867af70ed1_Out_2, _Split_079a7389553a46f6b2e083de5ab0ec35_R_1, _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2);
        float _Property_111bb76eab7a41619d344262fafa3895_Out_0 = _2DLightMLP;
        float _Property_070598259d31416e98256505bbb2b2de_Out_0 = _2DLightMinAlpha;
        float4 _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0;
        GetAlpha_float(_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0, _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2, _Property_111bb76eab7a41619d344262fafa3895_Out_0, _Property_070598259d31416e98256505bbb2b2de_Out_0, _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0);
        float4 _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2;
        Unity_Multiply_float4_float4((_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0.xxxx), _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0, _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2);
        float4 _Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3;
        Unity_Branch_float4(_Property_3e1a6e8cf6c7482ba86cf4139dd7c69e_Out_0, _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2, (_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0.xxxx), _Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3);
        float4 _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1;
        Unity_Saturate_float4(_Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3, _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1);
        OutVector4_1 = _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_39a0c80a760d442e92412ca9c31ccaf5_Out_0 = _shadowBaseAlpha;
            float _Property_65c6a4cc5d374f13b91cd81a27486ba3_Out_0 = _shadowTexture;
            UnityTexture2D _Property_266f14f34a3c468e99c82838d2327dc3_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_ae79c0121c0442198ad8a19481d850c8_Out_0 = IN.uv0;
            float _TexelSize_86396267145246039524276a2683b94d_Width_0 = _Property_266f14f34a3c468e99c82838d2327dc3_Out_0.texelSize.z;
            float _TexelSize_86396267145246039524276a2683b94d_Height_2 = _Property_266f14f34a3c468e99c82838d2327dc3_Out_0.texelSize.w;
            float2 _Vector2_adbf5eb295764b359c895d572e0af102_Out_0 = float2(_TexelSize_86396267145246039524276a2683b94d_Width_0, _TexelSize_86396267145246039524276a2683b94d_Height_2);
            float _Property_1a28fa3b35dd4e1193848f9373679a25_Out_0 = _blurArea;
            float _Property_840bd827292044b297da6b2206472467_Out_0 = _blurStrength;
            float2 _Property_747cea1fc384479a8ebbb6c75f25a52b_Out_0 = _blurDir;
            float4x4 _Property_e97cf15c65fe40818e58b226aa758447_Out_0 = _camProj;
            float4x4 _Property_52c5f0665044443c9ea9e1b36de2aa09_Out_0 = _camWorldToCam;
            Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075;
            _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075.WorldSpacePosition = IN.WorldSpacePosition;
            float2 _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1;
            SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_e97cf15c65fe40818e58b226aa758447_Out_0, _Property_52c5f0665044443c9ea9e1b36de2aa09_Out_0, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1);
            Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float _BoxBlur_146e8bef57604c11860c784ef32014b2;
            float4 _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1;
            SG_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float(_Property_266f14f34a3c468e99c82838d2327dc3_Out_0, (_UV_ae79c0121c0442198ad8a19481d850c8_Out_0.xy), _Vector2_adbf5eb295764b359c895d572e0af102_Out_0, _Property_1a28fa3b35dd4e1193848f9373679a25_Out_0, _Property_840bd827292044b297da6b2206472467_Out_0, _Property_747cea1fc384479a8ebbb6c75f25a52b_Out_0, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1, _BoxBlur_146e8bef57604c11860c784ef32014b2, _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1);
            float _Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1 = _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1.w;
            UnityTexture2D _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0 = UnityBuildTexture2DStructNoScale(_shadowTex);
            float4 _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.tex, _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.samplerstate, _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_R_4 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.r;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_G_5 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.g;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_B_6 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.b;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_A_7 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.a;
            float4 _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2;
            Unity_Multiply_float4_float4((_Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1.xxxx), _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0, _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2);
            float4 _Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3;
            Unity_Branch_float4(_Property_65c6a4cc5d374f13b91cd81a27486ba3_Out_0, _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2, (_Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1.xxxx), _Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3);
            float _Property_269f6df3fbd447efaeeb85f3a462424a_Out_0 = _falloff;
            float _Property_02de571028bb4a16975e641e43976cd2_Out_0 = _fromSS;
            float4 _UV_db00e0a911d64679b4c6580b6b1418df_Out_0 = IN.uv0;
            float _Property_24bc71ec982a439ca0ddc1247924bbe0_Out_0 = _minX;
            float _Property_24635cb30088450b914780cf23c64e07_Out_0 = _maxX;
            float _Property_517af63683904c6aafb247552ff3a011_Out_0 = _minY;
            float _Property_9fc5fb11323f4477912a01e1f9c6ab76_Out_0 = _maxY;
            Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1;
            float2 _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1;
            SG_getSpriteUV_28898200da561d54c95498da7ec1387b_float(_Property_02de571028bb4a16975e641e43976cd2_Out_0, (_UV_db00e0a911d64679b4c6580b6b1418df_Out_0.xy), _Property_24bc71ec982a439ca0ddc1247924bbe0_Out_0, _Property_24635cb30088450b914780cf23c64e07_Out_0, _Property_517af63683904c6aafb247552ff3a011_Out_0, _Property_9fc5fb11323f4477912a01e1f9c6ab76_Out_0, _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1, _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1);
            float _Property_38c07cfd50364af59198ace5a1218e1c_Out_0 = _shadowNarrowing;
            float2 _Vector2_30d73056b259424a903bb0260189385c_Out_0 = float2(0.5, _Property_38c07cfd50364af59198ace5a1218e1c_Out_0);
            float2 _Rotate_354f1e875f8142599da0f89a879950cf_Out_3;
            Unity_Rotate_Degrees_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, _Vector2_30d73056b259424a903bb0260189385c_Out_0, 180, _Rotate_354f1e875f8142599da0f89a879950cf_Out_3);
            float4 _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).GetTransformedUV(_Rotate_354f1e875f8142599da0f89a879950cf_Out_3));
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_R_4 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.r;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_G_5 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.g;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_B_6 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.b;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_A_7 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.a;
            float4 _Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2;
            Unity_Divide_float4(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0, float4(1, 1, 1, 1), _Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2);
            float2 _TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3;
            Unity_TilingAndOffset_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, float2 (1, 1), float2 (0, 0), _TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3);
            float _Property_3de54516355e446b941821236b3a5539_Out_0 = _shadowNarrowing;
            float2 _Vector2_5490d5e7275944b2a1d3e15aa999783d_Out_0 = float2(0.5, _Property_3de54516355e446b941821236b3a5539_Out_0);
            float2 _Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3, _Vector2_5490d5e7275944b2a1d3e15aa999783d_Out_0, 90, _Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3);
            float4 _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).GetTransformedUV(_Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3));
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_R_4 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.r;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_G_5 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.g;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_B_6 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.b;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_A_7 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.a;
            float2 _TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3;
            Unity_TilingAndOffset_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, float2 (1, 1), float2 (0, 0), _TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3);
            float _Property_053ef645b525429eb8514144a5f0d8a5_Out_0 = _shadowNarrowing;
            float2 _Vector2_9e0a92a790e6479782cb7f44e5e39a96_Out_0 = float2(0.5, _Property_053ef645b525429eb8514144a5f0d8a5_Out_0);
            float2 _Rotate_937724de82cd4b709bafc850c9efdd35_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3, _Vector2_9e0a92a790e6479782cb7f44e5e39a96_Out_0, -90, _Rotate_937724de82cd4b709bafc850c9efdd35_Out_3);
            float4 _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).GetTransformedUV(_Rotate_937724de82cd4b709bafc850c9efdd35_Out_3));
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_R_4 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.r;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_G_5 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.g;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_B_6 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.b;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_A_7 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.a;
            float4 _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0, _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0, _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2);
            float4 _Multiply_4274a6a328994084b1b182cd09384636_Out_2;
            Unity_Multiply_float4_float4(_Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2, _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2, _Multiply_4274a6a328994084b1b182cd09384636_Out_2);
            float _Property_8846c22cbd2548d79b405c31433a0bf6_Out_0 = _shadowFalloff;
            float4 _Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2;
            Unity_Multiply_float4_float4(_Multiply_4274a6a328994084b1b182cd09384636_Out_2, (_Property_8846c22cbd2548d79b405c31433a0bf6_Out_0.xxxx), _Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2);
            float4 _Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1;
            Unity_Saturate_float4(_Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2, _Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1);
            float4 _Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2;
            Unity_Multiply_float4_float4(_Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1, float4(2, 2, 2, 2), _Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2);
            float _Property_8f9cd0c877224528832afbf49c0eca9c_Out_0 = _afrigesTex;
            float _Property_d3b4849aa43442b9b501c852f80974ee_Out_0 = _shadowBaseAlpha;
            float2 _TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.3, 0.3), (IN.WorldSpacePosition.xy), _TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3);
            float2 _Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3, float2 (0.5, 0.5), 0, _Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3);
            float4 _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1).tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Mirror).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1).GetTransformedUV(_Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3));
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_R_4 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.r;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_G_5 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.g;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_B_6 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.b;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_A_7 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.a;
            float _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2;
            Unity_Multiply_float_float(_Property_d3b4849aa43442b9b501c852f80974ee_Out_0, _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_R_4, _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2);
            float _Branch_15f412beaf5e46b19f8226a5db075124_Out_3;
            Unity_Branch_float(_Property_8f9cd0c877224528832afbf49c0eca9c_Out_0, _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2, 1, _Branch_15f412beaf5e46b19f8226a5db075124_Out_3);
            float4 _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2;
            Unity_Multiply_float4_float4(_Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2, (_Branch_15f412beaf5e46b19f8226a5db075124_Out_3.xxxx), _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2);
            float4 _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2;
            Unity_Blend_Overlay_float4(_Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2, _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2, _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2, 0.2);
            float4 _Branch_66a6d2861e6d4f6089053a6772d86451_Out_3;
            Unity_Branch_float4(_Property_269f6df3fbd447efaeeb85f3a462424a_Out_0, _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2, float4(1, 1, 1, 1), _Branch_66a6d2861e6d4f6089053a6772d86451_Out_3);
            float _Property_045f4a7a2af440bd8b474a9a895a430c_Out_0 = _vonroiTex;
            float _Property_c04500d7725947a69a1cf465b73beaf6_Out_0 = _shadowBaseAlpha;
            float2 _TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.3, 0.3), (IN.WorldSpacePosition.xy), _TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3);
            float _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3;
            float _Voronoi_5185d06e2788480f9f5edfeac380e38e_Cells_4;
            Unity_Voronoi_float(_TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3, 2, 1, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Cells_4);
            float _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3;
            Unity_Smoothstep_float(0.3, 1, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3, _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3);
            float _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3;
            Unity_Smoothstep_float(0, 0.5, _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3, _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3);
            float _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2;
            Unity_Multiply_float_float(_Property_c04500d7725947a69a1cf465b73beaf6_Out_0, _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3, _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2);
            float _Branch_a08b046aadf043aa821d5d9e70298163_Out_3;
            Unity_Branch_float(_Property_045f4a7a2af440bd8b474a9a895a430c_Out_0, _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2, 1, _Branch_a08b046aadf043aa821d5d9e70298163_Out_3);
            float4 _Blend_16b43719a5d34dac880346881fe9f272_Out_2;
            Unity_Blend_Multiply_float4(_Branch_66a6d2861e6d4f6089053a6772d86451_Out_3, (_Branch_a08b046aadf043aa821d5d9e70298163_Out_3.xxxx), _Blend_16b43719a5d34dac880346881fe9f272_Out_2, 0.1);
            float4 _Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2;
            Unity_Multiply_float4_float4(_Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3, _Blend_16b43719a5d34dac880346881fe9f272_Out_2, _Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2);
            float _Property_1bc6b0136e3442f2bd0c835a17615a34_Out_0 = _directional;
            float _Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2;
            Unity_Comparison_Greater_float(_Property_1bc6b0136e3442f2bd0c835a17615a34_Out_0, 0.5, _Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2);
            float _Property_32038686d7c6415ba0e518addc902f38_Out_0 = _useClosestPointLightForDirection;
            float _Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2;
            Unity_Or_float(_Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2, _Property_32038686d7c6415ba0e518addc902f38_Out_0, _Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2);
            float2 _Swizzle_9179ff07d7164d409a2342edc50e4390_Out_1 = IN.WorldSpacePosition.xy;
            float3 _Property_414892493f164994ba130276c6cb2dc6_Out_0 = _source;
            float2 _Swizzle_aa67dcd65c5e4b98acb2bb10a34ef37d_Out_1 = _Property_414892493f164994ba130276c6cb2dc6_Out_0.xy;
            float _Distance_82ab97a70bec43dfab653173af856737_Out_2;
            Unity_Distance_float2(_Swizzle_9179ff07d7164d409a2342edc50e4390_Out_1, _Swizzle_aa67dcd65c5e4b98acb2bb10a34ef37d_Out_1, _Distance_82ab97a70bec43dfab653173af856737_Out_2);
            float2 _Property_9b36c1d04153475d95525b4c285bc80b_Out_0 = _distMinMax;
            float _Split_88cecf19cf4d4c149324206c388fe6cb_R_1 = _Property_9b36c1d04153475d95525b4c285bc80b_Out_0[0];
            float _Split_88cecf19cf4d4c149324206c388fe6cb_G_2 = _Property_9b36c1d04153475d95525b4c285bc80b_Out_0[1];
            float _Split_88cecf19cf4d4c149324206c388fe6cb_B_3 = 0;
            float _Split_88cecf19cf4d4c149324206c388fe6cb_A_4 = 0;
            float _Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3;
            Unity_Clamp_float(_Distance_82ab97a70bec43dfab653173af856737_Out_2, 0, _Split_88cecf19cf4d4c149324206c388fe6cb_G_2, _Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3);
            float2 _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0 = _distMinMax;
            float _Split_715f243a60c9433990660b04d84633e2_R_1 = _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0[0];
            float _Split_715f243a60c9433990660b04d84633e2_G_2 = _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0[1];
            float _Split_715f243a60c9433990660b04d84633e2_B_3 = 0;
            float _Split_715f243a60c9433990660b04d84633e2_A_4 = 0;
            float _Divide_b4f326bea5de462a992c509de3e5e831_Out_2;
            Unity_Divide_float(_Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3, _Split_715f243a60c9433990660b04d84633e2_G_2, _Divide_b4f326bea5de462a992c509de3e5e831_Out_2);
            float _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3;
            Unity_Lerp_float(0, 1, _Divide_b4f326bea5de462a992c509de3e5e831_Out_2, _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3);
            float _Branch_17569a76eab4481eb16fbe1782242f1d_Out_3;
            Unity_Branch_float(_Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2, 1, _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3, _Branch_17569a76eab4481eb16fbe1782242f1d_Out_3);
            float4 _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2;
            Unity_Blend_Multiply_float4(_Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2, (_Branch_17569a76eab4481eb16fbe1782242f1d_Out_3.xxxx), _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2, 1);
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_R_1 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[0];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_G_2 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[1];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_B_3 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[2];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_A_4 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[3];
            float _Property_a440c1c925654a4eb8f15fca48f5aa3d_Out_0 = _fastAntyaliasing;
            UnityTexture2D _Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a;
            _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a.uv0 = IN.uv0;
            float _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1;
            SG_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float(_Property_a440c1c925654a4eb8f15fca48f5aa3d_Out_0, _Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1);
            float _Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2;
            Unity_Multiply_float_float(_Split_e085e2b7b0b9447cb31c3bedff43d4fa_R_1, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1, _Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2);
            float _Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0 = _sceneLighten;
            float3 _Property_a979b50a4dd341529f45439596b6ff98_Out_0 = _colorMlpRGB;
            float _Split_bd2a7871af334e818a970f83ab0fdce8_R_1 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[0];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_G_2 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[1];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_B_3 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[2];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_A_4 = 0;
            UnityTexture2D _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0 = UnityBuildTexture2DStructNoScale(_RenderText);
            float4x4 _Property_668393ac9856480ba5e4de219cd36c78_Out_0 = _camProj;
            float4x4 _Property_e0169419f075483c9fa9548fe401a2fe_Out_0 = _camWorldToCam;
            Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd;
            _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd.WorldSpacePosition = IN.WorldSpacePosition;
            float2 _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1;
            SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_668393ac9856480ba5e4de219cd36c78_Out_0, _Property_e0169419f075483c9fa9548fe401a2fe_Out_0, _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd, _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1);
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.tex, _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.samplerstate, _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.GetTransformedUV(_CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1), 1);
            #endif
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_R_5 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.r;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_G_6 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.g;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_B_7 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.b;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_A_8 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.a;
            float _Remap_fef0fe01a3a44d209390feb636d87117_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_R_5, float2 (0, 1), float2 (0, 2), _Remap_fef0fe01a3a44d209390feb636d87117_Out_3);
            float _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1;
            Unity_OneMinus_float(_Remap_fef0fe01a3a44d209390feb636d87117_Out_3, _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1);
            float _Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_R_1, _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1, _Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2);
            float _Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_G_6, float2 (0, 1), float2 (0, 2), _Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3);
            float _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1;
            Unity_OneMinus_float(_Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3, _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1);
            float _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_G_2, _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1, _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2);
            float _Minimum_881608b72fe747f49bb49799d4218a36_Out_2;
            Unity_Minimum_float(_Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2, _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2, _Minimum_881608b72fe747f49bb49799d4218a36_Out_2);
            float _Remap_c579a88bcefd49558c8688613e80f533_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_B_7, float2 (0, 1), float2 (0, 2), _Remap_c579a88bcefd49558c8688613e80f533_Out_3);
            float _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1;
            Unity_OneMinus_float(_Remap_c579a88bcefd49558c8688613e80f533_Out_3, _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1);
            float _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_B_3, _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1, _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2);
            float _Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2;
            Unity_Minimum_float(_Minimum_881608b72fe747f49bb49799d4218a36_Out_2, _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2, _Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2);
            float _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1;
            Unity_Saturate_float(_Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2, _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1);
            float _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3;
            Unity_Branch_float(_Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0, _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1, 0, _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3);
            float _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3;
            Unity_Branch_float(_Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0, 0.9, 0, _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3);
            float _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2;
            Unity_Blend_Multiply_float(_Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2, _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3, _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2, _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3);
            float _Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2;
            Unity_Multiply_float_float(_Property_39a0c80a760d442e92412ca9c31ccaf5_Out_0, _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2, _Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2);
            float _Property_5aaa24741fb4458496fadf63aabb26c7_Out_0 = _2DLightMLP;
            float _Property_664012205b8b47e3bddf2b78909fbdb5_Out_0 = _2DLightMinAlpha;
            float _Property_ee43ff1e651e4766a9d7825b4a41563e_Out_0 = _onlyRenderIn2DLight;
            float4x4 _Property_d9bbf4f126844f9691d1b659f2618f60_Out_0 = _camProj;
            float4x4 _Property_dcc5cca994d44486b344bbfaa27d94af_Out_0 = _camWorldToCam;
            Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99;
            _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99.WorldSpacePosition = IN.WorldSpacePosition;
            float4 _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1;
            SG_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float(_Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2, _Property_5aaa24741fb4458496fadf63aabb26c7_Out_0, _Property_664012205b8b47e3bddf2b78909fbdb5_Out_0, _Property_ee43ff1e651e4766a9d7825b4a41563e_Out_0, _Property_d9bbf4f126844f9691d1b659f2618f60_Out_0, _Property_dcc5cca994d44486b344bbfaa27d94af_Out_0, _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99, _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1);
            surface.Alpha = (_ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1).x;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.WorldSpacePosition =                         input.positionWS;
            output.uv0 =                                        input.texCoord0;
            output.uv1 =                                        input.texCoord1;
            output.uv2 =                                        input.texCoord2;
            output.uv3 =                                        input.texCoord3;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
            // Render State
            Cull Back
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define ATTRIBUTES_NEED_TEXCOORD3
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD3
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 uv3 : TEXCOORD3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
             float4 texCoord3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 uv0;
             float4 uv1;
             float4 uv2;
             float4 uv3;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.texCoord1;
            output.interp3.xyzw =  input.texCoord2;
            output.interp4.xyzw =  input.texCoord3;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.texCoord1 = input.interp2.xyzw;
            output.texCoord2 = input.interp3.xyzw;
            output.texCoord3 = input.interp4.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1_TexelSize;
        float4 _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1_TexelSize;
        float4 _SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1_TexelSize;
        float4 _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1_TexelSize;
        float4 _MainTex_TexelSize;
        float _shadowBaseAlpha;
        float _shadowReflectiveness;
        float _shadowNarrowing;
        float _shadowFalloff;
        float _shadowTexture;
        float4 _shadowTex_TexelSize;
        float _directional;
        float _fastAntyaliasing;
        float4 _edgeColor;
        float4 _RenderText_TexelSize;
        float3 _colorMlpRGB;
        float4 _shadowBaseColor;
        float _vonroiTex;
        float _afrigesTex;
        float _sceneLighten;
        float _falloff;
        float _fakeRefraction;
        float _enableBlur;
        float _blurStrength;
        float _blurArea;
        float4x4 _camProj;
        float4x4 _camWorldToCam;
        float2 _blurDir;
        float _onlyRenderIn2DLight;
        float _useClosestPointLightForDirection;
        float _2DLightMLP;
        float _2DLightMinAlpha;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Mirror);
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Point_Clamp);
        TEXTURE2D(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1);
        SAMPLER(sampler_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1);
        TEXTURE2D(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1);
        SAMPLER(sampler_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1);
        TEXTURE2D(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1);
        SAMPLER(sampler_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1);
        TEXTURE2D(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1);
        SAMPLER(sampler_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1);
        TEXTURE2D(_ShapeLightTexture0);
        SAMPLER(sampler_ShapeLightTexture0);
        float4 _ShapeLightTexture0_TexelSize;
        TEXTURE2D(_ShapeLightTexture1);
        SAMPLER(sampler_ShapeLightTexture1);
        float4 _ShapeLightTexture1_TexelSize;
        TEXTURE2D(_ShapeLightTexture2);
        SAMPLER(sampler_ShapeLightTexture2);
        float4 _ShapeLightTexture2_TexelSize;
        TEXTURE2D(_ShapeLightTexture3);
        SAMPLER(sampler_ShapeLightTexture3);
        float4 _ShapeLightTexture3_TexelSize;
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_shadowTex);
        SAMPLER(sampler_shadowTex);
        float2 _distMinMax;
        float3 _source;
        TEXTURE2D(_RenderText);
        SAMPLER(sampler_RenderText);
        float _minX;
        float _maxX;
        float _maxY;
        float _minY;
        float _fromSS;
        TEXTURE2D(_ModernShadowMask);
        SAMPLER(sampler_ModernShadowMask);
        float4 _ModernShadowMask_TexelSize;
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float4x4_float4x4(float4x4 A, float4x4 B, out float4x4 Out)
        {
        Out = mul(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
        {
        Out = mul(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        struct Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float
        {
        float3 WorldSpacePosition;
        };
        
        void SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(float4x4 _projectionMatrix, float4x4 _worldToCamMatrix, Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float IN, out float2 OutVector2_1)
        {
        float4x4 _Property_5e250b4a0f6742d492e1ffaa326ca712_Out_0 = _projectionMatrix;
        float4x4 _Property_b38ed1c9e33148539fa2aa331fad3e1e_Out_0 = _worldToCamMatrix;
        float4x4 _Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2;
        Unity_Multiply_float4x4_float4x4(_Property_5e250b4a0f6742d492e1ffaa326ca712_Out_0, _Property_b38ed1c9e33148539fa2aa331fad3e1e_Out_0, _Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2);
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_R_1 = IN.WorldSpacePosition[0];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_G_2 = IN.WorldSpacePosition[1];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_B_3 = IN.WorldSpacePosition[2];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_A_4 = 0;
        float4 _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4;
        float3 _Combine_b12c047fc90143598606bddcbbd3235c_RGB_5;
        float2 _Combine_b12c047fc90143598606bddcbbd3235c_RG_6;
        Unity_Combine_float(_Split_b28438aa8fd74da8879ec59ca390c4cb_R_1, _Split_b28438aa8fd74da8879ec59ca390c4cb_G_2, _Split_b28438aa8fd74da8879ec59ca390c4cb_B_3, 1, _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4, _Combine_b12c047fc90143598606bddcbbd3235c_RGB_5, _Combine_b12c047fc90143598606bddcbbd3235c_RG_6);
        float4 _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2;
        Unity_Multiply_float4x4_float4(_Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2, _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4, _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2);
        float _Split_eea358322a8b41d293cd1bbe8f795d83_R_1 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[0];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_G_2 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[1];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_B_3 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[2];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_A_4 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[3];
        float _Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2;
        Unity_Divide_float(_Split_eea358322a8b41d293cd1bbe8f795d83_R_1, _Split_eea358322a8b41d293cd1bbe8f795d83_A_4, _Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2);
        float _Add_8870e08ad8dc441aabe116e7732263ea_Out_2;
        Unity_Add_float(_Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2, 1, _Add_8870e08ad8dc441aabe116e7732263ea_Out_2);
        float _Multiply_990533093df5477c870cf76611148a17_Out_2;
        Unity_Multiply_float_float(_Add_8870e08ad8dc441aabe116e7732263ea_Out_2, 0.5, _Multiply_990533093df5477c870cf76611148a17_Out_2);
        float _Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2;
        Unity_Divide_float(_Split_eea358322a8b41d293cd1bbe8f795d83_G_2, _Split_eea358322a8b41d293cd1bbe8f795d83_A_4, _Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2);
        float _Add_5e3971a220d6404eab9366f74c9b69ea_Out_2;
        Unity_Add_float(_Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2, 1, _Add_5e3971a220d6404eab9366f74c9b69ea_Out_2);
        float _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2;
        Unity_Multiply_float_float(_Add_5e3971a220d6404eab9366f74c9b69ea_Out_2, 0.5, _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2);
        float2 _Vector2_061b57261ebb4976a044de3c8350d020_Out_0 = float2(_Multiply_990533093df5477c870cf76611148a17_Out_2, _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2);
        OutVector2_1 = _Vector2_061b57261ebb4976a044de3c8350d020_Out_0;
        }
        
        void Box_blur_float(UnityTexture2D tex, float2 UV, float2 texelS, float area, float strength, float2 dir, float2 pos, out float4 col){
        float4 o = 0;
        
        float sum = 0;
        
        float2 uvOffset;
        
        float weight = 1;
        
        
        float4 oc =  tex2D(tex,UV).xyzw;
        
        if(pos.x < 0.001 || pos.x > 0.999 || pos.y < 0.001 || pos.y > 0.999 ) col = tex2D(tex, UV);
        else{
        for(int x = - area / 2; x <= area / 2; ++x)
        
        {
        
        
        	for(int y = - area / 2; y <= area / 2; ++y)
        
        	{
        
        		uvOffset = UV;
        
        		uvOffset.x += dir.x *  ((x) *1/ texelS.x);
        
        		uvOffset.y +=dir.y *  ((y) * 1/texelS.y);
        
        		o += tex2Dlod(tex, float4(uvOffset.xy,1,1)) * weight;
        
        		sum += weight;
        
        	}
        
        
        }
        
        o *= (1.0f / sum);
        
        col = col  = lerp( oc , o , strength);
        }
        }
        
        struct Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float
        {
        };
        
        void SG_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float(UnityTexture2D _MainTex2, float2 _uv, float2 _texelS, float _area, float _sigmaX, float2 _dir, float2 _pos, Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float IN, out float4 col_1)
        {
        UnityTexture2D _Property_7b2e56d44efd4399bcf6bbbd21d74b66_Out_0 = _MainTex2;
        float2 _Property_b9ec06981d75414bba0afd20bdd9de9c_Out_0 = _uv;
        float2 _Property_56e4b5fb23744ef899acefff47f35e49_Out_0 = _texelS;
        float _Property_4271e8b1fb344e109adbcec48df8eac4_Out_0 = _area;
        float _Property_6c7096cbbb374fb2ad4280093f02c412_Out_0 = _sigmaX;
        float2 _Property_77ed7a1a234140cdb128ae9f188ef889_Out_0 = _dir;
        float2 _Property_9f9d5a72bffd4c8aaa578bd8b3a100a1_Out_0 = _pos;
        float4 _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4;
        Box_blur_float(_Property_7b2e56d44efd4399bcf6bbbd21d74b66_Out_0, _Property_b9ec06981d75414bba0afd20bdd9de9c_Out_0, _Property_56e4b5fb23744ef899acefff47f35e49_Out_0, _Property_4271e8b1fb344e109adbcec48df8eac4_Out_0, _Property_6c7096cbbb374fb2ad4280093f02c412_Out_0, _Property_77ed7a1a234140cdb128ae9f188ef889_Out_0, _Property_9f9d5a72bffd4c8aaa578bd8b3a100a1_Out_0, _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4);
        col_1 = _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float
        {
        };
        
        void SG_getSpriteUV_28898200da561d54c95498da7ec1387b_float(float _isFromSpriteSheet, float2 _uv, float _minX, float _maxX, float _minY, float _maxY, Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float IN, out float2 UV_1)
        {
        float _Property_59629b1305f34389b5ac2ae936e1d97a_Out_0 = _isFromSpriteSheet;
        float2 _Property_d386229f3dbd464c8b50826a8175c772_Out_0 = _uv;
        float _Split_aeed631f945444d188e965907d53f468_R_1 = _Property_d386229f3dbd464c8b50826a8175c772_Out_0[0];
        float _Split_aeed631f945444d188e965907d53f468_G_2 = _Property_d386229f3dbd464c8b50826a8175c772_Out_0[1];
        float _Split_aeed631f945444d188e965907d53f468_B_3 = 0;
        float _Split_aeed631f945444d188e965907d53f468_A_4 = 0;
        float _Property_3d13d310f40c4a38978749b541492e7e_Out_0 = _minX;
        float _Subtract_14c500329721426892410b2ffe30cc75_Out_2;
        Unity_Subtract_float(_Split_aeed631f945444d188e965907d53f468_R_1, _Property_3d13d310f40c4a38978749b541492e7e_Out_0, _Subtract_14c500329721426892410b2ffe30cc75_Out_2);
        float _Property_4b8021ce9c1f44d2b60bfff4c7d3c6d5_Out_0 = _maxX;
        float _Property_0c3a9984187940adb91e772580242719_Out_0 = _minX;
        float _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2;
        Unity_Subtract_float(_Property_4b8021ce9c1f44d2b60bfff4c7d3c6d5_Out_0, _Property_0c3a9984187940adb91e772580242719_Out_0, _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2);
        float _Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2;
        Unity_Divide_float(_Subtract_14c500329721426892410b2ffe30cc75_Out_2, _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2, _Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2);
        float _Property_fc2e7f28e6324e83ae0f9f10c53a4712_Out_0 = _minY;
        float _Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2;
        Unity_Subtract_float(_Split_aeed631f945444d188e965907d53f468_G_2, _Property_fc2e7f28e6324e83ae0f9f10c53a4712_Out_0, _Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2);
        float _Property_db14e0563c964d5db8b1c4b2265606be_Out_0 = _maxY;
        float _Property_f5f38a602035427790bc38042352fa9c_Out_0 = _minY;
        float _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2;
        Unity_Subtract_float(_Property_db14e0563c964d5db8b1c4b2265606be_Out_0, _Property_f5f38a602035427790bc38042352fa9c_Out_0, _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2);
        float _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2;
        Unity_Divide_float(_Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2, _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2, _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2);
        float4 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGBA_4;
        float3 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGB_5;
        float2 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6;
        Unity_Combine_float(_Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2, _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2, 0, 0, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGBA_4, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGB_5, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6);
        float2 _Property_b83213148b3746ada7e8c109a157d5eb_Out_0 = _uv;
        float2 _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3;
        Unity_Branch_float2(_Property_59629b1305f34389b5ac2ae936e1d97a_Out_0, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6, _Property_b83213148b3746ada7e8c109a157d5eb_Out_0, _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3);
        UV_1 = _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3;
        }
        
        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Saturate_float4(float4 In, out float4 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Blend_Overlay_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            float4 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float4 result2 = 2.0 * Base * Blend;
            float4 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Blend_Multiply_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Distance_float2(float2 A, float2 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_DDXY_4c15eab26cdc46fcb709d614ebea98aa_float(float In, out float Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING)
                    #error 'DDXY' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            Out = abs(ddx(In)) + abs(ddy(In));
        }
        
        void Unity_InverseLerp_float(float A, float B, float T, out float Out)
        {
            Out = (T - A)/(B - A);
        }
        
        struct Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float
        {
        half4 uv0;
        };
        
        void SG_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float(float _fastAntyaliasing, UnityTexture2D _MainTex, Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float IN, out float OutVector1_1)
        {
        float _Property_df7f9d1e6f3644bcbb0570916415aa00_Out_0 = _fastAntyaliasing;
        UnityTexture2D _Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0 = _MainTex;
        float4 _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0 = SAMPLE_TEXTURE2D(_Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Point_Clamp).samplerstate, _Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0.GetTransformedUV(IN.uv0.xy));
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_R_4 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.r;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_G_5 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.g;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_B_6 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.b;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.a;
        float _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1;
        Unity_DDXY_4c15eab26cdc46fcb709d614ebea98aa_float(_SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7, _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1);
        float _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2;
        Unity_Multiply_float_float(_Property_df7f9d1e6f3644bcbb0570916415aa00_Out_0, _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1, _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2);
        float _InverseLerp_394949f6e03a449798553a3a5429204a_Out_3;
        Unity_InverseLerp_float(1, 0, _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2, _InverseLerp_394949f6e03a449798553a3a5429204a_Out_3);
        float _Multiply_645ac89284924907975d95479e12d3a8_Out_2;
        Unity_Multiply_float_float(_InverseLerp_394949f6e03a449798553a3a5429204a_Out_3, _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7, _Multiply_645ac89284924907975d95479e12d3a8_Out_2);
        OutVector1_1 = _Multiply_645ac89284924907975d95479e12d3a8_Out_2;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Minimum_float(float A, float B, out float Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Blend_Multiply_float(float Base, float Blend, out float Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Maximum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void GetAlpha_float(float alphaBase, float light, float mlp, float minAlpha, out float4 res){
        res = min(1.0, max(minAlpha, alphaBase * (light/10) * mlp ));
        }
        
        struct Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float
        {
        float3 WorldSpacePosition;
        };
        
        void SG_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float(float _shadow_alpha, float _2DLightMLP, float _2DLightMinAlpha, float _onlyRenderIn2DLight, float4x4 _camProj, float4x4 _camWorldToCam, Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float IN, out float4 OutVector4_1)
        {
        float _Property_3e1a6e8cf6c7482ba86cf4139dd7c69e_Out_0 = _onlyRenderIn2DLight;
        float _Property_a24ed8de38314c7b91fc5501a78e320a_Out_0 = _shadow_alpha;
        float4x4 _Property_022e2f884d7542508c664e14f0ca6b89_Out_0 = _camProj;
        float4x4 _Property_ea154a1dce9248de95cc6ae98b5a49f4_Out_0 = _camWorldToCam;
        Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767;
        _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767.WorldSpacePosition = IN.WorldSpacePosition;
        float2 _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1;
        SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_022e2f884d7542508c664e14f0ca6b89_Out_0, _Property_ea154a1dce9248de95cc6ae98b5a49f4_Out_0, _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767, _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1);
        float4 _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_R_4 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.r;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_G_5 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.g;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_B_6 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.b;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_A_7 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.a;
        float4 _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_R_4 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.r;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_G_5 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.g;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_B_6 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.b;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_A_7 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.a;
        float4 _Maximum_600d428159ef4ae19733009631d8183e_Out_2;
        Unity_Maximum_float4(_SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0, _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0, _Maximum_600d428159ef4ae19733009631d8183e_Out_2);
        float4 _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_R_4 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.r;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_G_5 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.g;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_B_6 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.b;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_A_7 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.a;
        float4 _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_R_4 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.r;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_G_5 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.g;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_B_6 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.b;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_A_7 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.a;
        float4 _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2;
        Unity_Maximum_float4(_SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0, _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0, _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2);
        float4 _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2;
        Unity_Maximum_float4(_Maximum_600d428159ef4ae19733009631d8183e_Out_2, _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2, _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2);
        float _Split_079a7389553a46f6b2e083de5ab0ec35_R_1 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[0];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_G_2 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[1];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_B_3 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[2];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_A_4 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[3];
        float _Maximum_459027f3b3df4840b45351867af70ed1_Out_2;
        Unity_Maximum_float(_Split_079a7389553a46f6b2e083de5ab0ec35_B_3, _Split_079a7389553a46f6b2e083de5ab0ec35_G_2, _Maximum_459027f3b3df4840b45351867af70ed1_Out_2);
        float _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2;
        Unity_Maximum_float(_Maximum_459027f3b3df4840b45351867af70ed1_Out_2, _Split_079a7389553a46f6b2e083de5ab0ec35_R_1, _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2);
        float _Property_111bb76eab7a41619d344262fafa3895_Out_0 = _2DLightMLP;
        float _Property_070598259d31416e98256505bbb2b2de_Out_0 = _2DLightMinAlpha;
        float4 _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0;
        GetAlpha_float(_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0, _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2, _Property_111bb76eab7a41619d344262fafa3895_Out_0, _Property_070598259d31416e98256505bbb2b2de_Out_0, _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0);
        float4 _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2;
        Unity_Multiply_float4_float4((_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0.xxxx), _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0, _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2);
        float4 _Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3;
        Unity_Branch_float4(_Property_3e1a6e8cf6c7482ba86cf4139dd7c69e_Out_0, _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2, (_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0.xxxx), _Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3);
        float4 _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1;
        Unity_Saturate_float4(_Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3, _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1);
        OutVector4_1 = _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_39a0c80a760d442e92412ca9c31ccaf5_Out_0 = _shadowBaseAlpha;
            float _Property_65c6a4cc5d374f13b91cd81a27486ba3_Out_0 = _shadowTexture;
            UnityTexture2D _Property_266f14f34a3c468e99c82838d2327dc3_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_ae79c0121c0442198ad8a19481d850c8_Out_0 = IN.uv0;
            float _TexelSize_86396267145246039524276a2683b94d_Width_0 = _Property_266f14f34a3c468e99c82838d2327dc3_Out_0.texelSize.z;
            float _TexelSize_86396267145246039524276a2683b94d_Height_2 = _Property_266f14f34a3c468e99c82838d2327dc3_Out_0.texelSize.w;
            float2 _Vector2_adbf5eb295764b359c895d572e0af102_Out_0 = float2(_TexelSize_86396267145246039524276a2683b94d_Width_0, _TexelSize_86396267145246039524276a2683b94d_Height_2);
            float _Property_1a28fa3b35dd4e1193848f9373679a25_Out_0 = _blurArea;
            float _Property_840bd827292044b297da6b2206472467_Out_0 = _blurStrength;
            float2 _Property_747cea1fc384479a8ebbb6c75f25a52b_Out_0 = _blurDir;
            float4x4 _Property_e97cf15c65fe40818e58b226aa758447_Out_0 = _camProj;
            float4x4 _Property_52c5f0665044443c9ea9e1b36de2aa09_Out_0 = _camWorldToCam;
            Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075;
            _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075.WorldSpacePosition = IN.WorldSpacePosition;
            float2 _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1;
            SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_e97cf15c65fe40818e58b226aa758447_Out_0, _Property_52c5f0665044443c9ea9e1b36de2aa09_Out_0, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1);
            Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float _BoxBlur_146e8bef57604c11860c784ef32014b2;
            float4 _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1;
            SG_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float(_Property_266f14f34a3c468e99c82838d2327dc3_Out_0, (_UV_ae79c0121c0442198ad8a19481d850c8_Out_0.xy), _Vector2_adbf5eb295764b359c895d572e0af102_Out_0, _Property_1a28fa3b35dd4e1193848f9373679a25_Out_0, _Property_840bd827292044b297da6b2206472467_Out_0, _Property_747cea1fc384479a8ebbb6c75f25a52b_Out_0, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1, _BoxBlur_146e8bef57604c11860c784ef32014b2, _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1);
            float _Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1 = _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1.w;
            UnityTexture2D _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0 = UnityBuildTexture2DStructNoScale(_shadowTex);
            float4 _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.tex, _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.samplerstate, _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_R_4 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.r;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_G_5 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.g;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_B_6 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.b;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_A_7 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.a;
            float4 _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2;
            Unity_Multiply_float4_float4((_Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1.xxxx), _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0, _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2);
            float4 _Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3;
            Unity_Branch_float4(_Property_65c6a4cc5d374f13b91cd81a27486ba3_Out_0, _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2, (_Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1.xxxx), _Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3);
            float _Property_269f6df3fbd447efaeeb85f3a462424a_Out_0 = _falloff;
            float _Property_02de571028bb4a16975e641e43976cd2_Out_0 = _fromSS;
            float4 _UV_db00e0a911d64679b4c6580b6b1418df_Out_0 = IN.uv0;
            float _Property_24bc71ec982a439ca0ddc1247924bbe0_Out_0 = _minX;
            float _Property_24635cb30088450b914780cf23c64e07_Out_0 = _maxX;
            float _Property_517af63683904c6aafb247552ff3a011_Out_0 = _minY;
            float _Property_9fc5fb11323f4477912a01e1f9c6ab76_Out_0 = _maxY;
            Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1;
            float2 _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1;
            SG_getSpriteUV_28898200da561d54c95498da7ec1387b_float(_Property_02de571028bb4a16975e641e43976cd2_Out_0, (_UV_db00e0a911d64679b4c6580b6b1418df_Out_0.xy), _Property_24bc71ec982a439ca0ddc1247924bbe0_Out_0, _Property_24635cb30088450b914780cf23c64e07_Out_0, _Property_517af63683904c6aafb247552ff3a011_Out_0, _Property_9fc5fb11323f4477912a01e1f9c6ab76_Out_0, _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1, _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1);
            float _Property_38c07cfd50364af59198ace5a1218e1c_Out_0 = _shadowNarrowing;
            float2 _Vector2_30d73056b259424a903bb0260189385c_Out_0 = float2(0.5, _Property_38c07cfd50364af59198ace5a1218e1c_Out_0);
            float2 _Rotate_354f1e875f8142599da0f89a879950cf_Out_3;
            Unity_Rotate_Degrees_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, _Vector2_30d73056b259424a903bb0260189385c_Out_0, 180, _Rotate_354f1e875f8142599da0f89a879950cf_Out_3);
            float4 _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).GetTransformedUV(_Rotate_354f1e875f8142599da0f89a879950cf_Out_3));
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_R_4 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.r;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_G_5 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.g;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_B_6 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.b;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_A_7 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.a;
            float4 _Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2;
            Unity_Divide_float4(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0, float4(1, 1, 1, 1), _Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2);
            float2 _TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3;
            Unity_TilingAndOffset_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, float2 (1, 1), float2 (0, 0), _TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3);
            float _Property_3de54516355e446b941821236b3a5539_Out_0 = _shadowNarrowing;
            float2 _Vector2_5490d5e7275944b2a1d3e15aa999783d_Out_0 = float2(0.5, _Property_3de54516355e446b941821236b3a5539_Out_0);
            float2 _Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3, _Vector2_5490d5e7275944b2a1d3e15aa999783d_Out_0, 90, _Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3);
            float4 _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).GetTransformedUV(_Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3));
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_R_4 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.r;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_G_5 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.g;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_B_6 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.b;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_A_7 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.a;
            float2 _TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3;
            Unity_TilingAndOffset_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, float2 (1, 1), float2 (0, 0), _TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3);
            float _Property_053ef645b525429eb8514144a5f0d8a5_Out_0 = _shadowNarrowing;
            float2 _Vector2_9e0a92a790e6479782cb7f44e5e39a96_Out_0 = float2(0.5, _Property_053ef645b525429eb8514144a5f0d8a5_Out_0);
            float2 _Rotate_937724de82cd4b709bafc850c9efdd35_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3, _Vector2_9e0a92a790e6479782cb7f44e5e39a96_Out_0, -90, _Rotate_937724de82cd4b709bafc850c9efdd35_Out_3);
            float4 _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).GetTransformedUV(_Rotate_937724de82cd4b709bafc850c9efdd35_Out_3));
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_R_4 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.r;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_G_5 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.g;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_B_6 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.b;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_A_7 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.a;
            float4 _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0, _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0, _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2);
            float4 _Multiply_4274a6a328994084b1b182cd09384636_Out_2;
            Unity_Multiply_float4_float4(_Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2, _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2, _Multiply_4274a6a328994084b1b182cd09384636_Out_2);
            float _Property_8846c22cbd2548d79b405c31433a0bf6_Out_0 = _shadowFalloff;
            float4 _Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2;
            Unity_Multiply_float4_float4(_Multiply_4274a6a328994084b1b182cd09384636_Out_2, (_Property_8846c22cbd2548d79b405c31433a0bf6_Out_0.xxxx), _Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2);
            float4 _Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1;
            Unity_Saturate_float4(_Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2, _Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1);
            float4 _Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2;
            Unity_Multiply_float4_float4(_Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1, float4(2, 2, 2, 2), _Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2);
            float _Property_8f9cd0c877224528832afbf49c0eca9c_Out_0 = _afrigesTex;
            float _Property_d3b4849aa43442b9b501c852f80974ee_Out_0 = _shadowBaseAlpha;
            float2 _TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.3, 0.3), (IN.WorldSpacePosition.xy), _TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3);
            float2 _Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3, float2 (0.5, 0.5), 0, _Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3);
            float4 _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1).tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Mirror).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1).GetTransformedUV(_Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3));
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_R_4 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.r;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_G_5 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.g;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_B_6 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.b;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_A_7 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.a;
            float _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2;
            Unity_Multiply_float_float(_Property_d3b4849aa43442b9b501c852f80974ee_Out_0, _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_R_4, _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2);
            float _Branch_15f412beaf5e46b19f8226a5db075124_Out_3;
            Unity_Branch_float(_Property_8f9cd0c877224528832afbf49c0eca9c_Out_0, _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2, 1, _Branch_15f412beaf5e46b19f8226a5db075124_Out_3);
            float4 _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2;
            Unity_Multiply_float4_float4(_Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2, (_Branch_15f412beaf5e46b19f8226a5db075124_Out_3.xxxx), _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2);
            float4 _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2;
            Unity_Blend_Overlay_float4(_Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2, _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2, _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2, 0.2);
            float4 _Branch_66a6d2861e6d4f6089053a6772d86451_Out_3;
            Unity_Branch_float4(_Property_269f6df3fbd447efaeeb85f3a462424a_Out_0, _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2, float4(1, 1, 1, 1), _Branch_66a6d2861e6d4f6089053a6772d86451_Out_3);
            float _Property_045f4a7a2af440bd8b474a9a895a430c_Out_0 = _vonroiTex;
            float _Property_c04500d7725947a69a1cf465b73beaf6_Out_0 = _shadowBaseAlpha;
            float2 _TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.3, 0.3), (IN.WorldSpacePosition.xy), _TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3);
            float _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3;
            float _Voronoi_5185d06e2788480f9f5edfeac380e38e_Cells_4;
            Unity_Voronoi_float(_TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3, 2, 1, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Cells_4);
            float _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3;
            Unity_Smoothstep_float(0.3, 1, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3, _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3);
            float _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3;
            Unity_Smoothstep_float(0, 0.5, _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3, _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3);
            float _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2;
            Unity_Multiply_float_float(_Property_c04500d7725947a69a1cf465b73beaf6_Out_0, _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3, _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2);
            float _Branch_a08b046aadf043aa821d5d9e70298163_Out_3;
            Unity_Branch_float(_Property_045f4a7a2af440bd8b474a9a895a430c_Out_0, _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2, 1, _Branch_a08b046aadf043aa821d5d9e70298163_Out_3);
            float4 _Blend_16b43719a5d34dac880346881fe9f272_Out_2;
            Unity_Blend_Multiply_float4(_Branch_66a6d2861e6d4f6089053a6772d86451_Out_3, (_Branch_a08b046aadf043aa821d5d9e70298163_Out_3.xxxx), _Blend_16b43719a5d34dac880346881fe9f272_Out_2, 0.1);
            float4 _Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2;
            Unity_Multiply_float4_float4(_Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3, _Blend_16b43719a5d34dac880346881fe9f272_Out_2, _Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2);
            float _Property_1bc6b0136e3442f2bd0c835a17615a34_Out_0 = _directional;
            float _Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2;
            Unity_Comparison_Greater_float(_Property_1bc6b0136e3442f2bd0c835a17615a34_Out_0, 0.5, _Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2);
            float _Property_32038686d7c6415ba0e518addc902f38_Out_0 = _useClosestPointLightForDirection;
            float _Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2;
            Unity_Or_float(_Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2, _Property_32038686d7c6415ba0e518addc902f38_Out_0, _Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2);
            float2 _Swizzle_9179ff07d7164d409a2342edc50e4390_Out_1 = IN.WorldSpacePosition.xy;
            float3 _Property_414892493f164994ba130276c6cb2dc6_Out_0 = _source;
            float2 _Swizzle_aa67dcd65c5e4b98acb2bb10a34ef37d_Out_1 = _Property_414892493f164994ba130276c6cb2dc6_Out_0.xy;
            float _Distance_82ab97a70bec43dfab653173af856737_Out_2;
            Unity_Distance_float2(_Swizzle_9179ff07d7164d409a2342edc50e4390_Out_1, _Swizzle_aa67dcd65c5e4b98acb2bb10a34ef37d_Out_1, _Distance_82ab97a70bec43dfab653173af856737_Out_2);
            float2 _Property_9b36c1d04153475d95525b4c285bc80b_Out_0 = _distMinMax;
            float _Split_88cecf19cf4d4c149324206c388fe6cb_R_1 = _Property_9b36c1d04153475d95525b4c285bc80b_Out_0[0];
            float _Split_88cecf19cf4d4c149324206c388fe6cb_G_2 = _Property_9b36c1d04153475d95525b4c285bc80b_Out_0[1];
            float _Split_88cecf19cf4d4c149324206c388fe6cb_B_3 = 0;
            float _Split_88cecf19cf4d4c149324206c388fe6cb_A_4 = 0;
            float _Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3;
            Unity_Clamp_float(_Distance_82ab97a70bec43dfab653173af856737_Out_2, 0, _Split_88cecf19cf4d4c149324206c388fe6cb_G_2, _Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3);
            float2 _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0 = _distMinMax;
            float _Split_715f243a60c9433990660b04d84633e2_R_1 = _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0[0];
            float _Split_715f243a60c9433990660b04d84633e2_G_2 = _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0[1];
            float _Split_715f243a60c9433990660b04d84633e2_B_3 = 0;
            float _Split_715f243a60c9433990660b04d84633e2_A_4 = 0;
            float _Divide_b4f326bea5de462a992c509de3e5e831_Out_2;
            Unity_Divide_float(_Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3, _Split_715f243a60c9433990660b04d84633e2_G_2, _Divide_b4f326bea5de462a992c509de3e5e831_Out_2);
            float _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3;
            Unity_Lerp_float(0, 1, _Divide_b4f326bea5de462a992c509de3e5e831_Out_2, _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3);
            float _Branch_17569a76eab4481eb16fbe1782242f1d_Out_3;
            Unity_Branch_float(_Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2, 1, _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3, _Branch_17569a76eab4481eb16fbe1782242f1d_Out_3);
            float4 _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2;
            Unity_Blend_Multiply_float4(_Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2, (_Branch_17569a76eab4481eb16fbe1782242f1d_Out_3.xxxx), _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2, 1);
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_R_1 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[0];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_G_2 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[1];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_B_3 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[2];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_A_4 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[3];
            float _Property_a440c1c925654a4eb8f15fca48f5aa3d_Out_0 = _fastAntyaliasing;
            UnityTexture2D _Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a;
            _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a.uv0 = IN.uv0;
            float _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1;
            SG_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float(_Property_a440c1c925654a4eb8f15fca48f5aa3d_Out_0, _Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1);
            float _Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2;
            Unity_Multiply_float_float(_Split_e085e2b7b0b9447cb31c3bedff43d4fa_R_1, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1, _Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2);
            float _Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0 = _sceneLighten;
            float3 _Property_a979b50a4dd341529f45439596b6ff98_Out_0 = _colorMlpRGB;
            float _Split_bd2a7871af334e818a970f83ab0fdce8_R_1 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[0];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_G_2 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[1];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_B_3 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[2];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_A_4 = 0;
            UnityTexture2D _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0 = UnityBuildTexture2DStructNoScale(_RenderText);
            float4x4 _Property_668393ac9856480ba5e4de219cd36c78_Out_0 = _camProj;
            float4x4 _Property_e0169419f075483c9fa9548fe401a2fe_Out_0 = _camWorldToCam;
            Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd;
            _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd.WorldSpacePosition = IN.WorldSpacePosition;
            float2 _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1;
            SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_668393ac9856480ba5e4de219cd36c78_Out_0, _Property_e0169419f075483c9fa9548fe401a2fe_Out_0, _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd, _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1);
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.tex, _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.samplerstate, _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.GetTransformedUV(_CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1), 1);
            #endif
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_R_5 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.r;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_G_6 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.g;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_B_7 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.b;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_A_8 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.a;
            float _Remap_fef0fe01a3a44d209390feb636d87117_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_R_5, float2 (0, 1), float2 (0, 2), _Remap_fef0fe01a3a44d209390feb636d87117_Out_3);
            float _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1;
            Unity_OneMinus_float(_Remap_fef0fe01a3a44d209390feb636d87117_Out_3, _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1);
            float _Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_R_1, _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1, _Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2);
            float _Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_G_6, float2 (0, 1), float2 (0, 2), _Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3);
            float _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1;
            Unity_OneMinus_float(_Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3, _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1);
            float _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_G_2, _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1, _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2);
            float _Minimum_881608b72fe747f49bb49799d4218a36_Out_2;
            Unity_Minimum_float(_Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2, _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2, _Minimum_881608b72fe747f49bb49799d4218a36_Out_2);
            float _Remap_c579a88bcefd49558c8688613e80f533_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_B_7, float2 (0, 1), float2 (0, 2), _Remap_c579a88bcefd49558c8688613e80f533_Out_3);
            float _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1;
            Unity_OneMinus_float(_Remap_c579a88bcefd49558c8688613e80f533_Out_3, _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1);
            float _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_B_3, _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1, _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2);
            float _Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2;
            Unity_Minimum_float(_Minimum_881608b72fe747f49bb49799d4218a36_Out_2, _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2, _Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2);
            float _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1;
            Unity_Saturate_float(_Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2, _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1);
            float _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3;
            Unity_Branch_float(_Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0, _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1, 0, _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3);
            float _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3;
            Unity_Branch_float(_Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0, 0.9, 0, _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3);
            float _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2;
            Unity_Blend_Multiply_float(_Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2, _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3, _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2, _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3);
            float _Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2;
            Unity_Multiply_float_float(_Property_39a0c80a760d442e92412ca9c31ccaf5_Out_0, _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2, _Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2);
            float _Property_5aaa24741fb4458496fadf63aabb26c7_Out_0 = _2DLightMLP;
            float _Property_664012205b8b47e3bddf2b78909fbdb5_Out_0 = _2DLightMinAlpha;
            float _Property_ee43ff1e651e4766a9d7825b4a41563e_Out_0 = _onlyRenderIn2DLight;
            float4x4 _Property_d9bbf4f126844f9691d1b659f2618f60_Out_0 = _camProj;
            float4x4 _Property_dcc5cca994d44486b344bbfaa27d94af_Out_0 = _camWorldToCam;
            Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99;
            _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99.WorldSpacePosition = IN.WorldSpacePosition;
            float4 _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1;
            SG_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float(_Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2, _Property_5aaa24741fb4458496fadf63aabb26c7_Out_0, _Property_664012205b8b47e3bddf2b78909fbdb5_Out_0, _Property_ee43ff1e651e4766a9d7825b4a41563e_Out_0, _Property_d9bbf4f126844f9691d1b659f2618f60_Out_0, _Property_dcc5cca994d44486b344bbfaa27d94af_Out_0, _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99, _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1);
            surface.Alpha = (_ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1).x;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.WorldSpacePosition =                         input.positionWS;
            output.uv0 =                                        input.texCoord0;
            output.uv1 =                                        input.texCoord1;
            output.uv2 =                                        input.texCoord2;
            output.uv3 =                                        input.texCoord3;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "Sprite Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
            // Render State
            Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            #pragma multi_compile_fragment _ DEBUG_DISPLAY
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define ATTRIBUTES_NEED_TEXCOORD3
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD3
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SPRITEFORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
             float4 texCoord3;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 uv0;
             float4 uv1;
             float4 uv2;
             float4 uv3;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
             float4 interp5 : INTERP5;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.texCoord1;
            output.interp3.xyzw =  input.texCoord2;
            output.interp4.xyzw =  input.texCoord3;
            output.interp5.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.texCoord1 = input.interp2.xyzw;
            output.texCoord2 = input.interp3.xyzw;
            output.texCoord3 = input.interp4.xyzw;
            output.color = input.interp5.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1_TexelSize;
        float4 _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1_TexelSize;
        float4 _SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1_TexelSize;
        float4 _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1_TexelSize;
        float4 _MainTex_TexelSize;
        float _shadowBaseAlpha;
        float _shadowReflectiveness;
        float _shadowNarrowing;
        float _shadowFalloff;
        float _shadowTexture;
        float4 _shadowTex_TexelSize;
        float _directional;
        float _fastAntyaliasing;
        float4 _edgeColor;
        float4 _RenderText_TexelSize;
        float3 _colorMlpRGB;
        float4 _shadowBaseColor;
        float _vonroiTex;
        float _afrigesTex;
        float _sceneLighten;
        float _falloff;
        float _fakeRefraction;
        float _enableBlur;
        float _blurStrength;
        float _blurArea;
        float4x4 _camProj;
        float4x4 _camWorldToCam;
        float2 _blurDir;
        float _onlyRenderIn2DLight;
        float _useClosestPointLightForDirection;
        float _2DLightMLP;
        float _2DLightMinAlpha;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Mirror);
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Point_Clamp);
        TEXTURE2D(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1);
        SAMPLER(sampler_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1);
        TEXTURE2D(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1);
        SAMPLER(sampler_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1);
        TEXTURE2D(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1);
        SAMPLER(sampler_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1);
        TEXTURE2D(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1);
        SAMPLER(sampler_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1);
        TEXTURE2D(_ShapeLightTexture0);
        SAMPLER(sampler_ShapeLightTexture0);
        float4 _ShapeLightTexture0_TexelSize;
        TEXTURE2D(_ShapeLightTexture1);
        SAMPLER(sampler_ShapeLightTexture1);
        float4 _ShapeLightTexture1_TexelSize;
        TEXTURE2D(_ShapeLightTexture2);
        SAMPLER(sampler_ShapeLightTexture2);
        float4 _ShapeLightTexture2_TexelSize;
        TEXTURE2D(_ShapeLightTexture3);
        SAMPLER(sampler_ShapeLightTexture3);
        float4 _ShapeLightTexture3_TexelSize;
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_shadowTex);
        SAMPLER(sampler_shadowTex);
        float2 _distMinMax;
        float3 _source;
        TEXTURE2D(_RenderText);
        SAMPLER(sampler_RenderText);
        float _minX;
        float _maxX;
        float _maxY;
        float _minY;
        float _fromSS;
        TEXTURE2D(_ModernShadowMask);
        SAMPLER(sampler_ModernShadowMask);
        float4 _ModernShadowMask_TexelSize;
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float4x4_float4x4(float4x4 A, float4x4 B, out float4x4 Out)
        {
        Out = mul(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
        {
        Out = mul(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        struct Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float
        {
        float3 WorldSpacePosition;
        };
        
        void SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(float4x4 _projectionMatrix, float4x4 _worldToCamMatrix, Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float IN, out float2 OutVector2_1)
        {
        float4x4 _Property_5e250b4a0f6742d492e1ffaa326ca712_Out_0 = _projectionMatrix;
        float4x4 _Property_b38ed1c9e33148539fa2aa331fad3e1e_Out_0 = _worldToCamMatrix;
        float4x4 _Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2;
        Unity_Multiply_float4x4_float4x4(_Property_5e250b4a0f6742d492e1ffaa326ca712_Out_0, _Property_b38ed1c9e33148539fa2aa331fad3e1e_Out_0, _Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2);
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_R_1 = IN.WorldSpacePosition[0];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_G_2 = IN.WorldSpacePosition[1];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_B_3 = IN.WorldSpacePosition[2];
        float _Split_b28438aa8fd74da8879ec59ca390c4cb_A_4 = 0;
        float4 _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4;
        float3 _Combine_b12c047fc90143598606bddcbbd3235c_RGB_5;
        float2 _Combine_b12c047fc90143598606bddcbbd3235c_RG_6;
        Unity_Combine_float(_Split_b28438aa8fd74da8879ec59ca390c4cb_R_1, _Split_b28438aa8fd74da8879ec59ca390c4cb_G_2, _Split_b28438aa8fd74da8879ec59ca390c4cb_B_3, 1, _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4, _Combine_b12c047fc90143598606bddcbbd3235c_RGB_5, _Combine_b12c047fc90143598606bddcbbd3235c_RG_6);
        float4 _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2;
        Unity_Multiply_float4x4_float4(_Multiply_4077c20016394a17bb618332cb9b4c8b_Out_2, _Combine_b12c047fc90143598606bddcbbd3235c_RGBA_4, _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2);
        float _Split_eea358322a8b41d293cd1bbe8f795d83_R_1 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[0];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_G_2 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[1];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_B_3 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[2];
        float _Split_eea358322a8b41d293cd1bbe8f795d83_A_4 = _Multiply_f39c616a83224d07a85ee8878ac63f28_Out_2[3];
        float _Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2;
        Unity_Divide_float(_Split_eea358322a8b41d293cd1bbe8f795d83_R_1, _Split_eea358322a8b41d293cd1bbe8f795d83_A_4, _Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2);
        float _Add_8870e08ad8dc441aabe116e7732263ea_Out_2;
        Unity_Add_float(_Divide_0625b8489c234f479ff8d1debb8bf9b4_Out_2, 1, _Add_8870e08ad8dc441aabe116e7732263ea_Out_2);
        float _Multiply_990533093df5477c870cf76611148a17_Out_2;
        Unity_Multiply_float_float(_Add_8870e08ad8dc441aabe116e7732263ea_Out_2, 0.5, _Multiply_990533093df5477c870cf76611148a17_Out_2);
        float _Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2;
        Unity_Divide_float(_Split_eea358322a8b41d293cd1bbe8f795d83_G_2, _Split_eea358322a8b41d293cd1bbe8f795d83_A_4, _Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2);
        float _Add_5e3971a220d6404eab9366f74c9b69ea_Out_2;
        Unity_Add_float(_Divide_0eae5b3ca40c4da6b37a3596988d7424_Out_2, 1, _Add_5e3971a220d6404eab9366f74c9b69ea_Out_2);
        float _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2;
        Unity_Multiply_float_float(_Add_5e3971a220d6404eab9366f74c9b69ea_Out_2, 0.5, _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2);
        float2 _Vector2_061b57261ebb4976a044de3c8350d020_Out_0 = float2(_Multiply_990533093df5477c870cf76611148a17_Out_2, _Multiply_1a4011f7519e456abd4c1e90710a663c_Out_2);
        OutVector2_1 = _Vector2_061b57261ebb4976a044de3c8350d020_Out_0;
        }
        
        void Box_blur_float(UnityTexture2D tex, float2 UV, float2 texelS, float area, float strength, float2 dir, float2 pos, out float4 col){
        float4 o = 0;
        
        float sum = 0;
        
        float2 uvOffset;
        
        float weight = 1;
        
        
        float4 oc =  tex2D(tex,UV).xyzw;
        
        if(pos.x < 0.001 || pos.x > 0.999 || pos.y < 0.001 || pos.y > 0.999 ) col = tex2D(tex, UV);
        else{
        for(int x = - area / 2; x <= area / 2; ++x)
        
        {
        
        
        	for(int y = - area / 2; y <= area / 2; ++y)
        
        	{
        
        		uvOffset = UV;
        
        		uvOffset.x += dir.x *  ((x) *1/ texelS.x);
        
        		uvOffset.y +=dir.y *  ((y) * 1/texelS.y);
        
        		o += tex2Dlod(tex, float4(uvOffset.xy,1,1)) * weight;
        
        		sum += weight;
        
        	}
        
        
        }
        
        o *= (1.0f / sum);
        
        col = col  = lerp( oc , o , strength);
        }
        }
        
        struct Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float
        {
        };
        
        void SG_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float(UnityTexture2D _MainTex2, float2 _uv, float2 _texelS, float _area, float _sigmaX, float2 _dir, float2 _pos, Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float IN, out float4 col_1)
        {
        UnityTexture2D _Property_7b2e56d44efd4399bcf6bbbd21d74b66_Out_0 = _MainTex2;
        float2 _Property_b9ec06981d75414bba0afd20bdd9de9c_Out_0 = _uv;
        float2 _Property_56e4b5fb23744ef899acefff47f35e49_Out_0 = _texelS;
        float _Property_4271e8b1fb344e109adbcec48df8eac4_Out_0 = _area;
        float _Property_6c7096cbbb374fb2ad4280093f02c412_Out_0 = _sigmaX;
        float2 _Property_77ed7a1a234140cdb128ae9f188ef889_Out_0 = _dir;
        float2 _Property_9f9d5a72bffd4c8aaa578bd8b3a100a1_Out_0 = _pos;
        float4 _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4;
        Box_blur_float(_Property_7b2e56d44efd4399bcf6bbbd21d74b66_Out_0, _Property_b9ec06981d75414bba0afd20bdd9de9c_Out_0, _Property_56e4b5fb23744ef899acefff47f35e49_Out_0, _Property_4271e8b1fb344e109adbcec48df8eac4_Out_0, _Property_6c7096cbbb374fb2ad4280093f02c412_Out_0, _Property_77ed7a1a234140cdb128ae9f188ef889_Out_0, _Property_9f9d5a72bffd4c8aaa578bd8b3a100a1_Out_0, _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4);
        col_1 = _BoxblurCustomFunction_cfd6d41d47854a46be528efb98c6b139_col_4;
        }
        
        void Unity_ColorspaceConversion_RGB_HSV_float(float3 In, out float3 Out)
        {
            float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
            float4 P = lerp(float4(In.bg, K.wz), float4(In.gb, K.xy), step(In.b, In.g));
            float4 Q = lerp(float4(P.xyw, In.r), float4(In.r, P.yzx), step(P.x, In.r));
            float D = Q.x - min(Q.w, Q.y);
            float  E = 1e-10;
            float V = (D == 0) ? Q.x : (Q.x + E);
            Out = float3(abs(Q.z + (Q.w - Q.y)/(6.0 * D + E)), D / (Q.x + E), V);
        }
        
        void Unity_ColorspaceConversion_HSV_RGB_float(float3 In, out float3 Out)
        {
            float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
            float3 P = abs(frac(In.xxx + K.xyz) * 6.0 - K.www);
            Out = In.z * lerp(K.xxx, saturate(P - K.xxx), In.y);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float3(float3 In, out float3 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_DDXY_06eaa0d2fa7d4e1fa8820dc0c8697336_float(float In, out float Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING)
                    #error 'DDXY' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            Out = abs(ddx(In)) + abs(ddy(In));
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float
        {
        };
        
        void SG_getSpriteUV_28898200da561d54c95498da7ec1387b_float(float _isFromSpriteSheet, float2 _uv, float _minX, float _maxX, float _minY, float _maxY, Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float IN, out float2 UV_1)
        {
        float _Property_59629b1305f34389b5ac2ae936e1d97a_Out_0 = _isFromSpriteSheet;
        float2 _Property_d386229f3dbd464c8b50826a8175c772_Out_0 = _uv;
        float _Split_aeed631f945444d188e965907d53f468_R_1 = _Property_d386229f3dbd464c8b50826a8175c772_Out_0[0];
        float _Split_aeed631f945444d188e965907d53f468_G_2 = _Property_d386229f3dbd464c8b50826a8175c772_Out_0[1];
        float _Split_aeed631f945444d188e965907d53f468_B_3 = 0;
        float _Split_aeed631f945444d188e965907d53f468_A_4 = 0;
        float _Property_3d13d310f40c4a38978749b541492e7e_Out_0 = _minX;
        float _Subtract_14c500329721426892410b2ffe30cc75_Out_2;
        Unity_Subtract_float(_Split_aeed631f945444d188e965907d53f468_R_1, _Property_3d13d310f40c4a38978749b541492e7e_Out_0, _Subtract_14c500329721426892410b2ffe30cc75_Out_2);
        float _Property_4b8021ce9c1f44d2b60bfff4c7d3c6d5_Out_0 = _maxX;
        float _Property_0c3a9984187940adb91e772580242719_Out_0 = _minX;
        float _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2;
        Unity_Subtract_float(_Property_4b8021ce9c1f44d2b60bfff4c7d3c6d5_Out_0, _Property_0c3a9984187940adb91e772580242719_Out_0, _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2);
        float _Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2;
        Unity_Divide_float(_Subtract_14c500329721426892410b2ffe30cc75_Out_2, _Subtract_e8c57c5463d14563a298e496908a42c1_Out_2, _Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2);
        float _Property_fc2e7f28e6324e83ae0f9f10c53a4712_Out_0 = _minY;
        float _Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2;
        Unity_Subtract_float(_Split_aeed631f945444d188e965907d53f468_G_2, _Property_fc2e7f28e6324e83ae0f9f10c53a4712_Out_0, _Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2);
        float _Property_db14e0563c964d5db8b1c4b2265606be_Out_0 = _maxY;
        float _Property_f5f38a602035427790bc38042352fa9c_Out_0 = _minY;
        float _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2;
        Unity_Subtract_float(_Property_db14e0563c964d5db8b1c4b2265606be_Out_0, _Property_f5f38a602035427790bc38042352fa9c_Out_0, _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2);
        float _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2;
        Unity_Divide_float(_Subtract_6fd7a736220745bba1a5cbec733ab61a_Out_2, _Subtract_4f92e889fef84b05a5909bbf19452eb0_Out_2, _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2);
        float4 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGBA_4;
        float3 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGB_5;
        float2 _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6;
        Unity_Combine_float(_Divide_47fcd05fc8e54645acc854650c62d5c8_Out_2, _Divide_7b7ca0adcb17428bbcb49f79402a8799_Out_2, 0, 0, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGBA_4, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RGB_5, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6);
        float2 _Property_b83213148b3746ada7e8c109a157d5eb_Out_0 = _uv;
        float2 _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3;
        Unity_Branch_float2(_Property_59629b1305f34389b5ac2ae936e1d97a_Out_0, _Combine_915c9875a9ee480f9c7b730c3c4eb1f8_RG_6, _Property_b83213148b3746ada7e8c109a157d5eb_Out_0, _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3);
        UV_1 = _Branch_16a5a95b3da74e23adca4e7dbc5e5ec5_Out_3;
        }
        
        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Saturate_float4(float4 In, out float4 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Blend_Overlay_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            float4 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float4 result2 = 2.0 * Base * Blend;
            float4 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Blend_Multiply_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Distance_float2(float2 A, float2 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_DDXY_4c15eab26cdc46fcb709d614ebea98aa_float(float In, out float Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING)
                    #error 'DDXY' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            Out = abs(ddx(In)) + abs(ddy(In));
        }
        
        void Unity_InverseLerp_float(float A, float B, float T, out float Out)
        {
            Out = (T - A)/(B - A);
        }
        
        struct Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float
        {
        half4 uv0;
        };
        
        void SG_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float(float _fastAntyaliasing, UnityTexture2D _MainTex, Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float IN, out float OutVector1_1)
        {
        float _Property_df7f9d1e6f3644bcbb0570916415aa00_Out_0 = _fastAntyaliasing;
        UnityTexture2D _Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0 = _MainTex;
        float4 _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0 = SAMPLE_TEXTURE2D(_Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Point_Clamp).samplerstate, _Property_611d9fd7a78e4cdd9aab38f484d41551_Out_0.GetTransformedUV(IN.uv0.xy));
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_R_4 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.r;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_G_5 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.g;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_B_6 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.b;
        float _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7 = _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_RGBA_0.a;
        float _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1;
        Unity_DDXY_4c15eab26cdc46fcb709d614ebea98aa_float(_SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7, _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1);
        float _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2;
        Unity_Multiply_float_float(_Property_df7f9d1e6f3644bcbb0570916415aa00_Out_0, _DDXY_4c15eab26cdc46fcb709d614ebea98aa_Out_1, _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2);
        float _InverseLerp_394949f6e03a449798553a3a5429204a_Out_3;
        Unity_InverseLerp_float(1, 0, _Multiply_6d91a26fcdf749e4b829ba54d616b057_Out_2, _InverseLerp_394949f6e03a449798553a3a5429204a_Out_3);
        float _Multiply_645ac89284924907975d95479e12d3a8_Out_2;
        Unity_Multiply_float_float(_InverseLerp_394949f6e03a449798553a3a5429204a_Out_3, _SampleTexture2D_6414de9a33e1453ab594ed410293b7ae_A_7, _Multiply_645ac89284924907975d95479e12d3a8_Out_2);
        OutVector1_1 = _Multiply_645ac89284924907975d95479e12d3a8_Out_2;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Minimum_float(float A, float B, out float Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Blend_Multiply_float(float Base, float Blend, out float Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Maximum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void GetAlpha_float(float alphaBase, float light, float mlp, float minAlpha, out float4 res){
        res = min(1.0, max(minAlpha, alphaBase * (light/10) * mlp ));
        }
        
        struct Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float
        {
        float3 WorldSpacePosition;
        };
        
        void SG_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float(float _shadow_alpha, float _2DLightMLP, float _2DLightMinAlpha, float _onlyRenderIn2DLight, float4x4 _camProj, float4x4 _camWorldToCam, Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float IN, out float4 OutVector4_1)
        {
        float _Property_3e1a6e8cf6c7482ba86cf4139dd7c69e_Out_0 = _onlyRenderIn2DLight;
        float _Property_a24ed8de38314c7b91fc5501a78e320a_Out_0 = _shadow_alpha;
        float4x4 _Property_022e2f884d7542508c664e14f0ca6b89_Out_0 = _camProj;
        float4x4 _Property_ea154a1dce9248de95cc6ae98b5a49f4_Out_0 = _camWorldToCam;
        Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767;
        _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767.WorldSpacePosition = IN.WorldSpacePosition;
        float2 _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1;
        SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_022e2f884d7542508c664e14f0ca6b89_Out_0, _Property_ea154a1dce9248de95cc6ae98b5a49f4_Out_0, _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767, _CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1);
        float4 _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture0).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_R_4 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.r;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_G_5 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.g;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_B_6 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.b;
        float _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_A_7 = _SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0.a;
        float4 _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture1).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_R_4 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.r;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_G_5 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.g;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_B_6 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.b;
        float _SampleTexture2D_2b444726e97a4fe485f5707de07db041_A_7 = _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0.a;
        float4 _Maximum_600d428159ef4ae19733009631d8183e_Out_2;
        Unity_Maximum_float4(_SampleTexture2D_4e0078314aa4450385b0199455ab9e1c_RGBA_0, _SampleTexture2D_2b444726e97a4fe485f5707de07db041_RGBA_0, _Maximum_600d428159ef4ae19733009631d8183e_Out_2);
        float4 _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture2).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_R_4 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.r;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_G_5 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.g;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_B_6 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.b;
        float _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_A_7 = _SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0.a;
        float4 _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).tex, UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).samplerstate, UnityBuildTexture2DStructNoScale(_ShapeLightTexture3).GetTransformedUV(_CustomCameraScreenPosition_82cbc37243474de09084f02b8ce0c767_OutVector2_1));
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_R_4 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.r;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_G_5 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.g;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_B_6 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.b;
        float _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_A_7 = _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0.a;
        float4 _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2;
        Unity_Maximum_float4(_SampleTexture2D_138c97ec54304345bb5ff0624aee83ce_RGBA_0, _SampleTexture2D_c3e143458fc148c9a58f91d2a732109e_RGBA_0, _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2);
        float4 _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2;
        Unity_Maximum_float4(_Maximum_600d428159ef4ae19733009631d8183e_Out_2, _Maximum_77ef640a19444e6ab03d50ce85ded734_Out_2, _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2);
        float _Split_079a7389553a46f6b2e083de5ab0ec35_R_1 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[0];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_G_2 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[1];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_B_3 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[2];
        float _Split_079a7389553a46f6b2e083de5ab0ec35_A_4 = _Maximum_6ccadfe20af24dcbb242e3a5610944db_Out_2[3];
        float _Maximum_459027f3b3df4840b45351867af70ed1_Out_2;
        Unity_Maximum_float(_Split_079a7389553a46f6b2e083de5ab0ec35_B_3, _Split_079a7389553a46f6b2e083de5ab0ec35_G_2, _Maximum_459027f3b3df4840b45351867af70ed1_Out_2);
        float _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2;
        Unity_Maximum_float(_Maximum_459027f3b3df4840b45351867af70ed1_Out_2, _Split_079a7389553a46f6b2e083de5ab0ec35_R_1, _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2);
        float _Property_111bb76eab7a41619d344262fafa3895_Out_0 = _2DLightMLP;
        float _Property_070598259d31416e98256505bbb2b2de_Out_0 = _2DLightMinAlpha;
        float4 _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0;
        GetAlpha_float(_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0, _Maximum_1f5e3efd7e55402bb4207d07d72ae67e_Out_2, _Property_111bb76eab7a41619d344262fafa3895_Out_0, _Property_070598259d31416e98256505bbb2b2de_Out_0, _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0);
        float4 _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2;
        Unity_Multiply_float4_float4((_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0.xxxx), _GetAlphaCustomFunction_35a93a003f994602b0b895a47e34edec_res_0, _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2);
        float4 _Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3;
        Unity_Branch_float4(_Property_3e1a6e8cf6c7482ba86cf4139dd7c69e_Out_0, _Multiply_4cc0b6852891402eb2de7103e4d65d26_Out_2, (_Property_a24ed8de38314c7b91fc5501a78e320a_Out_0.xxxx), _Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3);
        float4 _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1;
        Unity_Saturate_float4(_Branch_9fc717f54abc4b9ab6ae88fb45ed5fb8_Out_3, _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1);
        OutVector4_1 = _Saturate_cbbb8341bf3c4b6e8ccd5f81a51d3f87_Out_1;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 NormalTS;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_266f14f34a3c468e99c82838d2327dc3_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_ae79c0121c0442198ad8a19481d850c8_Out_0 = IN.uv0;
            float _TexelSize_86396267145246039524276a2683b94d_Width_0 = _Property_266f14f34a3c468e99c82838d2327dc3_Out_0.texelSize.z;
            float _TexelSize_86396267145246039524276a2683b94d_Height_2 = _Property_266f14f34a3c468e99c82838d2327dc3_Out_0.texelSize.w;
            float2 _Vector2_adbf5eb295764b359c895d572e0af102_Out_0 = float2(_TexelSize_86396267145246039524276a2683b94d_Width_0, _TexelSize_86396267145246039524276a2683b94d_Height_2);
            float _Property_1a28fa3b35dd4e1193848f9373679a25_Out_0 = _blurArea;
            float _Property_840bd827292044b297da6b2206472467_Out_0 = _blurStrength;
            float2 _Property_747cea1fc384479a8ebbb6c75f25a52b_Out_0 = _blurDir;
            float4x4 _Property_e97cf15c65fe40818e58b226aa758447_Out_0 = _camProj;
            float4x4 _Property_52c5f0665044443c9ea9e1b36de2aa09_Out_0 = _camWorldToCam;
            Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075;
            _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075.WorldSpacePosition = IN.WorldSpacePosition;
            float2 _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1;
            SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_e97cf15c65fe40818e58b226aa758447_Out_0, _Property_52c5f0665044443c9ea9e1b36de2aa09_Out_0, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1);
            Bindings_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float _BoxBlur_146e8bef57604c11860c784ef32014b2;
            float4 _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1;
            SG_BoxBlur_a3cab29c0ab5d0b4280ba0a4cc486314_float(_Property_266f14f34a3c468e99c82838d2327dc3_Out_0, (_UV_ae79c0121c0442198ad8a19481d850c8_Out_0.xy), _Vector2_adbf5eb295764b359c895d572e0af102_Out_0, _Property_1a28fa3b35dd4e1193848f9373679a25_Out_0, _Property_840bd827292044b297da6b2206472467_Out_0, _Property_747cea1fc384479a8ebbb6c75f25a52b_Out_0, _CustomCameraScreenPosition_f1be9c71897a40a582dd4e3909442075_OutVector2_1, _BoxBlur_146e8bef57604c11860c784ef32014b2, _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1);
            float3 _Swizzle_fed63552fea74a82b1fe0ca74edd6df4_Out_1 = _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1.xyz;
            float3 _ColorspaceConversion_17aac4afc7e149f9bd1dbcdc53fc982e_Out_1;
            Unity_ColorspaceConversion_RGB_HSV_float(_Swizzle_fed63552fea74a82b1fe0ca74edd6df4_Out_1, _ColorspaceConversion_17aac4afc7e149f9bd1dbcdc53fc982e_Out_1);
            float _Split_58c8750204e647bbb36cd50373d931d0_R_1 = _ColorspaceConversion_17aac4afc7e149f9bd1dbcdc53fc982e_Out_1[0];
            float _Split_58c8750204e647bbb36cd50373d931d0_G_2 = _ColorspaceConversion_17aac4afc7e149f9bd1dbcdc53fc982e_Out_1[1];
            float _Split_58c8750204e647bbb36cd50373d931d0_B_3 = _ColorspaceConversion_17aac4afc7e149f9bd1dbcdc53fc982e_Out_1[2];
            float _Split_58c8750204e647bbb36cd50373d931d0_A_4 = 0;
            float _Property_a578b672ef8d499fb71fe871f97f5967_Out_0 = _shadowReflectiveness;
            float _Multiply_855c629b4232431faf5da90b7e1fecaf_Out_2;
            Unity_Multiply_float_float(_Property_a578b672ef8d499fb71fe871f97f5967_Out_0, _Split_58c8750204e647bbb36cd50373d931d0_B_3, _Multiply_855c629b4232431faf5da90b7e1fecaf_Out_2);
            float4 _Combine_8ff61a2c12b2488c9e4bd77966993c5f_RGBA_4;
            float3 _Combine_8ff61a2c12b2488c9e4bd77966993c5f_RGB_5;
            float2 _Combine_8ff61a2c12b2488c9e4bd77966993c5f_RG_6;
            Unity_Combine_float(_Split_58c8750204e647bbb36cd50373d931d0_R_1, _Split_58c8750204e647bbb36cd50373d931d0_G_2, _Multiply_855c629b4232431faf5da90b7e1fecaf_Out_2, 0, _Combine_8ff61a2c12b2488c9e4bd77966993c5f_RGBA_4, _Combine_8ff61a2c12b2488c9e4bd77966993c5f_RGB_5, _Combine_8ff61a2c12b2488c9e4bd77966993c5f_RG_6);
            float3 _ColorspaceConversion_17f1b3c9081a4bbb8b932084b94bec3c_Out_1;
            Unity_ColorspaceConversion_HSV_RGB_float(_Combine_8ff61a2c12b2488c9e4bd77966993c5f_RGB_5, _ColorspaceConversion_17f1b3c9081a4bbb8b932084b94bec3c_Out_1);
            float _Property_b669c699f87947f8a1994a3bfbc526b0_Out_0 = _shadowReflectiveness;
            float3 _Lerp_3d9460391c064094a9d8a8c0b5e5ee5a_Out_3;
            Unity_Lerp_float3(float3(0, 0, 0), _ColorspaceConversion_17f1b3c9081a4bbb8b932084b94bec3c_Out_1, (_Property_b669c699f87947f8a1994a3bfbc526b0_Out_0.xxx), _Lerp_3d9460391c064094a9d8a8c0b5e5ee5a_Out_3);
            float4 _Property_0cc90261cefa4060a85a5079cc35c8de_Out_0 = _shadowBaseColor;
            float3 _Add_3b9123a3910e40c19bb017a6a7688f39_Out_2;
            Unity_Add_float3(_Lerp_3d9460391c064094a9d8a8c0b5e5ee5a_Out_3, (_Property_0cc90261cefa4060a85a5079cc35c8de_Out_0.xyz), _Add_3b9123a3910e40c19bb017a6a7688f39_Out_2);
            float3 _Saturate_5084b46603f04a9ab574325246783dec_Out_1;
            Unity_Saturate_float3(_Add_3b9123a3910e40c19bb017a6a7688f39_Out_2, _Saturate_5084b46603f04a9ab574325246783dec_Out_1);
            float _Property_3f7b82f885f44557b465281f8981a5f2_Out_0 = _fakeRefraction;
            float _Property_f943282d6b89438bba06715ad06c2dfd_Out_0 = _shadowBaseAlpha;
            float4 _Property_bd156a3353cf4a5ea9ee80677f475bbd_Out_0 = _edgeColor;
            UnityTexture2D _Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_R_4 = _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_RGBA_0.r;
            float _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_G_5 = _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_RGBA_0.g;
            float _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_B_6 = _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_RGBA_0.b;
            float _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_A_7 = _SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_RGBA_0.a;
            float _DDXY_06eaa0d2fa7d4e1fa8820dc0c8697336_Out_1;
            Unity_DDXY_06eaa0d2fa7d4e1fa8820dc0c8697336_float(_SampleTexture2D_0569c75170be47ea89e50aaea6da9b3b_A_7, _DDXY_06eaa0d2fa7d4e1fa8820dc0c8697336_Out_1);
            float _Step_952b6b4b91ee4888b3689e780f4a2f99_Out_2;
            Unity_Step_float(0.2, _DDXY_06eaa0d2fa7d4e1fa8820dc0c8697336_Out_1, _Step_952b6b4b91ee4888b3689e780f4a2f99_Out_2);
            float4 _Multiply_1d24ec9d7dec4657b07215729ec61576_Out_2;
            Unity_Multiply_float4_float4(_Property_bd156a3353cf4a5ea9ee80677f475bbd_Out_0, (_Step_952b6b4b91ee4888b3689e780f4a2f99_Out_2.xxxx), _Multiply_1d24ec9d7dec4657b07215729ec61576_Out_2);
            float4 _Multiply_6d78c9e4af5f4530bdac2ce6a0a4f639_Out_2;
            Unity_Multiply_float4_float4((_Property_f943282d6b89438bba06715ad06c2dfd_Out_0.xxxx), _Multiply_1d24ec9d7dec4657b07215729ec61576_Out_2, _Multiply_6d78c9e4af5f4530bdac2ce6a0a4f639_Out_2);
            float4 _Branch_d9eeb1a612a2410e9208d631a6ec0087_Out_3;
            Unity_Branch_float4(_Property_3f7b82f885f44557b465281f8981a5f2_Out_0, _Multiply_6d78c9e4af5f4530bdac2ce6a0a4f639_Out_2, float4(0, 0, 0, 0), _Branch_d9eeb1a612a2410e9208d631a6ec0087_Out_3);
            float3 _Add_d2ad54b0bbee4e26ac3523f057019bfd_Out_2;
            Unity_Add_float3(_Saturate_5084b46603f04a9ab574325246783dec_Out_1, (_Branch_d9eeb1a612a2410e9208d631a6ec0087_Out_3.xyz), _Add_d2ad54b0bbee4e26ac3523f057019bfd_Out_2);
            float3 _Saturate_c4375e7e98c549c1adaed9e32ff3586a_Out_1;
            Unity_Saturate_float3(_Add_d2ad54b0bbee4e26ac3523f057019bfd_Out_2, _Saturate_c4375e7e98c549c1adaed9e32ff3586a_Out_1);
            float _Property_39a0c80a760d442e92412ca9c31ccaf5_Out_0 = _shadowBaseAlpha;
            float _Property_65c6a4cc5d374f13b91cd81a27486ba3_Out_0 = _shadowTexture;
            float _Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1 = _BoxBlur_146e8bef57604c11860c784ef32014b2_col_1.w;
            UnityTexture2D _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0 = UnityBuildTexture2DStructNoScale(_shadowTex);
            float4 _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.tex, _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.samplerstate, _Property_38ccd07db95f4e70a9cd601b1b281e87_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_R_4 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.r;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_G_5 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.g;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_B_6 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.b;
            float _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_A_7 = _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0.a;
            float4 _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2;
            Unity_Multiply_float4_float4((_Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1.xxxx), _SampleTexture2D_e08d610b7fc24ca3916d055416e5f2a9_RGBA_0, _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2);
            float4 _Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3;
            Unity_Branch_float4(_Property_65c6a4cc5d374f13b91cd81a27486ba3_Out_0, _Multiply_85373f120cd84a0c8693bba526382d6a_Out_2, (_Swizzle_d2102cae841c4014ba663b2de5828d40_Out_1.xxxx), _Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3);
            float _Property_269f6df3fbd447efaeeb85f3a462424a_Out_0 = _falloff;
            float _Property_02de571028bb4a16975e641e43976cd2_Out_0 = _fromSS;
            float4 _UV_db00e0a911d64679b4c6580b6b1418df_Out_0 = IN.uv0;
            float _Property_24bc71ec982a439ca0ddc1247924bbe0_Out_0 = _minX;
            float _Property_24635cb30088450b914780cf23c64e07_Out_0 = _maxX;
            float _Property_517af63683904c6aafb247552ff3a011_Out_0 = _minY;
            float _Property_9fc5fb11323f4477912a01e1f9c6ab76_Out_0 = _maxY;
            Bindings_getSpriteUV_28898200da561d54c95498da7ec1387b_float _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1;
            float2 _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1;
            SG_getSpriteUV_28898200da561d54c95498da7ec1387b_float(_Property_02de571028bb4a16975e641e43976cd2_Out_0, (_UV_db00e0a911d64679b4c6580b6b1418df_Out_0.xy), _Property_24bc71ec982a439ca0ddc1247924bbe0_Out_0, _Property_24635cb30088450b914780cf23c64e07_Out_0, _Property_517af63683904c6aafb247552ff3a011_Out_0, _Property_9fc5fb11323f4477912a01e1f9c6ab76_Out_0, _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1, _getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1);
            float _Property_38c07cfd50364af59198ace5a1218e1c_Out_0 = _shadowNarrowing;
            float2 _Vector2_30d73056b259424a903bb0260189385c_Out_0 = float2(0.5, _Property_38c07cfd50364af59198ace5a1218e1c_Out_0);
            float2 _Rotate_354f1e875f8142599da0f89a879950cf_Out_3;
            Unity_Rotate_Degrees_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, _Vector2_30d73056b259424a903bb0260189385c_Out_0, 180, _Rotate_354f1e875f8142599da0f89a879950cf_Out_3);
            float4 _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_Texture_1).GetTransformedUV(_Rotate_354f1e875f8142599da0f89a879950cf_Out_3));
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_R_4 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.r;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_G_5 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.g;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_B_6 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.b;
            float _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_A_7 = _SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0.a;
            float4 _Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2;
            Unity_Divide_float4(_SampleTexture2D_10c503309d274efa94b651712bf8f4fd_RGBA_0, float4(1, 1, 1, 1), _Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2);
            float2 _TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3;
            Unity_TilingAndOffset_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, float2 (1, 1), float2 (0, 0), _TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3);
            float _Property_3de54516355e446b941821236b3a5539_Out_0 = _shadowNarrowing;
            float2 _Vector2_5490d5e7275944b2a1d3e15aa999783d_Out_0 = float2(0.5, _Property_3de54516355e446b941821236b3a5539_Out_0);
            float2 _Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_01467d2c351d4dff86b824786d6fb6e5_Out_3, _Vector2_5490d5e7275944b2a1d3e15aa999783d_Out_0, 90, _Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3);
            float4 _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_Texture_1).GetTransformedUV(_Rotate_af205abfa0654ee3abea69b1edc07f61_Out_3));
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_R_4 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.r;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_G_5 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.g;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_B_6 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.b;
            float _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_A_7 = _SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0.a;
            float2 _TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3;
            Unity_TilingAndOffset_float(_getSpriteUV_72b57cedb9d84d03a033b8520e4d0ad1_UV_1, float2 (1, 1), float2 (0, 0), _TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3);
            float _Property_053ef645b525429eb8514144a5f0d8a5_Out_0 = _shadowNarrowing;
            float2 _Vector2_9e0a92a790e6479782cb7f44e5e39a96_Out_0 = float2(0.5, _Property_053ef645b525429eb8514144a5f0d8a5_Out_0);
            float2 _Rotate_937724de82cd4b709bafc850c9efdd35_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_10387f8b916248b98b5ef56802ab5523_Out_3, _Vector2_9e0a92a790e6479782cb7f44e5e39a96_Out_0, -90, _Rotate_937724de82cd4b709bafc850c9efdd35_Out_3);
            float4 _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_77f75e44f2544760b42279aead10266c_Texture_1).GetTransformedUV(_Rotate_937724de82cd4b709bafc850c9efdd35_Out_3));
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_R_4 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.r;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_G_5 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.g;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_B_6 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.b;
            float _SampleTexture2D_77f75e44f2544760b42279aead10266c_A_7 = _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0.a;
            float4 _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_5a55d9f116964d80bcb18095c620b968_RGBA_0, _SampleTexture2D_77f75e44f2544760b42279aead10266c_RGBA_0, _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2);
            float4 _Multiply_4274a6a328994084b1b182cd09384636_Out_2;
            Unity_Multiply_float4_float4(_Divide_abe85aa11fba468f84c3990a5b62bf5c_Out_2, _Multiply_5b074c9c680a4083ac78f26c80f92c78_Out_2, _Multiply_4274a6a328994084b1b182cd09384636_Out_2);
            float _Property_8846c22cbd2548d79b405c31433a0bf6_Out_0 = _shadowFalloff;
            float4 _Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2;
            Unity_Multiply_float4_float4(_Multiply_4274a6a328994084b1b182cd09384636_Out_2, (_Property_8846c22cbd2548d79b405c31433a0bf6_Out_0.xxxx), _Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2);
            float4 _Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1;
            Unity_Saturate_float4(_Multiply_abe0429a1f40472094b2a9ade33186e8_Out_2, _Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1);
            float4 _Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2;
            Unity_Multiply_float4_float4(_Saturate_bcc52883d0a14d7194c0a936e1aa970c_Out_1, float4(2, 2, 2, 2), _Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2);
            float _Property_8f9cd0c877224528832afbf49c0eca9c_Out_0 = _afrigesTex;
            float _Property_d3b4849aa43442b9b501c852f80974ee_Out_0 = _shadowBaseAlpha;
            float2 _TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.3, 0.3), (IN.WorldSpacePosition.xy), _TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3);
            float2 _Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3;
            Unity_Rotate_Degrees_float(_TilingAndOffset_7deca58ffbbc4071a1ff3638131d4e2e_Out_3, float2 (0.5, 0.5), 0, _Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3);
            float4 _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1).tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Mirror).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_Texture_1).GetTransformedUV(_Rotate_ee69691cc01e43f1b12a4b61d512f85b_Out_3));
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_R_4 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.r;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_G_5 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.g;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_B_6 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.b;
            float _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_A_7 = _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_RGBA_0.a;
            float _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2;
            Unity_Multiply_float_float(_Property_d3b4849aa43442b9b501c852f80974ee_Out_0, _SampleTexture2D_c90f6420c2914f638a9d93cd2bf70063_R_4, _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2);
            float _Branch_15f412beaf5e46b19f8226a5db075124_Out_3;
            Unity_Branch_float(_Property_8f9cd0c877224528832afbf49c0eca9c_Out_0, _Multiply_f1fab3da63ce4dc9bcdb8573bd248068_Out_2, 1, _Branch_15f412beaf5e46b19f8226a5db075124_Out_3);
            float4 _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2;
            Unity_Multiply_float4_float4(_Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2, (_Branch_15f412beaf5e46b19f8226a5db075124_Out_3.xxxx), _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2);
            float4 _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2;
            Unity_Blend_Overlay_float4(_Multiply_5257afd3de5b4aa6a590c4949ef50e1b_Out_2, _Multiply_1f54b7adea7e422a95545d851ab77aee_Out_2, _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2, 0.2);
            float4 _Branch_66a6d2861e6d4f6089053a6772d86451_Out_3;
            Unity_Branch_float4(_Property_269f6df3fbd447efaeeb85f3a462424a_Out_0, _Blend_fe05f47de2ff48a8b9f44696b05d39cb_Out_2, float4(1, 1, 1, 1), _Branch_66a6d2861e6d4f6089053a6772d86451_Out_3);
            float _Property_045f4a7a2af440bd8b474a9a895a430c_Out_0 = _vonroiTex;
            float _Property_c04500d7725947a69a1cf465b73beaf6_Out_0 = _shadowBaseAlpha;
            float2 _TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.3, 0.3), (IN.WorldSpacePosition.xy), _TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3);
            float _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3;
            float _Voronoi_5185d06e2788480f9f5edfeac380e38e_Cells_4;
            Unity_Voronoi_float(_TilingAndOffset_531d75456cec473ba781e4098f28c41f_Out_3, 2, 1, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Cells_4);
            float _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3;
            Unity_Smoothstep_float(0.3, 1, _Voronoi_5185d06e2788480f9f5edfeac380e38e_Out_3, _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3);
            float _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3;
            Unity_Smoothstep_float(0, 0.5, _Smoothstep_3bca535b2da74032bbc7dc603f732cc8_Out_3, _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3);
            float _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2;
            Unity_Multiply_float_float(_Property_c04500d7725947a69a1cf465b73beaf6_Out_0, _Smoothstep_a8a1abd1598248aabef9509d9eb4487c_Out_3, _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2);
            float _Branch_a08b046aadf043aa821d5d9e70298163_Out_3;
            Unity_Branch_float(_Property_045f4a7a2af440bd8b474a9a895a430c_Out_0, _Multiply_2ed86151a12740b8b6ebbcb747610222_Out_2, 1, _Branch_a08b046aadf043aa821d5d9e70298163_Out_3);
            float4 _Blend_16b43719a5d34dac880346881fe9f272_Out_2;
            Unity_Blend_Multiply_float4(_Branch_66a6d2861e6d4f6089053a6772d86451_Out_3, (_Branch_a08b046aadf043aa821d5d9e70298163_Out_3.xxxx), _Blend_16b43719a5d34dac880346881fe9f272_Out_2, 0.1);
            float4 _Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2;
            Unity_Multiply_float4_float4(_Branch_2b9c667e729a4c01bcf52f382e9726ba_Out_3, _Blend_16b43719a5d34dac880346881fe9f272_Out_2, _Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2);
            float _Property_1bc6b0136e3442f2bd0c835a17615a34_Out_0 = _directional;
            float _Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2;
            Unity_Comparison_Greater_float(_Property_1bc6b0136e3442f2bd0c835a17615a34_Out_0, 0.5, _Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2);
            float _Property_32038686d7c6415ba0e518addc902f38_Out_0 = _useClosestPointLightForDirection;
            float _Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2;
            Unity_Or_float(_Comparison_4ed4c9f0bb0b4c5eb55433aa5aa19af8_Out_2, _Property_32038686d7c6415ba0e518addc902f38_Out_0, _Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2);
            float2 _Swizzle_9179ff07d7164d409a2342edc50e4390_Out_1 = IN.WorldSpacePosition.xy;
            float3 _Property_414892493f164994ba130276c6cb2dc6_Out_0 = _source;
            float2 _Swizzle_aa67dcd65c5e4b98acb2bb10a34ef37d_Out_1 = _Property_414892493f164994ba130276c6cb2dc6_Out_0.xy;
            float _Distance_82ab97a70bec43dfab653173af856737_Out_2;
            Unity_Distance_float2(_Swizzle_9179ff07d7164d409a2342edc50e4390_Out_1, _Swizzle_aa67dcd65c5e4b98acb2bb10a34ef37d_Out_1, _Distance_82ab97a70bec43dfab653173af856737_Out_2);
            float2 _Property_9b36c1d04153475d95525b4c285bc80b_Out_0 = _distMinMax;
            float _Split_88cecf19cf4d4c149324206c388fe6cb_R_1 = _Property_9b36c1d04153475d95525b4c285bc80b_Out_0[0];
            float _Split_88cecf19cf4d4c149324206c388fe6cb_G_2 = _Property_9b36c1d04153475d95525b4c285bc80b_Out_0[1];
            float _Split_88cecf19cf4d4c149324206c388fe6cb_B_3 = 0;
            float _Split_88cecf19cf4d4c149324206c388fe6cb_A_4 = 0;
            float _Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3;
            Unity_Clamp_float(_Distance_82ab97a70bec43dfab653173af856737_Out_2, 0, _Split_88cecf19cf4d4c149324206c388fe6cb_G_2, _Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3);
            float2 _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0 = _distMinMax;
            float _Split_715f243a60c9433990660b04d84633e2_R_1 = _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0[0];
            float _Split_715f243a60c9433990660b04d84633e2_G_2 = _Property_2e160abd48104227b82dbdd67fdf44a4_Out_0[1];
            float _Split_715f243a60c9433990660b04d84633e2_B_3 = 0;
            float _Split_715f243a60c9433990660b04d84633e2_A_4 = 0;
            float _Divide_b4f326bea5de462a992c509de3e5e831_Out_2;
            Unity_Divide_float(_Clamp_7ffd18ba6ff4477f98f81a229ffed001_Out_3, _Split_715f243a60c9433990660b04d84633e2_G_2, _Divide_b4f326bea5de462a992c509de3e5e831_Out_2);
            float _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3;
            Unity_Lerp_float(0, 1, _Divide_b4f326bea5de462a992c509de3e5e831_Out_2, _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3);
            float _Branch_17569a76eab4481eb16fbe1782242f1d_Out_3;
            Unity_Branch_float(_Or_0c8f0b3d2b1d4ee791df9ff1f24e0d78_Out_2, 1, _Lerp_4197e5f1cfe445e0803eaecda8a90283_Out_3, _Branch_17569a76eab4481eb16fbe1782242f1d_Out_3);
            float4 _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2;
            Unity_Blend_Multiply_float4(_Multiply_56822b31fc134e0aae1a98116ae0f20f_Out_2, (_Branch_17569a76eab4481eb16fbe1782242f1d_Out_3.xxxx), _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2, 1);
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_R_1 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[0];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_G_2 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[1];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_B_3 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[2];
            float _Split_e085e2b7b0b9447cb31c3bedff43d4fa_A_4 = _Blend_0398d1474feb4ef9ac12da9ea4630be7_Out_2[3];
            float _Property_a440c1c925654a4eb8f15fca48f5aa3d_Out_0 = _fastAntyaliasing;
            Bindings_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a;
            _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a.uv0 = IN.uv0;
            float _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1;
            SG_FastAntyaliasing_4b2b204537cf1a548a9bb63f42425d53_float(_Property_a440c1c925654a4eb8f15fca48f5aa3d_Out_0, _Property_d8054547e4fa41f78f1ecfc2797ed455_Out_0, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1);
            float _Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2;
            Unity_Multiply_float_float(_Split_e085e2b7b0b9447cb31c3bedff43d4fa_R_1, _FastAntyaliasing_3df3e7ac11d54fe8b586f52fee8f032a_OutVector1_1, _Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2);
            float _Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0 = _sceneLighten;
            float3 _Property_a979b50a4dd341529f45439596b6ff98_Out_0 = _colorMlpRGB;
            float _Split_bd2a7871af334e818a970f83ab0fdce8_R_1 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[0];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_G_2 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[1];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_B_3 = _Property_a979b50a4dd341529f45439596b6ff98_Out_0[2];
            float _Split_bd2a7871af334e818a970f83ab0fdce8_A_4 = 0;
            UnityTexture2D _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0 = UnityBuildTexture2DStructNoScale(_RenderText);
            float4x4 _Property_668393ac9856480ba5e4de219cd36c78_Out_0 = _camProj;
            float4x4 _Property_e0169419f075483c9fa9548fe401a2fe_Out_0 = _camWorldToCam;
            Bindings_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd;
            _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd.WorldSpacePosition = IN.WorldSpacePosition;
            float2 _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1;
            SG_CustomCameraScreenPosition_c32ebc1bd4f0ef74a8fd1bfe0efa9e79_float(_Property_668393ac9856480ba5e4de219cd36c78_Out_0, _Property_e0169419f075483c9fa9548fe401a2fe_Out_0, _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd, _CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1);
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.tex, _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.samplerstate, _Property_1b8cc973b2cf4253a309b76a6427859c_Out_0.GetTransformedUV(_CustomCameraScreenPosition_e8a484fc646348a8801cdefebb76c4cd_OutVector2_1), 1);
            #endif
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_R_5 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.r;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_G_6 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.g;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_B_7 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.b;
            float _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_A_8 = _SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_RGBA_0.a;
            float _Remap_fef0fe01a3a44d209390feb636d87117_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_R_5, float2 (0, 1), float2 (0, 2), _Remap_fef0fe01a3a44d209390feb636d87117_Out_3);
            float _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1;
            Unity_OneMinus_float(_Remap_fef0fe01a3a44d209390feb636d87117_Out_3, _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1);
            float _Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_R_1, _OneMinus_f811c36c78f44584b37525ffbe80f5b7_Out_1, _Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2);
            float _Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_G_6, float2 (0, 1), float2 (0, 2), _Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3);
            float _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1;
            Unity_OneMinus_float(_Remap_8f3482c0e2cd429aa1336ec16f1e83a5_Out_3, _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1);
            float _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_G_2, _OneMinus_6483d972a58f4e97bd425040f90f4ae3_Out_1, _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2);
            float _Minimum_881608b72fe747f49bb49799d4218a36_Out_2;
            Unity_Minimum_float(_Multiply_9afb9e710bf54935a2f1830f534daf14_Out_2, _Multiply_2bc23acc1599493e9d5c39000f0695e6_Out_2, _Minimum_881608b72fe747f49bb49799d4218a36_Out_2);
            float _Remap_c579a88bcefd49558c8688613e80f533_Out_3;
            Unity_Remap_float(_SampleTexture2DLOD_484bf9ef42a347eda13ef1ad1c7a54ca_B_7, float2 (0, 1), float2 (0, 2), _Remap_c579a88bcefd49558c8688613e80f533_Out_3);
            float _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1;
            Unity_OneMinus_float(_Remap_c579a88bcefd49558c8688613e80f533_Out_3, _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1);
            float _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2;
            Unity_Multiply_float_float(_Split_bd2a7871af334e818a970f83ab0fdce8_B_3, _OneMinus_2a96c474e5d84030a6affa18b31c89cf_Out_1, _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2);
            float _Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2;
            Unity_Minimum_float(_Minimum_881608b72fe747f49bb49799d4218a36_Out_2, _Multiply_731ba8b8ef8648468605c8de2f0269a4_Out_2, _Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2);
            float _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1;
            Unity_Saturate_float(_Minimum_9aeb0ff020c8487eae17cc226104ff3b_Out_2, _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1);
            float _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3;
            Unity_Branch_float(_Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0, _Saturate_5e841e9711004e86b144fe7c4002a54d_Out_1, 0, _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3);
            float _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3;
            Unity_Branch_float(_Property_b9f9d7f17a8842c29ffb8a73a659b5e5_Out_0, 0.9, 0, _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3);
            float _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2;
            Unity_Blend_Multiply_float(_Multiply_1e6d441947574648a095d52ecf22c7e9_Out_2, _Branch_93284234ac3d45068471f4ff5a3ae109_Out_3, _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2, _Branch_39a77ae8a67d44759202658869bbbd6b_Out_3);
            float _Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2;
            Unity_Multiply_float_float(_Property_39a0c80a760d442e92412ca9c31ccaf5_Out_0, _Blend_3f1ba8d97a544f8a8158e64d16a70474_Out_2, _Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2);
            float _Property_5aaa24741fb4458496fadf63aabb26c7_Out_0 = _2DLightMLP;
            float _Property_664012205b8b47e3bddf2b78909fbdb5_Out_0 = _2DLightMinAlpha;
            float _Property_ee43ff1e651e4766a9d7825b4a41563e_Out_0 = _onlyRenderIn2DLight;
            float4x4 _Property_d9bbf4f126844f9691d1b659f2618f60_Out_0 = _camProj;
            float4x4 _Property_dcc5cca994d44486b344bbfaa27d94af_Out_0 = _camWorldToCam;
            Bindings_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99;
            _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99.WorldSpacePosition = IN.WorldSpacePosition;
            float4 _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1;
            SG_ShowInURP2DLight_b5c6407a06d23874f86ea021281ae4b8_float(_Multiply_9a3b1f696b9544cca4e0ea9ac809bff2_Out_2, _Property_5aaa24741fb4458496fadf63aabb26c7_Out_0, _Property_664012205b8b47e3bddf2b78909fbdb5_Out_0, _Property_ee43ff1e651e4766a9d7825b4a41563e_Out_0, _Property_d9bbf4f126844f9691d1b659f2618f60_Out_0, _Property_dcc5cca994d44486b344bbfaa27d94af_Out_0, _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99, _ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1);
            surface.BaseColor = _Saturate_c4375e7e98c549c1adaed9e32ff3586a_Out_1;
            surface.Alpha = (_ShowInURP2DLight_4593bb73716a4325be24b28c9a733f99_OutVector4_1).x;
            surface.NormalTS = IN.TangentSpaceNormal;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
            output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition =                         input.positionWS;
            output.uv0 =                                        input.texCoord0;
            output.uv1 =                                        input.texCoord1;
            output.uv2 =                                        input.texCoord2;
            output.uv3 =                                        input.texCoord3;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteForwardPass.hlsl"
        
            ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}
