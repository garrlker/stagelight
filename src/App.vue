<script setup>
import { ref, provide } from "vue";
import * as reglFunction from "regl";
import webgl2 from "./js/regl-webgl2-shim.js";
import simple from "./shaders/simple.glsl";
import soundEclipse from "./shaders/soundEclipse.glsl";
import synthwaves from "./shaders/synthwaves.glsl";
import waves from "./shaders/waves.glsl";
import rainbowdonut from "./shaders/rainbowdonut.glsl";

import createReglToShadertoyMap from "./js/configureMap.js";
import createDraw from "./js/drawImage.js";
import { analyser } from "regl-audio";
import processGlslTemplate from "./js/processGlslTemplate.js";
import AudioController from "./components/AudioController.vue";

let startRendering = false;
const glCanvas = ref(null);
const regl = webgl2.overrideContextType(() =>
  reglFunction({
    container: glCanvas.value,
    extensions: [
      "WEBGL_draw_buffers",
      "OES_texture_float",
      "OES_texture_float_linear",
      "OES_texture_half_float",
      "ANGLE_instanced_arrays",
    ],
  })
);

provide("regl", regl);
let spectogramAnalysisTexture = (fn) => fn();

function handleAudioContext(payload) {
  const { audioAnalyser } = payload;
  spectogramAnalysisTexture = analyser({ regl, analyser: audioAnalyser });
  startRendering = true;
}

const processedTemplate = processGlslTemplate(waves);

const drawAudioShader = createDraw(regl, processedTemplate, ``);
const shaderToyEnvironmentShim = createReglToShadertoyMap(regl);

{
  regl.frame(() => {
    if (startRendering) {
      spectogramAnalysisTexture(() => {
        shaderToyEnvironmentShim(() => {
          drawAudioShader();
        });
      });
    }
  });
}
</script>

<template>
  <div class="viz" ref="glCanvas"></div>
  <div class="overlay">
    <AudioController @playAudio="handleAudioContext"></AudioController>
  </div>
</template>

<style>
html,
body,
#app {
  margin: 0;
  height: 100%;
  background-color: black;
}
.viz {
  width: 100%;
  height: 100%;
}
.overlay {
  z-index: 1;
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0px;
  left: 0px;
}
</style>
