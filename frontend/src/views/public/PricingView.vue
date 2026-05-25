<script setup lang="ts">
import { computed } from 'vue'
import PricingView from '@/views/PricingView.vue'
import AppLayout from '@/components/layout/AppLayout.vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
const useEmbeddedLayout = computed(() => authStore.isAuthenticated)
</script>

<template>
  <AppLayout v-if="useEmbeddedLayout">
    <PricingView />
  </AppLayout>
  <PricingView v-else />
</template>
