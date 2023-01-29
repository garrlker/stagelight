struct Ray 
{
	vec3 position;
    vec3 direction;
    float totalDist;
};

float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}
    
float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xy)-t.x,p.z);
  return length(q)-t.y;
}

float sdRoundBox( vec3 p, vec3 b, float r )
{
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0)) - r;
}

float sdFlippedBox( vec3 p, vec3 b )
{
  vec3 d = abs(p) - b;
  return -(min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0)));
}

float sdStrangeBox( vec3 p, vec3 b )
{
    vec3 b2 = abs( b );
    vec3 p2 = abs( p );
	return b2.x + b2.y + b2.z - p2.x - p2.y - p2.z; 
}

float opU( float a, float b)
{
    return min( a, b );
}

// polynomial smooth min (k = 0.1);
float smin( float a, float b, float k )
{
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return mix( b, a, h ) - k*h*(1.0-h);
}

vec2 rot2D(vec2 p, float angle) 
{
    float s = sin(angle);
    float c = cos(angle);
    return p * mat2(c,s,-s,c);
}

float map( vec3 p )
{
    return opU( opU( smin( sdTorus( p + vec3( 0.0, -9.0*texture(iChannel0, vec2( 0.0, 0.0)).x+6.0/*2.0*sin(iTime)*/, 0.0 ), vec2( 2.0, 1.0 ) ), 
                sdRoundBox( p + vec3( 0.0, 4.7, 0.0 ), vec3( 3.0, 3.0, 3.0 ), 0.2 ), 1.8 ),
        			sdFlippedBox( p, vec3( 10.0 ) ) ), sdSphere( p + vec3( 0.0, 0.0, -7.0 ), 1.0 ) ) ;
	//return sdSphere( p + vec3( 0.0, 0.0, -4.0 ), 2.0 );
}

float intersect( Ray r, float t )
{
    const float maxDist = 8.0;
    const float epsilon = 0.005;
    float totalD = 0.0;
    for ( int i = 0; i < 48; i++ )
    {
   		float dist = map( r.position + r.direction * totalD * 0.995 );
        totalD += dist;
        if ( dist < epsilon || mod(t, 80.0) < float(i) ) break;
    //    r.position += dist* 0.995 * r.direction;
    }
    return totalD;//length( r.position );
}

float norm( float n) {
 	return n/2.0+0.5;   
}


vec3 calcNormal( vec3 p )
{
    vec3 eps = vec3(0.002,0.0,0.0);

	return normalize( vec3(
           map(p+eps.xyy) - map(p-eps.xyy),
           map(p+eps.yxy) - map(p-eps.yxy),
           map(p+eps.yyx) - map(p-eps.yyx) ) );  
}

float nrand( float n )
{
	return fract(sin( n * 43758.5453 ) );
}

vec3 vecRand( vec3 v )
{
    return vec3( nrand( v.x ), nrand( v.y ), nrand( v.z ) );   
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float t = iTime;
    
    if (iFrame < 3) t = 12.0;
    
    vec3 light = normalize(vec3( 0.7, 0.3, -0.5));
    
    vec3 pLight = vec3( 0.0, 0.0, 7.0 );
    
    vec2 uv = ( fragCoord / iResolution.xy ) * 2.0 - 1.0;
    uv.x *= iResolution.x / iResolution.y; 
    
    float amp = texture(iChannel0, vec2( 0.01, 0.0)).x;
    if (iFrame < 3) amp = 1.0;
    float soft = texture(iChannel0, vec2( 0.0, 0.0)).x;
    if (iFrame < 3) soft = 5.1;
   
    vec3 color = vec3( 0.0 );
    
    Ray ray = Ray( vec3( 0.0, 0.0, -5.0 ), normalize( vec3( uv, 1.2 ) ), 0.0 );
    ray.position.xz = rot2D( ray.position.xz, iMouse.z > 0.0 ? iMouse.x/50.0 : t/4.0 );
    ray.direction.xz = rot2D( ray.direction.xz, iMouse.z > 0.0 ? iMouse.x/50.0 : t/4.0 );
    
    ray.position.yz = rot2D( ray.position.yz, iMouse.z > 0.0 ? iMouse.y/50.0 + iResolution.y/2.0 : 0.0 );
    ray.direction.yz = rot2D( ray.direction.yz, iMouse.z > 0.0 ? iMouse.y/50.0 + iResolution.y/2.0 : 0.0 );
    
    for (int bounce = 0; bounce < 8; bounce++) 
    {
    	
        float d = intersect( ray, t );
   		ray.position += ray.direction * d;
        ray.totalDist += d;
        
        if ( distance( ray.position, pLight ) < 1.05 || soft * soft * soft * 8.0 < float(bounce) ) {
            color += 0.8;
            break;
      	}
    
 //   if ( length( ray.position ) < 25.0 ) {
        vec3 normal = calcNormal( ray.position );
        
        vec3 rand = vec3(0.0);
        
        rand = vecRand( ray.direction * ray.position + iTime) - 0.5;
        
        ray.direction = reflect( ray.direction, normal );
        ray.direction = normalize( ray.direction + 0.0*rand );
        ray.position += 0.15 * ray.direction;
        t += float(bounce);
         color = mix( color, vec3( norm(sin(t)), norm(sin(t*0.4832)), norm(sin(0.83625*t))) * dot( normal, light ), 0.7 );
         color += 0.05;
//    }
        
    } 
        
       
    vec3 val = vec3(((color.r + color.g + color.b) / 3.0));

    if (fragCoord.x < 3.0) {
        fragColor = vec4(mix( amp, texture( iChannel0, vec2(0.0)).x, 0.8));
    } else {
		fragColor = mix( vec4( val, 1.0 ), vec4( color, 1.0 ), pow(amp, 3.0)*3.0) ;
    }
//    fragColor = vec4( color, 1.0 );
}