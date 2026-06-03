<template>
  <div class="docs-code-shell overflow-hidden">
    <div class="docs-code-toolbar flex flex-col gap-3 px-4 py-3 sm:flex-row sm:items-center sm:justify-between">
      <div class="flex min-w-0 items-center gap-3">
        <DocsTag
          tone="dark"
          size="xs"
          class="uppercase tracking-[0.18em]"
        >
          {{ label }}
        </DocsTag>
        <span
          v-if="hint"
          class="docs-copy-kicker min-w-0 truncate text-xs"
        >
          {{ hint }}
        </span>
      </div>

      <button
        type="button"
        class="docs-copy-action inline-flex items-center gap-2 self-start rounded-full px-3 py-1.5 text-xs font-medium transition"
        @click="copyCommand"
      >
        <Icon :name="copied ? 'check' : 'copy'" size="sm" />
        {{ copied ? copiedText : copyText }}
      </button>
    </div>

    <div
      class="docs-code-viewport"
      :style="viewportStyle"
    >
      <pre
        class="docs-code-text"
        :class="wrap ? 'docs-code-text-wrap' : 'docs-code-text-nowrap'"
      ><code>{{ command }}</code></pre>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import Icon from '@/components/icons/Icon.vue'
import DocsTag from './DocsTag.vue'

const props = withDefaults(defineProps<{
  label: string
  command: string
  hint?: string
  maxHeight?: string
  minHeight?: string
  wrap?: boolean
  copyText?: string
  copiedText?: string
}>(), {
  hint: '',
  maxHeight: 'min(24rem, 62vh)',
  minHeight: '0',
  wrap: false,
  copyText: '复制',
  copiedText: '已复制'
})

const copied = ref(false)

const viewportStyle = computed(() => ({
  maxHeight: props.maxHeight,
  minHeight: props.minHeight
}))

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
