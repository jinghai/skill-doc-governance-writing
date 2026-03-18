#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="doc-governance-writing"
DEFAULT_REPO_URL="${DOC_SKILL_REPO_URL:-https://github.com/jinghai/skill-doc-governance-writing.git}"
PROJECT_DIR="${PROJECT_DIR:-$PWD}"
PROJECT_DIR="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$PROJECT_DIR")"
SUBMODULE_PATH=".trae/skills/$SKILL_NAME"

realpath_f() {
  python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$1"
}

ensure_repo_root() {
  git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree >/dev/null
}

ensure_skills_dir() {
  mkdir -p "$PROJECT_DIR/.trae/skills"
}

submodule_exists() {
  git -C "$PROJECT_DIR" config -f .gitmodules --get-regexp "^submodule\\.${SUBMODULE_PATH//\//\\.}\\.path$" >/dev/null 2>&1
}

cleanup_index_path() {
  if git -C "$PROJECT_DIR" ls-files --error-unmatch "$SUBMODULE_PATH" >/dev/null 2>&1 || git -C "$PROJECT_DIR" ls-files "$SUBMODULE_PATH/*" | grep -q .; then
    git -C "$PROJECT_DIR" rm -r --cached --ignore-unmatch "$SUBMODULE_PATH" >/dev/null
  fi
}

backup_path_if_needed() {
  local abs_path="$PROJECT_DIR/$SUBMODULE_PATH"
  if [[ -L "$abs_path" ]]; then
    rm "$abs_path"
    return
  fi
  if [[ -d "$abs_path" && ! -d "$abs_path/.git" ]]; then
    mv "$abs_path" "${abs_path}.bak.$(date +%s)"
  fi
}

init_submodule() {
  local repo_url="${1:-$DEFAULT_REPO_URL}"
  ensure_repo_root
  ensure_skills_dir
  backup_path_if_needed
  cleanup_index_path
  if submodule_exists; then
    git -C "$PROJECT_DIR" submodule sync -- "$SUBMODULE_PATH"
    git -C "$PROJECT_DIR" submodule update --init --recursive -- "$SUBMODULE_PATH"
  else
    git -C "$PROJECT_DIR" submodule add "$repo_url" "$SUBMODULE_PATH"
  fi
}

update_submodule() {
  ensure_repo_root
  git -C "$PROJECT_DIR" submodule sync -- "$SUBMODULE_PATH"
  git -C "$PROJECT_DIR" submodule update --init --recursive --remote -- "$SUBMODULE_PATH"
}

export_repo() {
  local output_root="$1"
  local source="$PROJECT_DIR/.trae/skills/$SKILL_NAME"
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
  ensure_repo_root
  echo "SKILL_NAME=$SKILL_NAME"
  echo "PROJECT_DIR=$PROJECT_DIR"
  echo "SUBMODULE_PATH=$SUBMODULE_PATH"
  echo "DEFAULT_REPO_URL=$DEFAULT_REPO_URL"
  git -C "$PROJECT_DIR" submodule status -- "$SUBMODULE_PATH" || true
  ls -ld "$PROJECT_DIR/$SUBMODULE_PATH" || true
}

usage() {
  cat <<'EOF'
Usage:
  bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh init [repo-url]
  bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh update-all
  bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh export-repo <output-root>
  bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh doctor
EOF
}

main() {
  local cmd="${1:-}"
  case "$cmd" in
    init)
      init_submodule "${2:-}"
      ;;
    update-all)
      update_submodule
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
