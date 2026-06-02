<script setup lang="ts">
import DefaultHomeView from '@/views/HomeView.vue'
import { getCustomPageOverride } from '@/custom/active'

const HomeOverride = getCustomPageOverride('home')
</script>

<template>
  <component :is="HomeOverride || DefaultHomeView" />
</template>
