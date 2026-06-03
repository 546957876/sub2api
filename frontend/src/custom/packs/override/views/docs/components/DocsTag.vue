<template>
  <span
    class="docs-tag"
    :class="[toneClass, sizeClass]"
  >
    <slot>{{ label }}</slot>
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(defineProps<{
  label?: string
  tone?: 'neutral' | 'accent' | 'warning' | 'dark'
  size?: 'xs' | 'sm' | 'md'
}>(), {
  label: '',
  tone: 'neutral',
  size: 'sm'
})

const toneClass = computed(() => `docs-tag-${props.tone}`)
const sizeClass = computed(() => `docs-tag-${props.size}`)
</script>
