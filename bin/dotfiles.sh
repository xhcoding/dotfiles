#!/bin/bash

set -e
set -u

readonly DOTFILES_DIR="$(dirname $(dirname "$(realpath "$0")"))"
readonly USER_DIR="${DOTFILES_DIR}/user"
readonly SYSTEM_DIR="${DOTFILES_DIR}/system"
readonly TEMPLATE_CONF_FILE="${DOTFILES_DIR}/template.conf"

DRY_RUN=false
PATTERN=".*"

# Colors for log output
readonly COLOR_RESET="\033[0m"
readonly COLOR_INFO="\033[36m"      # Cyan
readonly COLOR_SUCCESS="\033[32m"   # Green
readonly COLOR_WARN="\033[33m"      # Yellow
readonly COLOR_ERROR="\033[31m"     # Red
readonly COLOR_DRY_RUN="\033[35m"   # Magenta

function log_info() {
    echo -e "${COLOR_INFO}[INFO]${COLOR_RESET} $*"
}

function log_success() {
    echo -e "${COLOR_SUCCESS}[OK]${COLOR_RESET} $*"
}

function log_warn() {
    echo -e "${COLOR_WARN}[WARN]${COLOR_RESET} $*" >&2
}

function log_error() {
    echo -e "${COLOR_ERROR}[ERROR]${COLOR_RESET} $*" >&2
}

function log_apply() {
    local src="$1"
    local dst="$2"
    echo -e "${COLOR_SUCCESS}[APPLY]${COLOR_RESET} ${COLOR_INFO}${src}${COLOR_RESET} → ${COLOR_INFO}${dst}${COLOR_RESET}"
}

function log_backup() {
    local src="$1"
    local dst="$2"
    echo -e "${COLOR_WARN}[BACKUP]${COLOR_RESET} ${COLOR_INFO}${src}${COLOR_RESET} → ${COLOR_INFO}${dst}${COLOR_RESET}"
}

