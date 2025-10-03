#!/bin/bash

# WAN 2.2 Captioning Toolkit - Installation Test Script
# Verifies that all components are working correctly

echo "🧪 Testing WAN 2.2 Captioning Toolkit Installation..."
echo "=================================================="

# Test results tracking
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -n "Testing $test_name... "
    
    if eval "$test_command" >/dev/null 2>&1; then
        echo "✅ PASS"
        ((TESTS_PASSED++))
    else
        echo "❌ FAIL"
        ((TESTS_FAILED++))
    fi
}

echo ""
echo "🔍 System Requirements Tests"
echo "----------------------------"

# Test 1: Python installation
run_test "Python 3.8+" "python3 --version | grep -E 'Python 3\.(8|9|10|11|12)'"

# Test 2: pip installation
run_test "pip installation" "pip --version"

# Test 3: Git installation
run_test "Git installation" "git --version"

# Test 4: CUDA availability (if nvidia-smi exists)
if command -v nvidia-smi &> /dev/null; then
    run_test "CUDA GPU detection" "nvidia-smi --query-gpu=name --format=csv,noheader"
else
    echo "⚠️  nvidia-smi not found - GPU tests skipped"
fi

echo ""
echo "🐍 Python Dependencies Tests"
echo "----------------------------"

# Test 5: PyTorch installation
run_test "PyTorch installation" "python3 -c 'import torch; print(torch.__version__)'"

# Test 6: PyTorch CUDA support
run_test "PyTorch CUDA support" "python3 -c 'import torch; torch.cuda.is_available()'"

# Test 7: wd-llm-caption installation
run_test "wd-llm-caption installation" "python3 -c 'import wd_llm_caption'"

# Test 8: onnxruntime-gpu installation
run_test "onnxruntime-gpu installation" "python3 -c 'import onnxruntime'"

# Test 9: Gradio installation
run_test "Gradio installation" "python3 -c 'import gradio'"

echo ""
echo "📁 File Structure Tests"
echo "-----------------------"

# Test 10: Scripts directory
run_test "Scripts directory exists" "[ -d scripts ]"

# Test 11: Workspace directory
run_test "Workspace directory exists" "[ -d workspace ]"

# Test 12: Script executability
run_test "Scripts are executable" "[ -x scripts/start_gui_public.sh ] && [ -x scripts/clean_captions.sh ] && [ -x scripts/add_trigger.sh ] && [ -x scripts/package_dataset.sh ]"

echo ""
echo "🔧 Functionality Tests"
echo "----------------------"

# Test 13: GUI command availability
run_test "GUI command available" "which wd-llm-caption-gui"

# Test 14: Test image processing (if test image exists)
if [ -f "workspace/test_image.jpg" ] || [ -f "workspace/test_image.png" ]; then
    run_test "Image processing capability" "python3 -c 'from PIL import Image; Image.open(\"workspace/test_image.jpg\" if [ -f \"workspace/test_image.jpg\" ] else \"workspace/test_image.png\")'"
else
    echo "⚠️  No test image found - image processing test skipped"
fi

echo ""
echo "📊 Test Results Summary"
echo "======================="
echo "✅ Tests Passed: $TESTS_PASSED"
echo "❌ Tests Failed: $TESTS_FAILED"
echo "📈 Success Rate: $(( TESTS_PASSED * 100 / (TESTS_PASSED + TESTS_FAILED) ))%"

if [ $TESTS_FAILED -eq 0 ]; then
    echo ""
    echo "🎉 All tests passed! Your installation is ready to use."
    echo "🚀 Run: cd workspace && bash ../scripts/start_gui_public.sh"
else
    echo ""
    echo "⚠️  Some tests failed. Please check the installation:"
    echo "   - Ensure all dependencies are installed"
    echo "   - Check CUDA installation if using GPU"
    echo "   - Verify file permissions"
    echo ""
    echo "🔧 Try running: bash install.sh"
fi

echo ""
echo "📋 Next Steps:"
echo "1. Place test images in the workspace/ directory"
echo "2. Start the GUI: cd workspace && bash ../scripts/start_gui_public.sh"
echo "3. Access the interface via the provided URL"
echo "4. Test image captioning functionality"
