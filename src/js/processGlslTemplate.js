export default function (glslTemplate) {
  return glslTemplate.replaceAll('texture', 'texture2D');
}