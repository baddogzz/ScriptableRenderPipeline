#ifndef UNITY_PP_DEFINES_
#define UNITY_PP_DEFINES_

#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

#if !defined(HAS_ALPHA)
    #define CTYPE float3

    //Note: we use functions instead of defines for type safaty. The compiler should inline everything.
    CTYPE LOAD_CTYPE(TEXTURE2D_X(tex), float2 coords)
    {
        return LOAD_TEXTURE2D_X(tex, coords).xyz;
    }

    CTYPE SAMPLE_CTYPE_LOD(TEXTURE2D_X_PARAM(tex, smp), float2 coords, float lod)
    {
        return SAMPLE_TEXTURE2D_X_LOD(TEXTURE2D_X_ARGS(tex, smp), coords, lod).xyz;
    }

    CTYPE SAMPLE_CTYPE_BICUBIC(TEXTURE2D_X_PARAM(tex, smp), float2 coords, float4 texSize, float2 maxCoord, uint unused)
    {
        return SampleTexture2DBicubic(TEXTURE2D_X_ARGS(tex, smp), coords, texSize, maxCoord, unused).xyz;
    }

    #define FETCH_COLOR Fetch

#else

    #define CTYPE float4
    CTYPE LOAD_CTYPE(TEXTURE2D_X(tex), float2 coords)
    {
        return LOAD_TEXTURE2D_X(tex, coords);
    }

    CTYPE SAMPLE_CTYPE_LOD(TEXTURE2D_X_PARAM(tex, smp), float2 coords, float lod)
    {
        return SAMPLE_TEXTURE2D_X_LOD(TEXTURE2D_X_ARGS(tex, smp), coords, lod);
    }

    CTYPE SAMPLE_CTYPE_BICUBIC(TEXTURE2D_X_PARAM(tex, smp), float2 coords, float4 texSize, float2 maxCoord, uint slice)
    {
        return SampleTexture2DBicubic(TEXTURE2D_X_ARGS(tex, smp), coords, texSize, maxCoord, slice);
    }
    #define FETCH_COLOR Fetch4
#endif //HAS_ALPHA

#endif //UNITY_PP_DEFINES_
