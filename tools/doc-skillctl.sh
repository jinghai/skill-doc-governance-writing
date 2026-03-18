#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="doc-governance-writing"
DEFAULT_REPO_URL="${DOC_SKILL_REPO_URL:-https://github.com/<your-org>/skill-doc-governance-writing.git}"
HUB_DIR="${SKILLS_HUB_DIR:-$HOME/.trae/skills-hub}"
REGISTRY_FILE="$HUB_DIR/projects.list"

realpath_f() {
  python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$1"
}

ensure_hub() {
  mkdir -p "$HUB_DIR"
  touch "$REGISTRY_FILE"
}

normalize_project() {
  local input="${1:-$PWD}"
  realpath_f "$input"
}

register_project() {
  local project
  project="$(normalize_project "${1:-$PWD}")"
  ensure_hub
  if ! grep -Fxq "$project" "$REGISTRY_FILE"; then
    echo "$project" >>"$REGISTRY_FILE"
  fi
}

link_one() {
  local project="$1"
  local source="$HUB_DIR/$SKILL_NAME"
  local target="$project/.trae/skills/$SKILL_NAME"
  if [[ ! -d "$source" ]]; then
    echo "Skill not installed in hub: $SKILL_NAME" >&2
    exit 1
  fi
  mkdir -p "$project/.trae/skills"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "${target}.bak.$(date +%s)"
  fi
  ln -sfn "$source" "$target"
}

install_skill() {
  local repo_url="${1:-$DEFAULT_REPO_URL}"
  ensure_hub
  local dest="$HUB_DIR/$SKILL_NAME"
  if [[ -d "$dest/.git" ]]; then
    git -C "$dest" pull --ff-only
  elif [[ -d "$dest" ]]; then
    echo "Destination exists but not a git repo: $dest" >&2
    exit 1
  else
    git clone "$repo_url" "$dest"
  fi
  register_project "$PWD"
  link_one "$(normalize_project "$PWD")"
}

update_skill() {
  local dest="$HUB_DIR/$SKILL_NAME"
  if [[ ! -d "$dest/.git" ]]; then
    echo "Skill not installed: $SKILL_NAME" >&2
    exit 1
  fi
  git -C "$dest" pull --ff-only
  if [[ -f "$REGISTRY_FILE" ]]; then
    while IFS= read -r project; do
      [[ -z "$project" ]] && continue
      [[ ! -d "$project" ]] && continue
      link_one "$project"
    done <"$REGISTRY_FILE"
  fi
}

export_repo() {
  local output_root="$1"
  local source="$PWD/.trae/skills/$SKILL_NAME"
  if [[ ! -e "$source" ]]; then
    echo "Skill not found in current project: $source" >&2
    exit 1
  fi
  mkdir -p "$output_root"
  local target="$output_root/$SKILL_NAME"
  rm -rf "$target"
  cp -R "$source" "$target"
  echo "Exported: $target"
}

doctor() {
  ensure_hub
  echo "SKILL_NAME=$SKILL_NAME"
  echo "HUB_DIR=$HUB_DIR"
  echo "REGISTRY_FILE=$REGISTRY_FILE"
  echo "DEFAULT_REPO_URL=$DEFAULT_REPO_URL"
  if [[ -d "$HUB_DIR/$SKILL_NAME" ]]; then
    echo "Installed: yes"
  else
    echo "Installed: no"
  fi
}

usage() {
  cat <<'EOF'
Usage:
  bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh install [repo-url]
  bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh update-all
  bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh link [project-path]
  bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh register-project [project-path]
  bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh export-repo <output-root>
  bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh doctor
EOF
}

main() {
  local cmd="${1:-}"
  case "$cmd" in
    install)
      install_skill "${2:-}"
      ;;
    update-all)
      update_skill
      ;;
    link)
      local project="${2:-$PWD}"
      project="$(normalize_project "$project")"
      register_project "$project"
      link_one "$project"
      ;;
    register-project)
      register_project "${2:-$PWD}"
      ;;
    export-repo)
      [[ $# -lt 2 ]] && usage && exit 1
      export_repo "$2"
      ;;
    doctor)
      doctor
      ;;
    *)
      usage
      exit 1
      ;;
  esac
}

main "$@"
