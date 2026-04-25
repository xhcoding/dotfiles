#!/bin/bash

set -e
set -u

readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly BIN_DIR="${SCRIPT_DIR}/bin"
readonly BIN_LINUX_DIR="${BIN_DIR}/linux"

. "${SCRIPT_DIR}/scripts/log.sh"

function get_architecture() {
    local arch
    arch=$(uname -m)
    case "${arch}" in
        x86_64)
            echo "amd64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        *)
            log_error "Unsupported architecture: ${arch}"
            exit 1
            ;;
    esac
}

function install_bin_linux_dir() {
    log_info_color "Installing Linux-specific files..."
    log_info "Linux directory: ${BIN_LINUX_DIR}"

    if [[ ! -d "${BIN_LINUX_DIR}" ]]; then
        log_warn "Linux directory not found: ${BIN_LINUX_DIR}"
        return 0
    fi

    local arch
    arch=$(get_architecture)
    local arch_dir="${BIN_LINUX_DIR}/${arch}"

    if [[ ! -d "${arch_dir}" ]]; then
        log_warn "Architecture directory not found: ${arch_dir}"
        return 0
    fi

    log_info "Architecture: ${arch}"
    log_info "Architecture directory: ${arch_dir}"

    local files
    files=$(ls "${arch_dir}" 2>/dev/null || true)

    if [[ -z "${files}" ]]; then
        log_warn "No files found in ${arch_dir}"
        return 0
    fi

    log_info "Found files: ${files}"

    for file in ${files}; do
        local file_path="${arch_dir}/${file}"
        local target_path="/usr/bin/${file}"

        log_info "Installing ${file}..."

        log_info "Creating symlink: ${target_path} -> ${file_path}"
        sudo ln -sf "${file_path}" "${target_path}"
        log_info "Installed ${file}"
    done
}

function install_bin_dir() {
    log_info_color "Installing utility scripts from bin directory..."
    log_info "Bin directory: ${BIN_DIR}"
    log_info "Target directory: /usr/bin/"

    if [[ ! -d "${BIN_DIR}" ]]; then
        log_error "Bin directory not found: ${BIN_DIR}"
        exit 1
    fi

    local scripts
    scripts=$(find "${BIN_DIR}" -name "*.sh" 2>/dev/null || true)

    if [[ -z "${scripts}" ]]; then
        log_warn "No .sh scripts found in ${BIN_DIR}"
    else
        log_info "Found scripts:"
        echo "${scripts}"

        for script in ${scripts}; do
            local script_name=$(basename "${script}")
            local target_name="${script_name%.*}"
            local target_path="/usr/bin/${target_name}"

            log_info "Installing ${script_name}..."
            log_info "Creating symlink: ${target_path} -> ${script}"
            sudo ln -sf "${script}" "${target_path}"
            log_info "Installed ${script_name}"
        done
    fi

    # Install Linux-specific files
    install_bin_linux_dir
}

function main() {
    install_bin_dir

    log_info_color "Running dotfiles -apply..."
    dotfiles --apply

    log_info_color "Checking mihomo service status..."
    if sudo systemctl status mihomo &> /dev/null; then
        log_info "mihomo service is already running"
    else
        log_info "mihomo service is not running, starting it..."
        sudo systemctl enable --now mihomo || log_warn "Failed to start mihomo service (may not be installed)"
    fi
    
    log_info_color "Running install_app_ubuntu.sh..."
    "${SCRIPT_DIR}/scripts/install_app_ubuntu.sh"
    
    log_info_color "Installation completed!"
}

main "$@"