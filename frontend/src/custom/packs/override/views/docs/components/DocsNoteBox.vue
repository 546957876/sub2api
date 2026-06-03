<template>
  <div
    class="docs-note px-4 py-4"
    :class="`docs-note-${props.tone}`"
  >
    <DocsTag :tone="tagTone">
      {{ props.title }}
    </DocsTag>
    <div class="docs-copy-dense docs-note-body mt-3">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import DocsTag from './DocsTag.vue'

const props = withDefaults(defineProps<{
  title: string
  tone?: 'accent' | 'info' | 'warning'
}>(), {
  tone: 'info'
})

const tagTone = computed(() => {
  switch (props.tone) {
    case 'warning':
      return 'warning'
    case 'accent':
      return 'accent'
    default:
      return 'neutral'
  }
})
</script>
