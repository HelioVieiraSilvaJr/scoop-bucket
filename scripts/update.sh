#!/usr/bin/env bash
# Leva bucket/infinitypes.json para a versão mais recente do InfiniTypes que tem os .zip do Windows,
# inclusive as marcadas como pré-lançamento. Precisa do gh e do jq. Sem versão nova, não altera nada.
set -euo pipefail

repo="HelioVieiraSilvaJr/InfiniTypes"
manifest="bucket/infinitypes.json"

# A versão mais recente que tem os dois .zip, e os arquivos.
release=$(gh api "repos/$repo/releases?per_page=30" --jq '
  [.[] | select(.draft | not)
       | {version: (.tag_name | ltrimstr("v")),
          x64: (.assets[] | select(.name == "InfiniTypes-windows-x64.zip")),
          arm64: (.assets[] | select(.name == "InfiniTypes-windows-arm64.zip"))}][0] // empty')
if [[ -z "$release" ]]; then
  echo "Nenhuma versão tem os .zip do Windows"
  exit 0
fi
version=$(jq -r .version <<<"$release")

current=$(jq -r .version "$manifest")
if [[ "$current" == "$version" ]]; then
  echo "O manifesto já está na $version"
  exit 0
fi

# O GitHub informa o SHA-256 de cada arquivo; sem ele, o arquivo é baixado.
sha256_of() {
  local digest
  digest=$(jq -r ".$1.digest // empty" <<<"$release")
  if [[ "$digest" == sha256:* ]]; then
    echo "${digest#sha256:}"
  else
    curl -fsSL "$(jq -r ".$1.browser_download_url" <<<"$release")" | shasum -a 256 | cut -d' ' -f1
  fi
}

jq --indent 4 --arg version "$version" \
  --arg x64_url "$(jq -r .x64.browser_download_url <<<"$release")" --arg x64_hash "$(sha256_of x64)" \
  --arg arm64_url "$(jq -r .arm64.browser_download_url <<<"$release")" --arg arm64_hash "$(sha256_of arm64)" '
  .version = $version
  | .architecture."64bit" = {url: $x64_url, hash: $x64_hash}
  | .architecture.arm64 = {url: $arm64_url, hash: $arm64_hash}' "$manifest" > "$manifest.tmp"
mv "$manifest.tmp" "$manifest"
echo "version=$version" >> "${GITHUB_OUTPUT:-/dev/null}"
echo "Manifesto atualizado: $current → $version"
