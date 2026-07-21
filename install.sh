#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_URL="https://raw.githubusercontent.com/Matin-B/llmdump/main/llmdump.sh"

DEST_DIR="$HOME/.local/bin"
DEST_FILE="$DEST_DIR/llmdump"

echo -e "${CYAN}${BOLD}=== ⬇️ Installing LLMDump ===${NC}"
echo -e "${BLUE}=>${NC} Fetching script from GitHub..."

mkdir -p "$DEST_DIR"
curl -sSL "$SCRIPT_URL" -o "$DEST_FILE"
chmod +x "$DEST_FILE"

# Detect the active shell
SHELL_RC=""
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_RC="$HOME/.bashrc"
else
    # Fallback for other shells
    SHELL_RC="$HOME/.profile"
fi

echo -e "${BLUE}=>${NC} Detecting shell... Found ${YELLOW}$SHELL${NC}"

# Add the alias if it doesn't already exist
if ! grep -q "alias llmdump=" "$SHELL_RC"; then
    echo -e "\n# llmdump - LLM Context Generator" >> "$SHELL_RC"
    echo "alias llmdump=\"$DEST_FILE\"" >> "$SHELL_RC"
    echo -e "${GREEN}✓${NC} Added 'llmdump' alias to ${YELLOW}$SHELL_RC${NC}"
else
    echo -e "${YELLOW}ℹ${NC} Alias already exists in $SHELL_RC. Skipping."
fi

echo ""
echo -e "${GREEN}${BOLD}🎉 Installation complete!${NC}"
echo -e "To start using it right now, run:"
echo -e "${CYAN}source $SHELL_RC${NC}"
echo ""