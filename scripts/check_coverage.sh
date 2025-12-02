#!/bin/bash

# Coverage Check Script
# This script validates that code coverage meets the minimum threshold

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
MIN_COVERAGE=70
COVERAGE_FILE="coverage/lcov.info"

echo "======================================="
echo "  Code Coverage Threshold Check"
echo "======================================="

# Check if coverage file exists
if [ ! -f "$COVERAGE_FILE" ]; then
    echo -e "${RED}❌ Coverage file not found: $COVERAGE_FILE${NC}"
    echo "Please run 'flutter test --coverage' first"
    exit 1
fi

# Function to calculate coverage percentage
calculate_coverage() {
    # Extract lines found and lines hit from lcov.info
    local lines_found=$(grep -o "LF:[0-9]*" "$COVERAGE_FILE" | cut -d':' -f2 | awk '{s+=$1} END {print s}')
    local lines_hit=$(grep -o "LH:[0-9]*" "$COVERAGE_FILE" | cut -d':' -f2 | awk '{s+=$1} END {print s}')
    
    # Calculate percentage
    if [ "$lines_found" -eq 0 ]; then
        echo "0"
    else
        echo "scale=2; ($lines_hit * 100) / $lines_found" | bc
    fi
}

# Get current coverage
CURRENT_COVERAGE=$(calculate_coverage)

echo ""
echo -e "${YELLOW}Current Coverage:${NC} ${CURRENT_COVERAGE}%"
echo -e "${YELLOW}Minimum Required:${NC} ${MIN_COVERAGE}%"
echo ""

# Compare with threshold (using bc for floating point comparison)
if (( $(echo "$CURRENT_COVERAGE < $MIN_COVERAGE" | bc -l) )); then
    echo -e "${RED}❌ FAILED: Coverage ${CURRENT_COVERAGE}% is below minimum ${MIN_COVERAGE}%${NC}"
    echo ""
    echo "Please add more tests to increase code coverage."
    exit 1
else
    DIFF=$(echo "$CURRENT_COVERAGE - $MIN_COVERAGE" | bc)
    echo -e "${GREEN}✅ PASSED: Coverage check successful!${NC}"
    echo -e "${GREEN}Coverage is ${DIFF}% above the minimum threshold.${NC}"
    exit 0
fi