function is_text_file() {
    local file="$1"
    if [[ -d "$file" ]]; then
        return 1
    fi
    # Use file command to check if it's a text file
    if command -v file &> /dev/null; then
        local file_type
        file_type=$(file -b --mime-type "$file" 2>/dev/null)
        [[ "$file_type" == text/* ]] && return 0
        [[ "$file_type" == application/json ]] && return 0
        [[ "$file_type" == application/yaml ]] && return 0
        [[ "$file_type" == application/x-yaml ]] && return 0
        return 1
    else
        # Fallback: try to read first few bytes
        if head -c 1024 "$file" 2>/dev/null | grep -q '[^[:print:][:space:]]'; then
            return 1
        fi
        return 0
    fi
}

function print_usage() {
    echo "Dotfiles management tool for adding and applying configuration files"
    echo ""
    echo "Usage: dotfiles [OPTIONS]"
    echo "Dotfiles directory: ${DOTFILES_DIR}"
    echo "Options:"
    echo "  --add <path>        Add a file or directory to dotfiles"
    echo "  --apply [pattern]   Apply dotfiles to system (optional regex pattern)"
    echo "  --update            Update files in dotfiles from original locations"
    echo "  --conf              Show template configurations"
    echo "  --dry-run           Show what would be applied without making changes"
    echo "  --help              Show this help message"
    exit 1
}

declare -ga TEMPLATE_PATTERNS=()
declare -ga TEMPLATE_KEYS=()
declare -ga TEMPLATE_VALUES=()
declare -ga TEMPLATE_FUNCS=()

function read_template_conf() {
    local conf_file=$1

    # Reset arrays
    TEMPLATE_FUNCS=()
    TEMPLATE_PATTERNS=()
    TEMPLATE_KEYS=()
    TEMPLATE_VALUES=()

    if [[ ! -f "$conf_file" ]]; then
        log_error "Config file '$conf_file' not found"
        return 1
    fi

    local line func pattern key value
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Remove leading whitespace (spaces/tabs)
        line="${line#"${line%%[![:space:]]*}"}"
        # Skip blank and comment lines
        [[ -z "$line" || "$line" == \#* ]] && continue

        # Split into 4 fields by TAB; value gets the rest (spaces allowed)
        read -r func pattern key value <<< "$line"

        TEMPLATE_FUNCS+=("${func:-}")
        TEMPLATE_PATTERNS+=("$pattern")
        TEMPLATE_KEYS+=("$key")
        TEMPLATE_VALUES+=("$value")
    done < "$conf_file"

    return 0
}

function get_template_matches() {
    local file_path="$1"
    local matches=""
    local i

    for ((i = 0; i < ${#TEMPLATE_PATTERNS[@]}; i++)); do
        local pattern="${TEMPLATE_PATTERNS[$i]}"
        if [[ "$file_path" =~ $pattern ]]; then
            if [[ -z "$matches" ]]; then
                matches="$i"
            else
                matches="$matches $i"
            fi
        fi
    done

    echo "$matches"
    return 0
}

function apply_single_template() {
    local temp_file="$1"
    local template_index="$2"
    local type="$3"
    local source_file="$4"

    local key="${TEMPLATE_KEYS[$template_index]}"
    local value="${TEMPLATE_VALUES[$template_index]}"
    local func="${TEMPLATE_FUNCS[$template_index]}"

    if [[ -n "$func" ]]; then
        log_info "Checking function: $func"
        if ! command -v "$func" &> /dev/null; then
            log_warn "Function '$func' not found, skipping this template replacement"
            return 1
        else
            if ! "$func" "$temp_file"; then
                log_warn "Function '$func' check failed, skipping this template replacement"
                return 1
            fi
        fi
    fi

    log_info "Template replacement: \${${key}} -> ${value}"
    if [[ ${DRY_RUN} == true ]]; then
        return 0
    fi

    if [[ -n "$key" ]]; then
        if [[ "$type" == "system" ]]; then
            sudo sed -i "s|\${${key}}|${value}|g" "$temp_file"
        else
            sed -i "s|\${${key}}|${value}|g" "$temp_file"
        fi
    fi

    return 0
}

function apply_template_replacements() {
    local source_file="$1"
    local dest_path="$2"
    local template_indices="$3"
    local type="$4"

    local temp_file="${source_file}.tmp"

    if [[ ${DRY_RUN} == false ]]; then
        if [[ "$type" == "system" ]]; then
            sudo cp "$source_file" "$temp_file"
        else
            cp "$source_file" "$temp_file"
        fi
    fi

    local applied_count=0
    local skipped_count=0
    local idx
    for idx in $template_indices; do
        if apply_single_template "$temp_file" "$idx" "$type" "$source_file"; then
            ((applied_count += 1))
        else
            ((skipped_count += 1))
        fi
    done

    if [[ $skipped_count -gt 0 ]]; then
        log_info "${applied_count} replacements applied, ${skipped_count} skipped"
    else
        log_info "${applied_count} replacements applied"
    fi
    if [[ "${DRY_RUN}" == false ]]; then 
        if [[ "$type" == "system" ]]; then
            sudo mv "$temp_file" "$dest_path"
        else
            mv "$temp_file" "$dest_path"
        fi
    fi
    log_apply "$temp_file" "$dest_path"

    return 0
}

function print_template_conf() {
    local i

    if [[ ${#TEMPLATE_PATTERNS[@]} -eq 0 ]]; then
        log_warn "No template configurations loaded"
        return 0
    fi

    log_info "Template configurations"
    echo -e "${COLOR_INFO}======================${COLOR_RESET}"
    for ((i = 0; i < ${#TEMPLATE_PATTERNS[@]}; i++)); do
        echo -e "${COLOR_SUCCESS}[$((i + 1))]${COLOR_RESET}"
        echo -e "  ${COLOR_INFO}Pattern:${COLOR_RESET}  ${TEMPLATE_PATTERNS[$i]}"
        echo -e "  ${COLOR_INFO}Key:${COLOR_RESET}      ${TEMPLATE_KEYS[$i]}"
        echo -e "  ${COLOR_INFO}Value:${COLOR_RESET}    ${TEMPLATE_VALUES[$i]}"
        echo -e "  ${COLOR_INFO}Function:${COLOR_RESET} ${TEMPLATE_FUNCS[$i]:-(none)}"
        echo ""
    done
}

function add_file() {
    local path="$1"
    local abs_path
    abs_path="$(realpath "${path}")"

    local relative_path=""
    local dest_path=""
    local file_type=""

    if [[ "${abs_path}" == /home/* ]]; then
        relative_path="${abs_path#/home/*/}"
        dest_path="${USER_DIR}/${relative_path}"
        file_type="user"
    else
        relative_path="${abs_path#/}"
        dest_path="${SYSTEM_DIR}/${relative_path}"
        file_type="system"
    fi

    mkdir -p "$(dirname "${dest_path}")"

    if [[ -d "${abs_path}" ]]; then
        if [[ "${file_type}" == "system" ]]; then
            sudo cp -r "${abs_path}" "${dest_path}"
        else
            cp -r "${abs_path}" "${dest_path}"
        fi
    else
        if [[ "${file_type}" == "system" ]]; then
            sudo cp "${abs_path}" "${dest_path}"
        else
            cp "${abs_path}" "${dest_path}"
        fi
    fi

    log_success "Added ${abs_path} → ${dest_path}"
}

function backup_file() {
    local file_path="$1"
    local backup_dir="$2"
    local relative_path="$3"
    local type="$4"

    local backup_path="${backup_dir}/${type}/${relative_path}"

    if [[ -f "${file_path}" || -d "${file_path}" ]]; then
        if [[ "${DRY_RUN}" == false ]]; then
             mkdir -p "$(dirname "${backup_path}")"
            if [[ "${type}" == "system" ]]; then
                sudo cp -r "${file_path}" "${backup_path}"
            else
                cp -r "${file_path}" "${backup_path}"
            fi
        fi
        log_backup "${file_path}" "${backup_path}"
    fi
}

function apply_single_file() {
    local source_file="$1"
    local dest_path="$2"
    local backup_dir="$3"
    local relative_path="$4"
    local type="$5"
    local template_indices=""

    if [[ $(basename "$source_file") == ".git_keep" ]]; then
        return 0
    fi

    backup_file "${dest_path}" "${backup_dir}" "${relative_path}" "${type}"

    if [[ -f "${source_file}" ]] && is_text_file "${source_file}"; then
        template_indices=$(get_template_matches "$relative_path")
    fi

    if [[ "${DRY_RUN}" == false ]]; then
        if [[ "${type}" == "system" ]]; then
            sudo mkdir -p "$(dirname "${dest_path}")"
        else
            mkdir -p "$(dirname "${dest_path}")"
        fi
    fi

    if [[ -n "$template_indices" ]]; then
        apply_template_replacements "${source_file}" "${dest_path}" "$template_indices" "$type"
    else
        if [[ "${DRY_RUN}" == false ]]; then
            if [[ "${type}" == "system" ]]; then
                sudo cp -r "${source_file}" "${dest_path}"
            else
                cp -r "${source_file}" "${dest_path}"
            fi
        fi
        log_apply "${source_file}" "${dest_path}"
    fi
}

function apply_user_files() {
    local backup_dir="$1"

    if [[ -d "${USER_DIR}" ]]; then
        local user_files
        user_files=$(find "${USER_DIR}" -type f)
        for file in ${user_files}; do
            local relative_path="${file#${USER_DIR}/}"

            if [[ "${relative_path}" =~ ${PATTERN} ]]; then
                local system_path="/home/$(whoami)/${relative_path}"
                apply_single_file "${file}" "${system_path}" \
                    "${backup_dir}" "${relative_path}" "user"
            fi
        done
    fi
}

function apply_system_files() {
    local backup_dir="$1"

    if [[ -d "${SYSTEM_DIR}" ]]; then
        local system_files
        system_files=$(find "${SYSTEM_DIR}" -type f)
        for file in ${system_files}; do
            local relative_path="${file#${SYSTEM_DIR}/}"

            if [[ "${relative_path}" =~ ${PATTERN} ]]; then
                local system_path="/${relative_path}"
                apply_single_file "${file}" "${system_path}" \
                    "${backup_dir}" "${relative_path}" "system"
            fi
        done
    fi
}

function apply_files() {
    local pattern="$1"

    backup_dir="${DOTFILES_DIR}/backup/$(date +%Y%m%d_%H%M%S)"
    if [[ "${DRY_RUN}" == true ]]; then
        log_info "Dry run mode enabled"
    else
        mkdir -p "${backup_dir}"
    fi
    log_info "Created backup directory: ${backup_dir}"

    apply_user_files "${backup_dir}"
    apply_system_files "${backup_dir}"

    if [[ "${DRY_RUN}" == false ]]; then
        log_success "Application completed. Backup stored in ${backup_dir}"
    else
        log_success "Completed. No changes were made"
    fi
}

function update_file() {
    local source_path="$1"
    local dest_path="$2"
    local file_type="$3"

    if [[ "${DRY_RUN}" == true ]]; then
        if [[ "${source_path}" -nt "${dest_path}" ]]; then
            log_dry_run "Update "${dest_path}" from "${source_path}""
        else
            log_info "${dest_path}" is up to date"  
        fi
    else
        if [[ "${source_path}" -nt "${dest_path}" ]]; then
            if [[ "${file_type}" == "system" ]]; then
                sudo cp -r "${source_path}" "${dest_path}"
            else
                cp -r "${source_path}" "${dest_path}"
            fi
            log_success "Updated "${dest_path}" from "${source_path}""
        else
            log_info "${dest_path}" is up to date"  
        fi
    fi
}

function update_user_files() {
    if [[ -d "${USER_DIR}" ]]; then
        local user_files
        user_files=$(find "${USER_DIR}" -type f)
        for file in ${user_files}; do
            local relative_path="${file#${USER_DIR}/}"
            local original_path="/home/$(whoami)/${relative_path}"

            if [[ -f "${original_path}" || -d "${original_path}" ]]; then
                update_file "${original_path}" "${file}" "user"
            else
                log_warn "Original file not found: ${original_path}"
            fi
        done
    fi
}

function update_system_files() {
    if [[ -d "${SYSTEM_DIR}" ]]; then
        local system_files
        system_files=$(find "${SYSTEM_DIR}" -type f)
        for file in ${system_files}; do
            local relative_path="${file#${SYSTEM_DIR}/}"
            local original_path="/${relative_path}"

            if [[ -f "${original_path}" || -d "${original_path}" ]]; then
                update_file "${original_path}" "${file}" "system"
            else
                log_warn "Original file not found: ${original_path}"
            fi
        done
    fi
}

function update_files() {
    if [[ "${DRY_RUN}" == true ]]; then
        log_dry_run "No changes will be made"
    fi

    update_user_files
    update_system_files

    if [[ "${DRY_RUN}" == false ]]; then
        log_success "Update completed"
    else
        log_dry_run "Completed. No changes were made"
    fi
}

function main() {
    local command=""
    local target_path=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --add)
                command="add"
                target_path="$2"
                shift 2
                ;;
            --apply)
                command="apply"
                if [[ -n "${2:-}" && ! "$2" =~ ^-- ]]; then
                    PATTERN="$2"
                    shift
                fi
                shift
                ;;
            --update)
                command="update"
                shift
                ;;
            --conf)
                command="conf"
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help)
                print_usage
                ;;
            *)
                log_error "Unknown option $1"
                print_usage
                ;;
        esac
    done

    case "${command}" in
        add)
            if [[ -z "${target_path}" ]]; then
                log_error "--add requires a path argument"
                print_usage
            fi
            add_file "${target_path}"
            ;;
        apply)
            read_template_conf "${TEMPLATE_CONF_FILE}"
            apply_files "${PATTERN}"
            ;;
        update)
            update_files
            ;;
        conf)
            read_template_conf "${TEMPLATE_CONF_FILE}"
            print_template_conf
            ;;
        *)
            print_usage
            ;;
    esac
}

main "$@"