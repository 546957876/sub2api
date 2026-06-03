<template>
  <div class="docs-code-shell overflow-hidden">
    <div class="docs-code-toolbar flex flex-col gap-3 px-4 py-3 sm:flex-row sm:items-center sm:justify-between">
      <div class="flex items-center gap-3">
        <span class="docs-copy-kicker text-[11px] uppercase tracking-[0.22em]">{{ label }}</span>
      </div>
      <button
        type="button"
        class="docs-copy-action inline-flex items-center gap-2 self-start rounded-full px-3 py-1.5 text-xs font-medium transition"
        @click="copyCommand"
      >
        <Icon :name="copied ? 'check' : 'copy'" size="sm" />
        {{ copied ? '已复制' : '复制' }}
      </button>
    </div>

    <pre class="docs-code-text overflow-x-auto whitespace-pre-wrap break-words px-4 py-4 text-xs leading-7 sm:text-sm"><code>{{ command }}</code></pre>
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
