#version 300 es

// This is a fragment shader. If you've opened this file first, please
// open and read lambert.vert.glsl before reading on.
// Unlike the vertex shader, the fragment shader actually does compute
// the shading of geometry. For every pixel in your program's output
// screen, the fragment shader is run for every bit of geometry that
// particular pixel overlaps. By implicitly interpolating the position
// data passed into the fragment shader by the vertex shader, the fragment shader
// can compute what color to apply to its pixel based on things like vertex
// position, light position, and vertex color.
precision highp float;

uniform vec4 u_branchColor;
uniform vec4 u_leafColor;
uniform vec4 u_flowerColor;

uniform sampler2D u_DiffuseMap;

// These are the interpolated values out of the rasterizer, so you can't know
// their specific values without knowing the vertices that contributed to them
in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;
in vec2 fs_Uv;

out vec4 out_Col; // This is the final output color that you will see on your
                  // screen for the pixel that is currently being processed.



void main()
{
    // Material base color (before shading)
        vec4 diffuseColor;
        
        //vec4 NormalMap = texture(u_DiffuseMap, fs_Uv);

        //branch
        if(fs_Col.x < 1.5)
        {
            diffuseColor = u_branchColor;
        }
        else if(fs_Col.x < 2.5)
        {            
            diffuseColor = mix(vec4(u_leafColor.xyz * 0.3, 1.0), u_leafColor, pow( fs_Uv.x, 1.0));
        }
        else if(fs_Col.x < 3.5)
        {
            diffuseColor = mix(u_flowerColor, vec4(u_flowerColor.x * 1.5, u_flowerColor.y * 0.5, u_flowerColor.z, 1.0), pow(1.0 - fs_Uv.y, 2.0));
        }
        
        

        // Calculate the diffuse term for Lambert shading
        float diffuseTerm = dot(normalize(fs_Nor.xyz), normalize(fs_LightVec.xyz));
        // Avoid negative lighting values
        //diffuseTerm = abs(diffuseTerm);
        diffuseTerm = clamp(diffuseTerm, 0.0, 1.0);

        float ambientTerm = 0.2;

        float lightIntensity = diffuseTerm + ambientTerm;   //Add a small float value to the color multiplier
                                                            //to simulate ambient lighting. This ensures that faces that are not
                                                            //lit by our point light are not completely black.

        // Compute final shaded color
        out_Col = vec4(diffuseColor.rgb * lightIntensity, diffuseColor.a);

        //out_Col = vec4(fs_Uv, 0.0, diffuseColor.a);
        
}
