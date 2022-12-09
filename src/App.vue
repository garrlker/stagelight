<script setup>
import { computed, ref, watch } from "vue";
import * as reglFunction from "regl";
import webgl2 from "./webgl2-compat.js";
import simple from "./shaders/simple.glsl";
import soundEclipse from "./shaders/soundEclipse.glsl";
import synthwaves from "./shaders/synthwaves.glsl";
import waves from "./shaders/waves.glsl";
import createMap from "./js/configureMap.js";
import createDraw from "./js/drawImage.js";
import { analyser } from "regl-audio";
import { useDevicesList, useUserMedia } from "@vueuse/core";
import processGlslTemplate from "./js/processGlslTemplate.js";

let startRendering = false;
const vizcontainer = ref(null);
const regl = webgl2.overrideContextType(() =>
  reglFunction({
    container: vizcontainer.value,
    extensions: [
      "WEBGL_draw_buffers",
      "OES_texture_float",
      "OES_texture_float_linear",
      "OES_texture_half_float",
      "ANGLE_instanced_arrays",
    ],
  })
);

const { audioInputs: microphones } = useDevicesList({
  requestPermissions: true,
});

console.log(microphones.value);

const currentMicrophone = computed(() => microphones.value[0]?.deviceId);

const { stream, start } = useUserMedia({
  audioDeviceId: currentMicrophone,
});

start();

const audioCtx = new AudioContext({
  latencyHint: 0,
});
audioCtx.fftSize = 16;

let audioAnalyzer = audioCtx.createAnalyser();
let audioCmd = (fnc) => fnc();

watch(stream, () => {
  console.log("hi", stream.value);
  if (stream.value) {
    console.log("Stream ", stream.value);
    audioCtx.createMediaStreamSource(stream.value).connect(audioAnalyzer);
    console.log(audioAnalyzer);
    console.log("ctx", audioCtx);
    analyser.minDecibels = -90;
    analyser.maxDecibels = -10;
    analyser.smoothingTimeConstant = 0.85;
    analyser.fftSize = 16;
    console.log("analyser", audioAnalyzer);
    audioCmd = analyser({ regl, analyser: audioAnalyzer });
    // console.log("cmd", audioCmd)

    // const audio = new Audio();
    // audio.autoplay = true;
    // audio.srcObject = stream.value;
    startRendering = true;
  }
});

console.log(stream.value);

// const distortion = audioCtx.createWaveShaper();
// const gainNode = audioCtx.createGain();
// const biquadFilter = audioCtx.createBiquadFilter();
// const convolver = audioCtx.createConvolver();

// const echoDelay = createEchoDelayEffect(audioCtx);

const processedTemplate = processGlslTemplate(soundEclipse);

const drawImage = createDraw(regl, processedTemplate, ``);
const configureMap = createMap(regl);

{
  regl.frame(() => {
    if (startRendering) {
      audioCmd(() => {
        configureMap(() => {
          drawImage();
        });
      });
    }
  });
}
</script>

<template>
  <div class="viz" ref="vizcontainer"></div>
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
</style>
