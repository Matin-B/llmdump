#!/bin/bash

# ==============================================================================
# LLM Project Context Generator
# Dumps allowed files from a directory into Markdown and XML formats.
# ==============================================================================

# ANSI Color Codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${CYAN}${BOLD}=== 🧠 LLMDump: Codebase Context Generator ===${NC}"
echo -e "${YELLOW}Enter the absolute path to your project directory:${NC}"
read -p "> " PROJECT_DIR

PROJECT_DIR="${PROJECT_DIR%/}"

if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "\n${RED}❌ Error: Directory '$PROJECT_DIR' does not exist. Try again.${NC}"
    exit 1
fi

OUTPUT_MD="$(pwd)/codebase_dump.md"
OUTPUT_XML="$(pwd)/codebase_dump.xml"


> "$OUTPUT_MD"
> "$OUTPUT_XML"

# Headers for Markdown
echo "# Project Codebase Dump" >> "$OUTPUT_MD"
echo "# Source: $PROJECT_DIR" >> "$OUTPUT_MD"
echo "================================================================================" >> "$OUTPUT_MD"
echo "" >> "$OUTPUT_MD"

# Headers for XML
echo "<project_dump>" >> "$OUTPUT_XML"
echo "  <source_directory>$PROJECT_DIR</source_directory>" >> "$OUTPUT_XML"
echo "  <files>" >> "$OUTPUT_XML"

PROCESSED_COUNT=0
SPINNER="/-\|"

echo ""

while read -r FILE_PATH; do
    
    RELATIVE_PATH="${FILE_PATH#$PROJECT_DIR/}"
    EXTENSION="${FILE_PATH##*.}"
    
    # Write to Markdown File
    echo "### File: \`$RELATIVE_PATH\`" >> "$OUTPUT_MD"
    echo "\`\`\`$EXTENSION" >> "$OUTPUT_MD"
    cat "$FILE_PATH" >> "$OUTPUT_MD"
    echo "" >> "$OUTPUT_MD"
    echo "\`\`\`" >> "$OUTPUT_MD"
    echo "" >> "$OUTPUT_MD"
    echo "--------------------------------------------------------------------------------" >> "$OUTPUT_MD"
    echo "" >> "$OUTPUT_MD"
    
    # Write to XML File
    echo "    <document>" >> "$OUTPUT_XML"
    echo "      <path>$RELATIVE_PATH</path>" >> "$OUTPUT_XML"
    echo "      <content><![CDATA[" >> "$OUTPUT_XML"
    cat "$FILE_PATH" >> "$OUTPUT_XML"
    echo "" >> "$OUTPUT_XML"
    echo "      ]]></content>" >> "$OUTPUT_XML"
    echo "    </document>" >> "$OUTPUT_XML"
    
    ((PROCESSED_COUNT++))
    
    SPIN_IDX=$((PROCESSED_COUNT % 4))
    printf "\r${BLUE}[%s]${NC} Extracting magic... ${BOLD}%d${NC} files dumped" "${SPINNER:$SPIN_IDX:1}" "$PROCESSED_COUNT"
    
done < <(find "$PROJECT_DIR" -type f \
    -not -path "*/\.*" \
    -not -path "*/__pycache__/*" \
    -not -path "*/node_modules/*" \
    -not -path "*/venv/*" \
    -not -path "*/env/*" \
    \( -name "*.py" -o -name "*.json" -o -name "*.txt" -o -name "*.md" -o -name "*.bat" -o -name "*.ini" -o -name "*.env" -o -name "*.sh" -o -name "*.js" -o -name "*.html" -o -name "*.css" \))

echo "  </files>" >> "$OUTPUT_XML"
echo "</project_dump>" >> "$OUTPUT_XML"

printf "\r\033[K"

echo -e "${GREEN}${BOLD}🚀 Boom! $PROCESSED_COUNT files dumped successfully.${NC}"
echo -e "📄 ${CYAN}Markdown:${NC} $OUTPUT_MD ${YELLOW}(Best for ChatGPT / Gemini)${NC}"
echo -e "📑 ${CYAN}XML:${NC}      $OUTPUT_XML ${YELLOW}(Best for Claude)${NC}"
echo ""