<template>
  <details
    class="group rounded-[28px] border border-slate-200/80 bg-white/82 shadow-[0_20px_55px_rgba(15,23,42,0.06)] backdrop-blur-sm dark:border-white/10 dark:bg-white/[0.035] dark:shadow-[0_14px_36px_rgba(0,0,0,0.18)]"
    :open="defaultOpen"
  >
    <summary class="flex cursor-pointer list-none items-center justify-between gap-4 px-5 py-5 [&::-webkit-details-marker]:hidden">
      <div>
        <DocsTag
          v-if="badge"
          :tone="badgeTone"
          class="mb-3"
        >
          {{ badge }}
        </DocsTag>
        <h2 class="docs-heading">{{ title }}</h2>
        <p v-if="description" class="docs-copy-dense mt-2 max-w-3xl">
          {{ description }}
        </p>
      </div>

      <svg
        class="docs-text-faint h-5 w-5 shrink-0 transition duration-200 group-open:rotate-180"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
        stroke-width="2"
      >
        <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
      </svg>
    </summary>

    <div class="border-t border-slate-200/80 px-5 pb-5 pt-5 dark:border-white/10">
      <slot />
    </div>
  </details>
</template>

<script setup lang="ts">
import DocsTag from './DocsTag.vue'

withDefaults(defineProps<{
  title: string
  description?: string
  defaultOpen?: boolean
  badge?: string
  badgeTone?: 'neutral' | 'accent' | 'warning' | 'dark'
}>(), {
  description: '',
  defaultOpen: false,
  badge: '',
  badgeTone: 'neutral'
})
</script>
