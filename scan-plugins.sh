#!/usr/bin/env bash
# Print every discoverable bar-widget plugin as one JSON array.
#
#   scan-plugins.sh <first-party-plugins-dir> <user-plugins-dir>
#
# Mirrors the shell's own discovery (PluginRegistry.rescan): first-party
# manifests live one or two levels down and may be `<Name>.manifest.json`
# siblings; third-party ones are `<dir>/<id>/manifest.json`. The drawer needs
# this because a plugin's widget component is only handed to the bar, so to
# render one inside the drawer we load its entry point by path.
set -u

first_party="${1:?first-party plugins dir}"
user="${2:?user plugins dir}"

emit() { # <firstParty true|false> <manifest path>
  jq -c --arg dir "$(dirname -- "$2")" --argjson firstParty "$1" '
    select(.schemaVersion == 1 and ((.kinds // []) | index("bar-widget")) and .entryPoints.barWidget)
    | {
        id,
        name: (.barWidget.displayName // .name),
        kinds,
        entry: ($dir + "/" + .entryPoints.barWidget),
        firstParty: $firstParty
      }' "$2" 2>/dev/null
}

{
  if [[ -d $first_party ]]; then
    while IFS= read -r manifest; do emit true "$manifest"; done < <(
      find "$first_party" -mindepth 2 -maxdepth 3 -type f \
        \( -name manifest.json -o -name '*.manifest.json' \) | sort)
  fi
  for manifest in "$user"/*/manifest.json; do
    [[ -f $manifest ]] && emit false "$manifest"
  done
} | jq -s 'sort_by(.name | ascii_downcase)'
