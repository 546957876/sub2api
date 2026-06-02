<template>
  <div class="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-[0_18px_50px_rgba(15,23,42,0.06)] dark:border-white/8 dark:bg-[#101826] dark:shadow-none">
    <div class="flex flex-col gap-3 border-b border-slate-200 bg-slate-50 px-4 py-3 sm:flex-row sm:items-center sm:justify-between dark:border-white/8 dark:bg-[#0d1524]">
      <div class="flex items-center gap-2">
        <span class="h-2.5 w-2.5 rounded-full bg-rose-400/90"></span>
        <span class="h-2.5 w-2.5 rounded-full bg-amber-300/90"></span>
        <span class="h-2.5 w-2.5 rounded-full bg-emerald-400/90"></span>
        <span class="ml-2 text-xs uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ label }}</span>
      </div>
      <button
        type="button"
        class="inline-flex items-center gap-2 self-start rounded-full border border-slate-200 bg-white px-3 py-1.5 text-xs font-medium text-slate-600 transition hover:border-cyan-300 hover:text-cyan-700 dark:border-white/10 dark:bg-white/5 dark:text-white/84 dark:hover:border-white/18 dark:hover:text-white"
        @click="copyCommand"
      >
        <Icon :name="copied ? 'check' : 'copy'" size="sm" />
        {{ copied ? '已复制' : '复制' }}
      </button>
    </div>

    <pre class="overflow-x-auto whitespace-pre-wrap break-words px-4 py-4 text-xs leading-7 text-slate-800 sm:text-sm dark:text-slate-100"><code>{{ command }}</code></pre>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import Icon from '@/components/icons/Icon.vue'

const props = defineProps<{
  label: string
  command: string
}>()

const copied = ref(false)

async function copyCommand() {
  try {
    await navigator.clipboard.writeText(props.command)
    copied.value = true
    window.setTimeout(() => {
      copied.value = false
    }, 1600)
  } catch (error) {
    console.error('Failed to copy command:', error)
  }
}
</script>
