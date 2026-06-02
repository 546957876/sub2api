import { computed, onMounted, ref } from 'vue'
import { useAppStore } from '@/stores'

export type PlatformKey = 'windows' | 'macos' | 'linux'

export const docsPlatforms = [
  { key: 'windows', label: 'Windows' },
  { key: 'macos', label: 'macOS' },
  { key: 'linux', label: 'Linux' }
] as const

const API_BASE_PLACEHOLDER = 'https://your-api-endpoint.example.com'

function trimTrailingSlash(value: string) {
  return value.replace(/\/+$/, '')
}

function stripKnownApiSuffix(value: string) {
  return trimTrailingSlash(value)
    .replace(/\/v1beta\/?$/, '')
    .replace(/\/v1\/?$/, '')
}

function withSuffix(base: string, suffix: string) {
  return `${trimTrailingSlash(base)}${suffix}`
}

export function escapePowerShell(value: string) {
  return value.replace(/`/g, '``').replace(/"/g, '`"')
}

export function escapeBash(value: string) {
  return value
    .replace(/\\/g, '\\\\')
    .replace(/"/g, '\\"')
    .replace(/\$/g, '\\$')
    .replace(/`/g, '\\`')
}

export function replaceTemplateTokens(template: string, replacements: Record<string, string>) {
  return Object.entries(replacements).reduce((result, [token, value]) => {
    return result.split(token).join(value)
  }, template)
}

export function createUnixPasteScript(script: string) {
  return `bash <<'__DOCS_SCRIPT__'
${script}
__DOCS_SCRIPT__`
}

export function createPowerShellPasteScript(script: string) {
  const bytes = new TextEncoder().encode(script)
  let binary = ''
  const chunkSize = 0x8000
  for (let index = 0; index < bytes.length; index += chunkSize) {
    binary += String.fromCharCode(...bytes.subarray(index, index + chunkSize))
  }
  const encoded = btoa(binary)
  return `$__docsB64='${encoded}'
$__docs=[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($__docsB64))
& ([ScriptBlock]::Create($__docs))`
}

export function useDocsRuntime() {
  const activePlatform = ref<PlatformKey>('windows')
  const appStore = useAppStore()

  onMounted(() => {
    if (!appStore.publicSettingsLoaded) {
      void appStore.fetchPublicSettings()
    }
  })

  const siteName = computed(() => {
    const current = appStore.cachedPublicSettings?.site_name || appStore.siteName || 'Sub2API'
    return current.trim() || 'Sub2API'
  })

  const siteSlug = computed(() => {
    const normalized = siteName.value
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '')
    return normalized || 'sub2api'
  })

  const configuredApiBaseUrl = computed(() => {
    const raw = appStore.cachedPublicSettings?.api_base_url || appStore.apiBaseUrl || ''
    return raw.trim()
  })

  const hasConfiguredApiBaseUrl = computed(() => configuredApiBaseUrl.value.length > 0)

  const baseRoot = computed(() => {
    if (!hasConfiguredApiBaseUrl.value) {
      return API_BASE_PLACEHOLDER
    }
    return stripKnownApiSuffix(configuredApiBaseUrl.value)
  })

  const apiRootBaseUrl = computed(() => trimTrailingSlash(baseRoot.value))
  const anthropicBaseUrl = computed(() => trimTrailingSlash(baseRoot.value))
  const openAiBaseUrl = computed(() => withSuffix(baseRoot.value, '/v1'))
  const geminiBaseUrl = computed(() => withSuffix(baseRoot.value, '/v1beta'))

  return {
    activePlatform,
    platforms: docsPlatforms,
    siteName,
    siteSlug,
    hasConfiguredApiBaseUrl,
    apiRootBaseUrl,
    anthropicBaseUrl,
    openAiBaseUrl,
    geminiBaseUrl
  }
}
