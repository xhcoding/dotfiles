#!/bin/bash

. "$(dirname "$0")/log.sh"

readonly COMMON_TOOLS=(git curl wget gpg ca-certificates vim ripgrep fd-find)

function check_system_info() {
    log_info_color "Checking system information..."
    local ubuntu_version
    local ubuntu_codename
    local arch
    ubuntu_version=$(lsb_release -r | awk '{print $2}')
    ubuntu_codename=$(lsb_release -c | awk '{print $2}')
    arch=$(uname -m)
    
    log_info "Current Ubuntu version: ${ubuntu_version}"
    log_info "Current Ubuntu codename: ${ubuntu_codename}"
    log_info "Current system architecture: ${arch}"
    
    echo "${ubuntu_version} ${ubuntu_codename} ${arch}"
}

function backup_sources_list() {
    log_info_color "Backing up sources.list file..."
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    log_debug "Backed up original sources.list file"
    
    local sources_file="/etc/apt/sources.list.d/ubuntu.sources"
    if [ -f "${sources_file}" ]; then
        sudo cp "${sources_file}" "${sources_file}.bak"
        log_debug "Backed up original ${sources_file} file"
    fi
}

function update_sources_list() {
    local ubuntu_codename="$1"
    local arch="$2"
    local sources_file="/etc/apt/sources.list.d/ubuntu.sources"
    
    log_info_color "Updating sources.list file..."

    if [ "${arch}" = "aarch64" ] || [ "${arch}" = "arm64" ]; then
        log_info "Detected ARM64 architecture, replacing ports.ubuntu.com with mirrors.ustc.edu.cn"
        sudo sed -i 's@//ports.ubuntu.com@//mirrors.ustc.edu.cn@g' "${sources_file}"
    else
        log_info "Detected AMD64 architecture, replacing archive.ubuntu.com with mirrors.ustc.edu.cn"
        sudo sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' "${sources_file}"
    fi
    
    log_debug "Updated sources.list file: ${sources_file}"
    log_debug "Executing apt update..."
    sudo apt update
}

function check_gui() {
    log_info_color "Checking if GUI is available..."
    
    if [ -n "$DISPLAY" ] || [ -f "/usr/bin/Xorg" ] || [ -f "/usr/bin/wayland-server" ]; then
        log_info "GUI detected"
        return 0
    else
        log_info "No GUI detected"
        return 1
    fi
}

function install_microsoft_edge() {
    if command -v microsoft-edge-stable &> /dev/null; then
        log_info "Microsoft Edge is already installed, skipping installation"
        return 0
    fi
    
    log_info_color "Installing Microsoft Edge..."
    
    log_debug "Adding Microsoft Edge GPG key..."
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-edge.gpg
    
    log_debug "Adding Microsoft Edge repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
    
    log_debug "Updating package list..."
    sudo apt update
    log_debug "Installing Microsoft Edge..."
    sudo apt install -y microsoft-edge-stable
    
    log_info_color "Microsoft Edge installation completed!"
}

function install_starship() {
    if command -v starship &> /dev/null; then
        log_info "Starship is already installed, skipping installation"
        log_info "Starship version: $(starship --version)"
        return 0
    fi
    
    log_info_color "Installing Starship prompt..."
    
    log_debug "Downloading and executing Starship installation script..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    
    if command -v starship &> /dev/null; then
        log_info_color "Starship installation completed!"
        log_info "Starship version: $(starship --version)"
    else
        log_error "Starship installation failed!"
    fi
}

function install_zoxide() {
    if command -v zoxide &> /dev/null; then
        log_info "zoxide is already installed, skipping installation"
        log_info "zoxide version: $(zoxide --version)"
        return 0
    fi
    
    log_info_color "Installing zoxide tool..."
    
    log_debug "Downloading and executing zoxide installation script..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    
    if command -v zoxide &> /dev/null; then
        log_info_color "zoxide installation completed!"
        log_info "zoxide version: $(zoxide --version)"
    else
        log_error "zoxide installation failed!"
    fi
}

function install_fzf() {
    if command -v fzf &> /dev/null; then
        log_info "fzf is already installed, skipping installation"
        return 0
    fi
    
    log_info_color "Installing fzf tool..."
    
    local arch
    arch=$(uname -m)
    local fzf_arch
    case "${arch}" in
        x86_64)
            fzf_arch="linux_amd64"
            ;;
        aarch64|arm64)
            fzf_arch="linux_arm64"
            ;;
        *)
            log_error "Unsupported architecture: ${arch}"
            return 1
            ;;
    esac
    
    log_info "Detected architecture: ${arch}, using: ${fzf_arch}"
    
    local fzf_url="https://github.com/junegunn/fzf/releases/download/v0.71.0/fzf-0.71.0-${fzf_arch}.tar.gz"
    local fzf_temp_dir="/tmp/fzf_install"
    
    log_debug "Creating temporary directory: ${fzf_temp_dir}"
    mkdir -p "${fzf_temp_dir}"
    
    log_info "Downloading fzf 0.71.0 from GitHub..."
    if ! curl -L -o "${fzf_temp_dir}/fzf.tar.gz" "${fzf_url}"; then
        log_error "Failed to download fzf!"
        rm -rf "${fzf_temp_dir}"
        return 1
    fi
    
    log_debug "Extracting fzf package..."
    tar -xzf "${fzf_temp_dir}/fzf.tar.gz" -C "${fzf_temp_dir}"
    
    log_debug "Installing fzf to /usr/bin..."
    sudo cp "${fzf_temp_dir}/fzf" /usr/bin/
    
    log_debug "Cleaning up temporary files..."
    rm -rf "${fzf_temp_dir}"
    
    if command -v fzf &> /dev/null; then
        log_info_color "fzf installation completed!"
    else
        log_error "fzf installation failed!"
    fi
}

function install_common_tools() {
    log_debug "Executing apt install for common tools..."
    sudo apt install -y "${COMMON_TOOLS[@]}"
    
    log_info "Setting up fd command alias..."
    sudo update-alternatives --install /usr/bin/fd fd /usr/bin/fdfind 10
    
    log_info_color "Common tools installation completed!"
    log_info "Installed tools: ${COMMON_TOOLS[*]}"
    
    if check_gui; then
        install_microsoft_edge
    fi
    
    install_starship
    
    install_zoxide
    
    install_fzf
}

function main() {
    log_info_color "Starting Ubuntu system initialization..."
    
    local ubuntu_version
    local ubuntu_codename
    local arch
    read -r ubuntu_version ubuntu_codename arch <<< "$(check_system_info | tail -n1)"
    
    backup_sources_list
    update_sources_list "${ubuntu_codename}" "${arch}"
    
    install_common_tools
    
    log_info_color "Ubuntu system initialization completed!"
}

main
