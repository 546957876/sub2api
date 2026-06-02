<template>
  <details
    class="group rounded-3xl border border-slate-200 bg-white/86 shadow-[0_20px_60px_rgba(15,23,42,0.08)] dark:border-white/8 dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.28)]"
    :open="defaultOpen"
  >
    <summary class="flex cursor-pointer list-none items-center justify-between gap-4 px-5 py-5 [&::-webkit-details-marker]:hidden">
      <div>
        <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">{{ title }}</h2>
        <p v-if="description" class="mt-2 text-sm leading-7 text-slate-600 dark:text-white/80">
          {{ description }}
        </p>
      </div>

      <svg
        class="h-5 w-5 shrink-0 text-slate-400 transition duration-200 group-open:rotate-180 dark:text-white/45"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
        stroke-width="2"
      >
        <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
      </svg>
    </summary>

    <div class="border-t border-slate-200 px-5 pb-5 pt-5 dark:border-white/8">
      <slot />
    </div>
  </details>
</template>

<script setup lang="ts">
withDefaults(defineProps<{
  title: string
  description?: string
  defaultOpen?: boolean
}>(), {
  description: '',
  defaultOpen: false
})
</script>
