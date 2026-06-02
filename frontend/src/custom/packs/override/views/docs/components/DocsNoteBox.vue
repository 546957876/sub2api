<template>
  <div class="rounded-2xl border border-cyan-500/22 bg-cyan-500/10 px-4 py-4 text-sm leading-7 text-slate-800 dark:border-cyan-400/28 dark:bg-cyan-400/14 dark:text-slate-50">
    <span class="font-semibold text-cyan-800 dark:text-cyan-200">{{ title }}</span>
    <span class="text-slate-800 dark:text-slate-50">
      <slot />
    </span>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  title: string
}>()
</script>
