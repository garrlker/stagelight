export default function createDraw(regl, commonGLSL, imageGLSL) {
  return regl({
    frag: `
    precision highp float;
    uniform vec3 iMouse, iResolution;
    uniform float iTime;
    uniform int iFrame;
    uniform sampler2D iChannel0;
    ${commonGLSL}
    ${imageGLSL}
    void main () {
      mainImage(gl_FragColor, gl_FragCoord.xy);
    }
  `
  });
};