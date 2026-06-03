<template>
  <DocsCodeBlock
    :label="label"
    :command="command"
  />
</template>

<script setup lang="ts">
import DocsCodeBlock from './docs/components/DocsCodeBlock.vue'

defineProps<{
  label: string
  command: string
}>()
</script>
