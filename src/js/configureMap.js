/**
 *
 *  This function returns a regl draw command that maps internal regl context variables and uniforms into equivalent ShaderToy
 *  built-in uniforms. This is to allow most ShaderToy shaders to run "as is" without modification
 *
 *  Nest drawImage commands inside of this to inject the ShaderToy-like uniforms
 *
 * @param {Object} regl regl context
 * @returns Regl Draw Function
 */
export default function createReglToShadertoyMap(regl) {
  return regl({
    vert: `
    precision highp float;
    attribute vec2 uv;
    void main () {
      gl_Position = vec4(uv, 0, 1);
    }`,
    attributes: {
      uv: [-4, -4, 4, -4, 0, 4],
    },
    uniforms: {
      iMouse: [0, 0, 0],
      iResolution: (ctx) => [ctx.viewportWidth, ctx.viewportHeight, 0],
      iFrame: (ctx) => ctx.tick,
      iTime: (ctx) => ctx.tick / 60,
      iChannel0: (ctx) => ctx.freqTexture,
    },
    count: 3,
    depth: { enable: false }
  });
}