<template>
  <div class="min-h-screen bg-slate-50 text-slate-900 transition-colors duration-300 dark:bg-[#060d18] dark:text-white">
    <header class="relative z-30 border-b border-slate-200/70 bg-white/92 backdrop-blur-xl transition-colors duration-300 dark:border-white/6 dark:bg-[#07101d]/96">
      <nav class="mx-auto flex max-w-[1440px] items-center justify-between px-6 py-4 lg:px-8">
        <div class="flex items-center">
          <div class="flex h-11 w-11 items-center justify-center overflow-hidden rounded-xl bg-slate-100 shadow-[0_0_0_1px_rgba(15,23,42,0.06)] transition-colors duration-300 dark:bg-[#0d1830] dark:shadow-[0_0_0_1px_rgba(255,255,255,0.05)]">
            <img :src="siteLogo || '/logo.png'" alt="Logo" class="h-full w-full object-contain" />
          </div>
        </div>

        <div class="hidden items-center justify-center lg:flex">
          <div class="flex items-center gap-1 rounded-full border border-slate-200/80 bg-white/90 p-1 shadow-[0_12px_30px_rgba(15,23,42,0.06)] transition-colors dark:border-white/10 dark:bg-white/[0.06] dark:shadow-none">
            <router-link
              to="/home"
              :class="desktopNavClass('/home')"
            >
              {{ t('custom.nav.home') }}
            </router-link>
            <router-link
              to="/pricing"
              :class="desktopNavClass('/pricing')"
            >
              {{ t('custom.nav.modelPricing') }}
            </router-link>
            <router-link
              to="/docs"
              :class="desktopNavClass('/docs')"
            >
              {{ t('custom.nav.integrationDocs') }}
            </router-link>
          </div>
        </div>

        <div class="flex items-center gap-3">
          <LocaleSwitcher />
          <button
            type="button"
            class="rounded-lg p-2 text-slate-500 transition hover:bg-slate-100 hover:text-slate-900 dark:text-white/72 dark:hover:bg-white/5 dark:hover:text-white"
            :title="isDark ? t('home.switchToLight') : t('home.switchToDark')"
            @click="toggleTheme"
          >
            <Icon v-if="isDark" name="sun" size="md" />
            <Icon v-else name="moon" size="md" />
          </button>
          <router-link
            :to="isAuthenticated ? dashboardPath : '/login'"
            class="inline-flex items-center gap-1.5 rounded-full bg-slate-900 py-1 pl-1 pr-2.5 text-sm font-medium text-white transition hover:bg-slate-800 dark:bg-white/7 dark:hover:bg-white/10"
          >
            <span
              v-if="isAuthenticated"
              class="flex h-5 w-5 items-center justify-center rounded-full bg-gradient-to-br from-cyan-400 to-teal-500 text-[10px] font-semibold text-white"
            >
              {{ userInitial }}
            </span>
            <span>{{ isAuthenticated ? t('home.dashboard') : t('home.login') }}</span>
            <svg
              class="h-3.5 w-3.5 text-white/60"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M4.5 19.5l15-15m0 0H8.25m11.25 0v11.25"
              />
            </svg>
          </router-link>
        </div>
      </nav>

      <div class="border-t border-slate-200/70 px-6 pb-4 pt-3 lg:hidden dark:border-white/6">
        <div class="mx-auto flex max-w-[1440px] gap-2 overflow-x-auto">
          <router-link
            to="/home"
            :class="mobileNavClass('/home')"
          >
            {{ t('custom.nav.home') }}
          </router-link>
          <router-link
            to="/pricing"
            :class="mobileNavClass('/pricing')"
          >
            {{ t('custom.nav.modelPricing') }}
          </router-link>
          <router-link
            to="/docs"
            :class="mobileNavClass('/docs')"
          >
            {{ t('custom.nav.integrationDocs') }}
          </router-link>
        </div>
      </div>
    </header>

    <slot />
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRoute } from 'vue-router'
import { useAuthStore, useAppStore } from '@/stores'
import LocaleSwitcher from '@/components/common/LocaleSwitcher.vue'
import Icon from '@/components/icons/Icon.vue'

const { t } = useI18n()
const authStore = useAuthStore()
const appStore = useAppStore()
const route = useRoute()

const isDark = ref(document.documentElement.classList.contains('dark'))

const siteLogo = computed(() => appStore.cachedPublicSettings?.site_logo || appStore.siteLogo || '')
const isAuthenticated = computed(() => authStore.isAuthenticated)
const isAdmin = computed(() => authStore.isAdmin)
const dashboardPath = computed(() => (isAdmin.value ? '/admin/dashboard' : '/dashboard'))
const userInitial = computed(() => {
  const user = authStore.user
  if (!user?.email) return ''
  return user.email.charAt(0).toUpperCase()
})

function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.classList.toggle('dark', isDark.value)
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

function isActiveNav(path: string) {
  return route.path === path || route.path.startsWith(`${path}/`)
}

function desktopNavClass(path: string) {
  return isActiveNav(path)
    ? 'rounded-full px-4 py-2 text-sm font-medium transition bg-slate-900 text-white dark:bg-white dark:text-slate-950'
    : 'rounded-full px-4 py-2 text-sm font-medium transition text-slate-600 hover:text-slate-900 dark:text-white/90 dark:hover:bg-white/[0.05] dark:hover:text-white'
}

function mobileNavClass(path: string) {
  return isActiveNav(path)
    ? 'shrink-0 rounded-full border border-slate-900 bg-slate-900 px-4 py-2 text-sm font-medium text-white transition dark:border-white dark:bg-white dark:text-slate-950'
    : 'shrink-0 rounded-full border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-600 transition hover:border-slate-300 hover:text-slate-900 dark:border-white/18 dark:bg-transparent dark:text-white/90 dark:hover:border-white/28 dark:hover:bg-white/[0.05] dark:hover:text-white'
}
</script>
