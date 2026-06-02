<template>
  <PublicSiteLayout>
    <main class="relative isolate overflow-hidden">
      <div class="absolute inset-0 bg-[radial-gradient(circle_at_0%_0%,rgba(15,23,42,0.06),transparent_24%),radial-gradient(circle_at_78%_18%,rgba(59,130,246,0.06),transparent_22%),linear-gradient(180deg,#f8fafc_0%,#f1f5f9_42%,#f8fafc_100%)] dark:bg-[radial-gradient(circle_at_0%_0%,rgba(45,212,191,0.16),transparent_26%),radial-gradient(circle_at_78%_18%,rgba(56,189,248,0.12),transparent_22%),linear-gradient(180deg,#07101d_0%,#081222_46%,#091426_100%)]"></div>
      <div class="absolute inset-0 opacity-[0.08] [background-image:linear-gradient(rgba(15,23,42,0.14)_1px,transparent_1px),linear-gradient(90deg,rgba(15,23,42,0.14)_1px,transparent_1px)] [background-size:44px_44px] dark:opacity-[0.07] dark:[background-image:linear-gradient(rgba(255,255,255,0.4)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.4)_1px,transparent_1px)]"></div>

      <section class="relative z-10 mx-auto max-w-[1440px] px-5 py-10 lg:px-8 lg:py-16">
        <div class="grid gap-6 lg:grid-cols-[280px_minmax(0,1fr)]">
          <aside class="rounded-3xl border border-slate-200 bg-white/86 p-4 shadow-[0_20px_60px_rgba(15,23,42,0.08)] dark:border-white/8 dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.28)]">
            <p class="px-2 text-xs uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">快速上手</p>
            <div class="mt-3 space-y-2">
              <button
                v-for="item in docsRegistry"
                :key="item.key"
                type="button"
                class="flex w-full items-center justify-between rounded-2xl px-4 py-3 text-left text-sm font-medium transition"
                :class="activeDoc === item.key
                  ? 'bg-amber-100 text-amber-900 shadow-[0_10px_24px_rgba(251,191,36,0.12)] dark:bg-[#3a2417] dark:text-white dark:shadow-none'
                  : 'bg-slate-50 text-slate-700 hover:bg-slate-100 dark:bg-white/5 dark:text-white/84 dark:hover:bg-white/8'"
                @click="activeDoc = item.key"
              >
                <span>{{ item.label }}</span>
                <span class="text-xs opacity-60">当前</span>
              </button>
            </div>
          </aside>

          <component :is="currentDoc.component" />
        </div>
      </section>
    </main>
  </PublicSiteLayout>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { docsRegistry } from './docs/registry'
import PublicSiteLayout from './PublicSiteLayout.vue'

const activeDoc = ref(docsRegistry[0]?.key ?? 'nodejs')

const currentDoc = computed(() => {
  return docsRegistry.find((item) => item.key === activeDoc.value) ?? docsRegistry[0]
})
</script>
