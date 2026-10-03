#!/bin/bash

# StudySpace API Test Script
# Tests the available StudySpace backend endpoints

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# StudySpace Backend API
API_BASE="https://studyspace-backend-delta.vercel.app"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       StudySpace API Tests             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Backend URL: ${API_BASE}${NC}"
echo ""

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to test GET endpoint
test_endpoint() {
    local name=$1
    local url=$2
    local expected_status=${3:-200}

    echo -e "${BLUE}Testing: ${name}${NC}"

    response=$(curl -s -w "\n%{http_code}" "${url}")
    status_code=$(echo "$response" | tail -n 1)
    body=$(echo "$response" | sed '$d')

    if [ "$status_code" -eq "$expected_status" ]; then
        echo -e "${GREEN}✅ PASS${NC} - Status: ${status_code}"

        if command -v jq &> /dev/null; then
            echo "$body" | jq -C '.' 2>/dev/null || echo "$body"
        else
            echo "$body"
        fi

        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC} - Expected: ${expected_status}, Got: ${status_code}"
        echo "$body"

        ((TESTS_FAILED++))
    fi

    echo ""
}

# Function to test POST endpoint
test_post_endpoint() {
    local name=$1
    local url=$2
    local data=$3
    local expected_status=${4:-200}

    echo -e "${BLUE}Testing: ${name}${NC}"

    response=$(curl -s -w "\n%{http_code}" \
        -X POST "${url}" \
        -H "Content-Type: application/json" \
        -d "${data}")

    status_code=$(echo "$response" | tail -n 1)
    body=$(echo "$response" | sed '$d')

    if [ "$status_code" -eq "$expected_status" ]; then
        echo -e "${GREEN}✅ PASS${NC} - Status: ${status_code}"

        if command -v jq &> /dev/null; then
            echo "$body" | jq -C '.' 2>/dev/null || echo "$body"
        else
            echo "$body"
        fi

        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC} - Expected: ${expected_status}, Got: ${status_code}"
        echo "$body"

        ((TESTS_FAILED++))
    fi

    echo ""
}

# ============================================================
# 1. CORE ENDPOINTS
# ============================================================

echo -e "${YELLOW}1. Core Endpoints${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_endpoint \
    "Health Check" \
    "${API_BASE}/health"

test_endpoint \
    "API Documentation" \
    "${API_BASE}/api-docs"

test_endpoint \
    "Swagger JSON" \
    "${API_BASE}/swagger.json"

echo ""

# ============================================================
# 2. EXTERNAL SERVICE APIs
# ============================================================

echo -e "${YELLOW}2. External Service APIs${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_endpoint \
    "Weather API" \
    "${API_BASE}/api/weather?city=London"

test_endpoint \
    "Cities Search" \
    "${API_BASE}/api/cities?query=London"

test_endpoint \
    "Music Search" \
    "${API_BASE}/api/music?searchTerm=focus"

echo ""

# ============================================================
# 3. AUTHENTICATION ENDPOINTS
# ============================================================

echo -e "${YELLOW}3. Authentication Endpoints${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_post_endpoint \
    "Login (no data)" \
    "${API_BASE}/api/auth/login" \
    '{}' \
    400

test_post_endpoint \
    "Register (no data)" \
    "${API_BASE}/api/auth/register" \
    '{}' \
    400

echo ""

# ============================================================
# 4. EMAIL VERIFICATION / PASSWORD RESET
# ============================================================

echo -e "${YELLOW}4. Account Management Endpoints${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_post_endpoint \
    "Verify Email (no data)" \
    "${API_BASE}/api/auth/verify-email" \
    '{}' \
    400

test_post_endpoint \
    "Reset Password (no data)" \
    "${API_BASE}/api/auth/reset-password" \
    '{}' \
    400

echo ""

# ============================================================
# 5. SEARCH
# ============================================================

echo -e "${YELLOW}5. Search Endpoint${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_endpoint \
    "Profile Search" \
    "${API_BASE}/api/search?name=test"

echo ""

# ============================================================
# 6. PROTECTED ENDPOINTS
# ============================================================

echo -e "${YELLOW}6. Protected Endpoints${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Profile GET requires a userId.
# A deliberately invalid ID is used for testing.
test_endpoint \
    "Profile by User ID" \
    "${API_BASE}/api/profile/000000000000000000000000" \
    404

# Groups POST without authentication should return 401.
test_post_endpoint \
    "Create Group (no auth)" \
    "${API_BASE}/api/groups" \
    '{}' \
    401

# AI Chat POST without authentication should return 401.
test_post_endpoint \
    "AI Chat (no auth)" \
    "${API_BASE}/api/ai-chat" \
    '{"message":"Hello"}' \
    401

echo ""

# ============================================================
# TEST SUMMARY
# ============================================================

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           Test Summary                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}Tests Passed: ${TESTS_PASSED}${NC}"
echo -e "${RED}Tests Failed: ${TESTS_FAILED}${NC}"
echo ""

if [ "$TESTS_FAILED" -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed! StudySpace backend is working correctly.${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Check the output above.${NC}"
    exit 1
fi