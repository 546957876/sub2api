<template>
  <div :class="boxed ? 'docs-surface-muted p-4' : ''">
    <h3 class="docs-method-title">{{ title }}</h3>
    <div class="docs-copy mt-3">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
withDefaults(defineProps<{
  title: string
  boxed?: boolean
}>(), {
  boxed: false
})
</script>
