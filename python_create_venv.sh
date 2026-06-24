#!/bin/bash

set -e


# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
VENV_NAME="venv"
PYTHON_VERSION=""

# Custom environment name
#./create_venv.sh -n myproject

# Specific Python version
#./create_venv.sh -p python3.13

# Show help
#./create_venv.sh -h

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--name)
            VENV_NAME="$2"
            shift 2
            ;;
        -p|--python)
            PYTHON_VERSION="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -n, --name NAME      Name of the virtual environment (default: venv)"
            echo "  -p, --python VERSION Python version to use (e.g., python3.9)"
            echo "  -h, --help           Display this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Python3 is not installed. Please install Python3 first.${NC}"
    exit 1
fi

# Create virtual environment
echo -e "${YELLOW}Creating virtual environment: $VENV_NAME${NC}"
if [ -z "$PYTHON_VERSION" ]; then
    python3 -m venv "$VENV_NAME"
else
    $PYTHON_VERSION -m venv "$VENV_NAME"
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Virtual environment created successfully!${NC}"
    
    # Activate the virtual environment
    echo -e "${YELLOW}Activating virtual environment...${NC}"
    source "$VENV_NAME/bin/activate"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Virtual environment activated!${NC}"
        echo -e "${GREEN}(venv) $${NC}"
        
        # Upgrade pip
        echo -e "${YELLOW}Upgrading pip...${NC}"
        pip install --upgrade pip
        
        echo -e "${GREEN}Setup complete!${NC}"
        echo ""
        echo "To deactivate the virtual environment, run:"
        echo -e "  ${YELLOW}deactivate${NC}"
    else
        echo -e "${RED}Failed to activate virtual environment.${NC}"
        exit 1
    fi
else
    echo -e "${RED}Failed to create virtual environment.${NC}"
    exit 1
fi
