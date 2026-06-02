<script setup lang="ts">
import { computed } from 'vue'
import AppLayout from '@/components/layout/AppLayout.vue'
import { useAuthStore } from '@/stores/auth'
import PublicSiteLayout from './PublicSiteLayout.vue'
import PricingView from './PricingView.vue'

const authStore = useAuthStore()
const useEmbeddedLayout = computed(() => authStore.isAuthenticated)
</script>

<template>
  <AppLayout v-if="useEmbeddedLayout">
    <PricingView />
  </AppLayout>
  <PublicSiteLayout v-else>
    <PricingView />
  </PublicSiteLayout>
</template>
