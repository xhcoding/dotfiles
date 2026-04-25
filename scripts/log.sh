#!/bin/bash

LOG_LEVELS=("DEBUG" "INFO" "WARN" "ERROR")

function log_debug() {
    local message="$1"
    echo "[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') - ${message}"
}

function log_info() {
    local message="$1"
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - ${message}"
}

function log_warn() {
    local message="$1"
    echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') - ${message}"
}

function log_error() {
    local message="$1"
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - ${message}"
}

function log_debug_color() {
    local message="$1"
    echo -e "\033[36m[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') - ${message}\033[0m"
}

function log_info_color() {
    local message="$1"
    echo -e "\033[32m[INFO] $(date '+%Y-%m-%d %H:%M:%S') - ${message}\033[0m"
}

function log_warn_color() {
    local message="$1"
    echo -e "\033[33m[WARN] $(date '+%Y-%m-%d %H:%M:%S') - ${message}\033[0m"
}

function log_error_color() {
    local message="$1"
    echo -e "\033[31m[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - ${message}\033[0m"
}