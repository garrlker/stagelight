<script setup>
import { computed, defineEmits, ref, watch } from "vue";
import { useDevicesList, usePermission, useUserMedia } from "@vueuse/core";

const emit = defineEmits(["playAudio"]);

const audio = ref();

const microphoneAccess = usePermission("microphone");

const { audioInputs: microphones } = useDevicesList({
  requestPermissions: true,
});
const currentMicrophone = computed(() => microphones.value[0]?.deviceId);

const { stream, start } = useUserMedia({
  audioDeviceId: currentMicrophone,
  videoDeviceId: false,
});

watch(microphoneAccess, () => {
  console.log("Toggled Mic, ", microphoneAccess.value);
  if (microphoneAccess.value === "granted") {
    console.log("Start microphone");
    start();
  }
});

watch([stream, microphoneAccess], () => {
  console.log("Bla 1");
  if (stream.value) {
    console.log("Bla 2");
    console.log("Stream ", stream.value);

    let audioCtx = new AudioContext();
    let audioAnalyser = audioCtx.createAnalyser();

    audioCtx.createMediaStreamSource(stream.value).connect(audioAnalyser);
    emit("playAudio", { ctx: audioCtx, audioAnalyser });
  }
});

function startAudio() {
  // Load Song
  audio.value = new Audio("/BOCCHI THE ROCK! - Opening  Seishun Complex.mp3");

  // Create Audio Context and Freq Analyzer
  const audioCtx = new AudioContext();
  const source = audioCtx.createMediaElementSource(audio.value);
  const analyser = audioCtx.createAnalyser();

  // Connect Analyzer to audio
  source.connect(analyser);
  source.connect(audioCtx.destination);

  // Play audio and emit varialbe to parent
  audio.value.play();
  emit("playAudio", { ctx: audioCtx, audioAnalyser: analyser });
}

function pauseAudio() {
  audio.value.pause();
}
</script>

<template>
  <div>
    <button @click="startAudio">Play</button>
    <button @click="pauseAudio">Pause</button>
  </div>
</template>

<style scoped>
div {
  /* position: absolute;
  top: 4em;
  left: 4em; */
}
</style>
