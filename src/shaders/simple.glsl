
  float size(float y,float line, float cm)
{
    line *= step(cm * sin(iTime), y);
    return line;
}

float line(float uv, float velocity, float amplitud, float range, float cm, float y)
{
    float low =  amplitud-abs(cos(iTime/velocity))*range;
    float middle = low + 0.001;
    float upper = low + 0.01;
    
    float lin = smoothstep(low,middle, uv) - smoothstep(middle, upper, uv);
    
    //Height Line
    lin = size(y, lin, cm);
    
    //HightDefinition
    lin = step(0.1, lin);
    
    return lin;
}

vec3 addLine(vec3 col, float line, vec3 color)
{
    return mix(col, color * cos(iTime), line);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy/iResolution.xy;

    vec3 col = mix(vec3(0.2, 0.5, 0.7), vec3(1., 1., 0.6), uv.x);
    
    //Vertical lines
    float line1 = line(uv.x, 3., 1., 0.9, 0.6, uv.y);
    float line2 = line(uv.x, 1., 0.5, 0.7, 0.9, uv.y);
    float line3 = line(uv.x, 1.5, 0.9, 0.9, 0.444, uv.y);
    float line4 = line(uv.x, 1.2, 0.9, 0.6, 0.7, uv.y);
    float line5 = line(uv.x, 0.8, 0.9, 0.946, 0.5, uv.y);
    float line6 = line(uv.x, 2.5, 0.92, 0.75, 0.2, uv.y);
    float line7 = line(uv.x, 1.8, 0.77, 0.25, 0.386, uv.y);
    float line8 = line(uv.x, 1.2, 0.77, 0.25, 0.586, uv.y);
    float line9 = line(uv.x, 2.8, 0.77, 0.25, 0.4, uv.y);
    float line10 = line(uv.x, 1.8, 0.67, 0.25, 0.686, uv.y);
    float line11 = line(uv.x, 6.8, 0.77, 0.25, 1.86, uv.y);
    float line12 = line(uv.x, 3.8, 0.77, 0.25, 0.286, uv.y);
    float line13 = line(uv.x, 4.8, 0.77, 0.25, 0.286, uv.y);
    
    vec4 iMouse = vec4(0.0,0.0,0.0,0.0);

    //Horizontal lines
    float lineH1 = line(uv.y, 2., 1., 0.9, 0.6, uv.x);
    float lineH2 = line(uv.y, 6., 0.5, 0.7, 0.9, uv.x);
    float lineH3 = line(uv.y, 3.5, 0.9, 0.9, 0.444, uv.x);
    float lineH4 = line(uv.y, 3.2, 0.9, 0.6, 0.7, uv.x);
    float lineH5 = line(uv.y, 6.8, 0.9, 0.946, 0.5, uv.x);
    float lineH6 = line(uv.y, 0.5, 0.92, 0.75, 0.2, uv.x);
    float lineH7 = line(uv.y, 6.8, 0.77, 0.25, 0.386, uv.x);
    float lineH8 = line(uv.y, 4.2, 0.77, 0.25, 0.586, uv.x);
    float lineH9 = line(uv.y, 7.4, 0.77, 0.25, 0.4, uv.x);
    float lineH10 = line(uv.y, 5.8, 0.67, 0.25, 0.686, uv.x);
    float lineH11 = line(uv.y, 6.6, 0.77, 0.25, 1.86, uv.x);
    float lineH12 = line(uv.y, 3.5, 0.77, 0.25, 0.286, uv.x);
    float lineH13 = line(iMouse.x, 5.8, 0.77, 0.25, 0.286, uv.x);
    
    //Paint Lines
    col = addLine(col, line1, vec3(0., 1., 0.));
    col = addLine(col, line2, vec3(0.3, 0., 0.6));
    col = addLine(col, line3, vec3(0.74, 0.2, 0.87));
    col = addLine(col, line4, vec3(0.1, 0.54, 0.26));
    col = addLine(col, line5, vec3(0.74, 0., 0.));
    col = addLine(col, line6, vec3(0.23, 0.3, 0.62));
    col = addLine(col, line7, vec3(0.31, 0.4, 0.455));
    col = addLine(col, line8, vec3(0.91, 0.7, 0.5));
    col = addLine(col, line9, vec3(0.71, 0.2, 0.25));
    col = addLine(col, line10, vec3(0.21, 0.4, 0.12));
    col = addLine(col, line11, vec3(0.61, 0.9, 0.54));
    col = addLine(col, line12, vec3(0.11, 0.4, 0.65));
    col = addLine(col, line13, vec3(0.41, 0.6, 0.32));
    
    col = addLine(col, lineH1, vec3(0., 1., 0.));
    col = addLine(col, lineH2, vec3(0.3, 0., 0.6));
    col = addLine(col, lineH3, vec3(0.74, 0.2, 0.87));
    col = addLine(col, lineH4, vec3(0.1, 0.54, 0.26));
    col = addLine(col, lineH5, vec3(0.74, 0., 0.));
    col = addLine(col, lineH6, vec3(0.23, 0.3, 0.62));
    col = addLine(col, lineH7, vec3(0.31, 0.4, 0.455));
    col = addLine(col, lineH8, vec3(0.91, 0.7, 0.5));
    col = addLine(col, lineH9, vec3(0.71, 0.2, 0.25));
    col = addLine(col, lineH10, vec3(0.21, 0.4, 0.12));
    col = addLine(col, lineH11, vec3(0.61, 0.9, 0.54));
    col = addLine(col, lineH12, vec3(0.11, 0.4, 0.65));
    col = addLine(col, lineH13, vec3(0.41, 0.6, 0.32));

    // Output to screen
    fragColor = vec4(col,1.0);
}