<template>
  <PublicSiteLayout>
    <main class="docs-theme relative isolate overflow-hidden bg-slate-50 dark:bg-[#08111d]">
      <div class="absolute inset-0 bg-[linear-gradient(180deg,rgba(248,250,252,0.94)_0%,rgba(248,250,252,0.72)_18%,rgba(241,245,249,0.92)_100%)] dark:bg-[radial-gradient(circle_at_top,rgba(34,211,238,0.08),transparent_22%),linear-gradient(180deg,rgba(8,17,29,0.98)_0%,rgba(9,18,31,0.96)_100%)]"></div>
      <div class="absolute inset-0 opacity-[0.06] [background-image:linear-gradient(rgba(15,23,42,0.12)_1px,transparent_1px),linear-gradient(90deg,rgba(15,23,42,0.12)_1px,transparent_1px)] [background-size:40px_40px] dark:opacity-[0.05] dark:[background-image:linear-gradient(rgba(255,255,255,0.22)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.22)_1px,transparent_1px)]"></div>

      <section class="relative z-10 mx-auto max-w-[1480px] px-5 py-8 lg:px-8 lg:py-12">
        <div class="border-b border-slate-200/80 pb-8 dark:border-white/10">
          <div class="grid gap-8 xl:grid-cols-[minmax(0,1.2fr)_320px] xl:items-end">
            <div class="max-w-4xl">
              <p class="text-[11px] font-semibold uppercase tracking-[0.28em] text-cyan-700 dark:text-cyan-300/82">
                Integration Workspace
              </p>
              <h1 class="docs-page-title mt-4">
                接入文档
              </h1>
            </div>

            <div class="docs-shell-card p-5">
              <p class="docs-kicker text-[11px] font-semibold uppercase tracking-[0.24em]">
                推荐路径
              </p>
              <ol class="docs-text-body mt-4 space-y-3 text-sm leading-7">
                <li><span class="docs-text-strong font-semibold">1.</span> 先装 `Node.js`</li>
                <li><span class="docs-text-strong font-semibold">2.</span> 多工具用户优先用 `CC Switch`</li>
                <li><span class="docs-text-strong font-semibold">3.</span> 单一工具直接选对应教程</li>
              </ol>
            </div>
          </div>
        </div>

        <div class="mt-8 grid gap-10 xl:grid-cols-[300px_minmax(0,1fr)]">
          <aside class="xl:sticky xl:top-24 xl:self-start">
            <div class="docs-shell-card p-4">
              <div
                v-for="group in groupedDocs"
                :key="group.key"
                class="border-b border-slate-200/70 py-4 first:pt-0 last:border-b-0 last:pb-0 dark:border-white/8"
              >
                <p class="docs-kicker px-2 text-[11px] font-semibold uppercase tracking-[0.24em]">
                  {{ group.label }}
                </p>
                <div class="mt-3 space-y-2">
                  <button
                    v-for="item in group.items"
                    :key="item.key"
                    type="button"
                    class="w-full rounded-2xl border px-4 py-3 text-left transition"
                    :class="activeDoc === item.key
                      ? 'docs-nav-item-active'
                      : item.enabled
                        ? 'docs-nav-item-idle'
                        : 'docs-nav-item-disabled'"
                    :disabled="!item.enabled"
                    @click="item.enabled ? activeDoc = item.key : null"
                  >
                    <div class="flex items-start justify-between gap-3">
                      <div>
                        <div class="flex items-center gap-2">
                          <span class="text-sm font-semibold">{{ item.label }}</span>
                          <span
                            v-if="item.recommended"
                            class="rounded-full border border-current/15 px-2 py-0.5 text-[10px] font-semibold uppercase tracking-[0.16em] opacity-85"
                          >
                            推荐
                          </span>
                        </div>
                        <p
                          class="mt-1 text-xs leading-6"
                          :class="activeDoc === item.key ? 'text-white/90' : 'docs-sidebar-summary'"
                        >
                          {{ item.summary }}
                        </p>
                      </div>
                      <span
                        class="mt-0.5 text-[11px] font-medium uppercase tracking-[0.18em]"
                        :class="activeDoc === item.key ? 'docs-nav-status-active' : item.enabled ? 'docs-text-faint' : 'docs-nav-status-disabled'"
                      >
                        {{ activeDoc === item.key ? '当前' : item.enabled ? '' : '待添加' }}
                      </span>
                    </div>
                  </button>
                </div>
              </div>
            </div>
          </aside>

          <div class="min-w-0">
            <div class="mb-6 flex flex-wrap items-center gap-2 border-b border-slate-200/80 pb-5 dark:border-white/10">
              <span class="docs-chip-text rounded-full border border-slate-200 bg-white/70 px-3 py-1.5 text-[11px] font-semibold uppercase tracking-[0.18em] dark:border-white/14 dark:bg-white/[0.08]">
                {{ currentDocGroupLabel }}
              </span>
              <span
                v-if="currentDoc.recommended"
                class="docs-chip-accent rounded-full px-3 py-1.5 text-[11px] font-semibold uppercase tracking-[0.18em]"
              >
                Recommended
              </span>
              <span class="docs-chip-text rounded-full border border-slate-200 bg-white/70 px-3 py-1.5 text-[11px] font-semibold uppercase tracking-[0.18em] dark:border-white/14 dark:bg-white/[0.08]">
                直接复制可用配置
              </span>
            </div>

            <article class="max-w-5xl">
              <component :is="currentDoc.component" />
            </article>
          </div>
        </div>
      </section>
    </main>
  </PublicSiteLayout>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { docsRegistry } from './docs/registry'
import PublicSiteLayout from './PublicSiteLayout.vue'
import './docs/docs-theme.css'

const activeDoc = ref(docsRegistry[0]?.key ?? 'nodejs')

const currentDoc = computed(() => {
  return docsRegistry.find((item) => item.key === activeDoc.value) ?? docsRegistry[0]
})

const groupMeta = {
  setup: {
    key: 'setup',
    label: '准备环境'
  },
  management: {
    key: 'management',
    label: '统一管理'
  },
  tools: {
    key: 'tools',
    label: '直接接入'
  }
} as const

const groupedDocs = computed(() => {
  return Object.values(groupMeta).map((group) => ({
    ...group,
    items: docsRegistry.filter((item) => item.group === group.key)
  })).filter((group) => group.items.length > 0)
})

const currentDocGroupLabel = computed(() => groupMeta[currentDoc.value.group]?.label ?? '文档')
</script>
