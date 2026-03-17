#!/bin/sh
set -e

# ccv uninstaller — Claude Code Vault

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { printf "${CYAN}[ccv]${NC} %s\n" "$1"; }
ok()    { printf "${GREEN}[ccv]${NC} %s\n" "$1"; }
warn()  { printf "${YELLOW}[ccv]${NC} %s\n" "$1"; }

BINARY="/usr/local/bin/ccv"
VAULT="$HOME/.ccv"

printf "\n${CYAN}ccv Uninstaller${NC}\n\n"

# Remove binary
if [ -f "$BINARY" ]; then
    info "Removing $BINARY..."
    if [ -w "$(dirname "$BINARY")" ]; then
        rm -f "$BINARY"
    else
        sudo rm -f "$BINARY"
    fi
    ok "Binary removed."
else
    warn "Binary not found at $BINARY"
fi

# Also check GOPATH
GOPATH_BIN="$(go env GOPATH 2>/dev/null)/bin/ccv"
if [ -f "$GOPATH_BIN" ] && [ "$GOPATH_BIN" != "$BINARY" ]; then
    info "Removing $GOPATH_BIN..."
    rm -f "$GOPATH_BIN"
    ok "Go-installed binary removed."
fi

# Ask about vault
if [ -d "$VAULT" ]; then
    printf "\n${YELLOW}Vault found at $VAULT${NC}\n"
    printf "Remove vault and all stored files? [y/N] "
    read -r response
    case "$response" in
        [yY]|[yY][eE][sS])
            rm -rf "$VAULT"
            ok "Vault removed."
            ;;
        *)
            info "Vault kept at $VAULT"
            ;;
    esac
else
    info "No vault found."
fi

printf "\n${GREEN}ccv uninstalled.${NC}\n\n"
