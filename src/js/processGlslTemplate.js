/**
 * 
 * @param {String} glslTemplate 
 * @returns Processed template string modified to run on webgl1
 */
export default function (glslTemplate) {
  return glslTemplate.replaceAll('texture', 'texture2D');
}