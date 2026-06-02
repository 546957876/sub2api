Codex doc assets

These templates back the custom `/docs` Codex guide in the override pack.

Files:
- `codex-install.ps1`: Windows interactive setup script template
- `codex-install.sh`: macOS/Linux interactive setup script template

Maintenance notes:
- The initial structure was adapted from the public reference scripts the user provided:
  - `https://apikey.fun/install/codex.ps1`
  - `https://apikey.fun/install/codex.sh`
- Brand text was replaced with local placeholders and the generated Codex config was aligned with this repo's existing Codex file export logic.
- The Vue page imports these files with `?raw` and replaces placeholders at runtime:
  - `__SITE_NAME__`
  - `__CODEX_BASE_URL__`

If the install flow needs updates later, prefer editing these template files first and keep the Vue page focused on rendering and placeholder substitution.
