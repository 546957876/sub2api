<template>
  <Teleport to="body">
    <Transition name="popup-fade">
      <div
        v-if="currentAnnouncement"
        class="fixed inset-0 z-[130] flex items-start justify-center overflow-y-auto bg-gradient-to-br from-black/70 via-black/60 to-black/70 p-4 pt-[8vh] backdrop-blur-md"
      >
        <div
          class="w-full max-w-[680px] overflow-hidden rounded-3xl bg-white shadow-2xl ring-1 ring-black/5 dark:bg-dark-800 dark:ring-white/10"
          @click.stop
        >
          <div class="relative overflow-hidden border-b border-cyan-100/80 bg-gradient-to-br from-cyan-50/80 via-sky-50/50 to-blue-50/30 px-8 py-6 dark:border-dark-700/50 dark:from-cyan-900/20 dark:via-sky-900/10 dark:to-blue-900/5">
            <div class="absolute right-0 top-0 h-full w-64 bg-gradient-to-l from-cyan-100/30 to-transparent dark:from-cyan-900/20"></div>
            <div class="absolute -right-8 -top-8 h-32 w-32 rounded-full bg-gradient-to-br from-cyan-400/20 to-blue-500/20 blur-3xl"></div>
            <div class="absolute -left-4 -bottom-4 h-24 w-24 rounded-full bg-gradient-to-tr from-sky-400/20 to-cyan-500/20 blur-2xl"></div>

            <div class="relative z-10">
              <div class="mb-3 flex items-center gap-2">
                <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-cyan-500 to-blue-600 text-white shadow-lg shadow-cyan-500/30">
                  <Icon name="bell" size="sm" />
                </div>
                <span class="inline-flex items-center rounded-lg bg-gradient-to-r from-cyan-500 to-blue-600 px-2.5 py-1 text-xs font-medium text-white shadow-lg shadow-cyan-500/30">
                  最新公告
                </span>
              </div>

              <h2 class="mb-2 text-2xl font-bold leading-tight text-gray-900 dark:text-white">
                {{ currentAnnouncement.title }}
              </h2>

              <div class="flex items-center gap-1.5 text-sm text-gray-600 dark:text-gray-400">
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <time>{{ formatRelativeWithDateTime(currentAnnouncement.created_at) }}</time>
              </div>
            </div>
          </div>

          <div class="max-h-[50vh] overflow-y-auto bg-white px-8 py-8 dark:bg-dark-800">
            <div class="relative">
              <div class="absolute bottom-0 left-0 top-0 w-1 rounded-full bg-gradient-to-b from-cyan-500 via-sky-500 to-blue-500"></div>
              <div class="pl-6">
                <div
                  class="markdown-body prose prose-sm max-w-none dark:prose-invert"
                  v-html="renderedContent"
                ></div>
              </div>
            </div>
          </div>

          <div class="border-t border-gray-100 bg-gray-50/50 px-8 py-5 dark:border-dark-700 dark:bg-dark-900/30">
            <div class="flex items-center justify-between gap-3">
              <p class="text-xs text-gray-500 dark:text-gray-400">
                本次访问已显示最新公告。
              </p>
              <button
                @click="dismiss"
                class="rounded-xl bg-gradient-to-r from-cyan-500 to-blue-600 px-6 py-2.5 text-sm font-medium text-white shadow-lg shadow-cyan-500/30 transition-all hover:shadow-xl hover:scale-105"
              >
                我知道了
              </button>
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { marked } from 'marked'
import DOMPurify from 'dompurify'
import Icon from '@/components/icons/Icon.vue'
import { announcementsAPI } from '@/api'
import { useAuthStore } from '@/stores'
import { formatRelativeWithDateTime } from '@/utils/format'
import type { UserAnnouncement } from '@/types'

const authStore = useAuthStore()

const latestAnnouncement = ref<UserAnnouncement | null>(null)
const currentAnnouncement = ref<UserAnnouncement | null>(null)
const hasLoaded = ref(false)

marked.setOptions({
  breaks: true,
  gfm: true,
})

const renderedContent = computed(() => {
  const content = currentAnnouncement.value?.content
  if (!content) return ''
  const html = marked.parse(content) as string
  return DOMPurify.sanitize(html)
})

function maybeShowLatestAnnouncement() {
  if (!latestAnnouncement.value) return
  currentAnnouncement.value = latestAnnouncement.value
}

async function loadLatestAnnouncement() {
  try {
    const announcements = await announcementsAPI.list(false)
    latestAnnouncement.value = announcements[0] ?? null
    hasLoaded.value = true
    maybeShowLatestAnnouncement()
  } catch (error) {
    console.error('Failed to load latest announcement visit popup:', error)
  }
}

function dismiss() {
  currentAnnouncement.value = null
}

function handlePageShow() {
  maybeShowLatestAnnouncement()
}

watch(
  () => authStore.isAuthenticated,
  (isAuthenticated) => {
    if (!isAuthenticated) {
      latestAnnouncement.value = null
      currentAnnouncement.value = null
      hasLoaded.value = false
      return
    }

    if (!hasLoaded.value) {
      void loadLatestAnnouncement()
      return
    }

    maybeShowLatestAnnouncement()
  },
  { immediate: true }
)

onMounted(() => {
  window.addEventListener('pageshow', handlePageShow)
})

onBeforeUnmount(() => {
  window.removeEventListener('pageshow', handlePageShow)
})
</script>

<style scoped>
.popup-fade-enter-active {
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.popup-fade-leave-active {
  transition: all 0.2s cubic-bezier(0.4, 0, 1, 1);
}

.popup-fade-enter-from,
.popup-fade-leave-to {
  opacity: 0;
}

.popup-fade-enter-from > div {
  transform: scale(0.94) translateY(-12px);
  opacity: 0;
}

.popup-fade-leave-to > div {
  transform: scale(0.96) translateY(-8px);
  opacity: 0;
}
</style>
