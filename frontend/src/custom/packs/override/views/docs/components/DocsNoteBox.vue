<template>
  <div class="docs-note px-4 py-4 text-sm leading-7">
    <span class="docs-note-title font-semibold">{{ title }}</span>
    <span class="docs-copy-dense docs-note-body">
      <slot />
    </span>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  title: string
}>()
</script>
