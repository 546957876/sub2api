<script setup lang="ts">
import { computed } from 'vue'
import AppLayout from '@/components/layout/AppLayout.vue'
import { useAuthStore } from '@/stores/auth'
import PricingView from './PricingView.vue'

const authStore = useAuthStore()
const useEmbeddedLayout = computed(() => authStore.isAuthenticated)
</script>

<template>
  <AppLayout v-if="useEmbeddedLayout">
    <PricingView />
  </AppLayout>
  <PricingView v-else />
</template>
