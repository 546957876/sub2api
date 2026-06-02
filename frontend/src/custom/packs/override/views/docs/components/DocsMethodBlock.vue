<template>
  <div :class="boxed ? 'rounded-2xl border border-slate-200 bg-slate-50/80 p-4 dark:border-white/8 dark:bg-white/[0.025]' : ''">
    <h3 class="text-xl font-semibold text-slate-900 dark:text-white">{{ title }}</h3>
    <div class="mt-3">
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
