#!/bin/bash

# 验证 AI 工具生态配置教程的演示脚本
# Demo script to verify AI ecosystem tutorial configurations

set -e  # Exit on error

DEMO_DIR="/tmp/zero-skills-demo-$$"
RESULTS_FILE="$DEMO_DIR/verification-results.txt"

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "零技能 AI 工具生态配置验证脚本"
echo "Zero-Skills AI Ecosystem Tutorial Verification"
echo "================================================"
echo ""

# 创建临时目录
mkdir -p "$DEMO_DIR"
echo "✓ 创建测试目录: $DEMO_DIR"
echo ""

# 记录结果函数
log_result() {
    local test_name=$1
    local status=$2
    local message=$3

    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}✓ PASS${NC}: $test_name"
    else
        echo -e "${RED}✗ FAIL${NC}: $test_name"
    fi
    echo "  $message"
    echo "$test_name: $status - $message" >> "$RESULTS_FILE"
    echo ""
}

# 测试 1: GitHub Copilot 配置
test_github_copilot() {
    echo "=== 测试 1: GitHub Copilot 配置 ==="
    local test_dir="$DEMO_DIR/copilot-test"
    mkdir -p "$test_dir"
    cd "$test_dir"

    # 初始化 git 仓库
    git init -q

    # 添加 ai-context 作为 submodule
    if git submodule add -q https://github.com/zeromicro/ai-context.git .github/ai-context 2>/dev/null; then
        # 创建符号链接
        mkdir -p .github
        ln -s ai-context/00-instructions.md .github/copilot-instructions.md

        # 验证文件存在
        if [ -L ".github/copilot-instructions.md" ] && [ -e ".github/copilot-instructions.md" ]; then
            # 验证内容
            if grep -q "go-zero" .github/copilot-instructions.md; then
                log_result "GitHub Copilot 配置" "PASS" "Submodule 添加成功，符号链接创建成功，内容验证通过"
                return 0
            else
                log_result "GitHub Copilot 配置" "FAIL" "文件内容不包含 go-zero 相关内容"
                return 1
            fi
        else
            log_result "GitHub Copilot 配置" "FAIL" "符号链接创建失败或文件不存在"
            return 1
        fi
    else
        log_result "GitHub Copilot 配置" "FAIL" "Submodule 添加失败"
        return 1
    fi
}

# 测试 2: Cursor 配置
test_cursor() {
    echo "=== 测试 2: Cursor 配置 ==="
    local test_dir="$DEMO_DIR/cursor-test"
    mkdir -p "$test_dir"
    cd "$test_dir"

    # 初始化 git 仓库
    git init -q

    # 添加 ai-context 作为 submodule
    if git submodule add -q https://github.com/zeromicro/ai-context.git .cursorrules 2>/dev/null; then
        # 验证目录和文件存在
        if [ -d ".cursorrules" ] && [ -f ".cursorrules/00-instructions.md" ]; then
            # 验证内容
            if grep -q "go-zero" .cursorrules/00-instructions.md; then
                # 统计 .md 文件数量
                md_count=$(find .cursorrules -name "*.md" -type f | wc -l)
                log_result "Cursor 配置" "PASS" "Submodule 添加成功，找到 $md_count 个 .md 文件"
                return 0
            else
                log_result "Cursor 配置" "FAIL" "文件内容不包含 go-zero 相关内容"
                return 1
            fi
        else
            log_result "Cursor 配置" "FAIL" ".cursorrules 目录或文件不存在"
            return 1
        fi
    else
        log_result "Cursor 配置" "FAIL" "Submodule 添加失败"
        return 1
    fi
}

# 测试 3: Windsurf 配置
test_windsurf() {
    echo "=== 测试 3: Windsurf 配置 ==="
    local test_dir="$DEMO_DIR/windsurf-test"
    mkdir -p "$test_dir"
    cd "$test_dir"

    # 初始化 git 仓库
    git init -q

    # 添加 ai-context 作为 submodule
    if git submodule add -q https://github.com/zeromicro/ai-context.git .windsurfrules 2>/dev/null; then
        # 验证目录和文件存在
        if [ -d ".windsurfrules" ] && [ -f ".windsurfrules/00-instructions.md" ]; then
            # 验证内容
            if grep -q "go-zero" .windsurfrules/00-instructions.md; then
                # 统计 .md 文件数量
                md_count=$(find .windsurfrules -name "*.md" -type f | wc -l)
                log_result "Windsurf 配置" "PASS" "Submodule 添加成功，找到 $md_count 个 .md 文件"
                return 0
            else
                log_result "Windsurf 配置" "FAIL" "文件内容不包含 go-zero 相关内容"
                return 1
            fi
        else
            log_result "Windsurf 配置" "FAIL" ".windsurfrules 目录或文件不存在"
            return 1
        fi
    else
        log_result "Windsurf 配置" "FAIL" "Submodule 添加失败"
        return 1
    fi
}

# 测试 4: Submodule 更新
test_submodule_update() {
    echo "=== 测试 4: Submodule 更新功能 ==="
    local test_dir="$DEMO_DIR/update-test"
    mkdir -p "$test_dir"
    cd "$test_dir"

    # 初始化 git 仓库并添加 submodule
    git init -q
    git submodule add -q https://github.com/zeromicro/ai-context.git .github/ai-context 2>/dev/null

    # 记录初始 commit hash
    cd .github/ai-context
    initial_commit=$(git rev-parse HEAD)
    cd ../..

    # 尝试更新
    if git submodule update --remote .github/ai-context 2>/dev/null; then
        cd .github/ai-context
        updated_commit=$(git rev-parse HEAD)
        cd ../..

        log_result "Submodule 更新" "PASS" "更新成功 (commit: ${updated_commit:0:8})"
        return 0
    else
        log_result "Submodule 更新" "FAIL" "Submodule 更新失败"
        return 1
    fi
}

# 测试 5: 验证 ai-context 内容结构
test_content_structure() {
    echo "=== 测试 5: 验证 ai-context 内容结构 ==="
    local test_dir="$DEMO_DIR/content-test"
    mkdir -p "$test_dir"
    cd "$test_dir"

    # 初始化并克隆
    git init -q
    git submodule add -q https://github.com/zeromicro/ai-context.git .ai-context 2>/dev/null

    # 验证关键内容
    local required_sections=(
        "Decision Tree"
        "File Priority"
        "Patterns"
        "zero-skills"
    )

    local missing_sections=()
    for section in "${required_sections[@]}"; do
        if ! grep -q "$section" .ai-context/00-instructions.md; then
            missing_sections+=("$section")
        fi
    done

    if [ ${#missing_sections[@]} -eq 0 ]; then
        log_result "内容结构验证" "PASS" "所有必需章节都存在"
        return 0
    else
        log_result "内容结构验证" "FAIL" "缺少章节: ${missing_sections[*]}"
        return 1
    fi
}

# 测试 6: 验证 zero-skills 引用
test_zero_skills_references() {
    echo "=== 测试 6: 验证 zero-skills 引用 ==="
    local test_dir="$DEMO_DIR/reference-test"
    mkdir -p "$test_dir"
    cd "$test_dir"

    # 初始化并克隆
    git init -q
    git submodule add -q https://github.com/zeromicro/ai-context.git .ai-context 2>/dev/null

    # 验证 zero-skills 链接
    local required_links=(
        "rest-api-patterns.md"
        "rpc-patterns.md"
        "database-patterns.md"
        "resilience-patterns.md"
    )

    local missing_links=()
    for link in "${required_links[@]}"; do
        if ! grep -q "$link" .ai-context/00-instructions.md; then
            missing_links+=("$link")
        fi
    done

    if [ ${#missing_links[@]} -eq 0 ]; then
        log_result "zero-skills 引用" "PASS" "所有模式文档引用都存在"
        return 0
    else
        log_result "zero-skills 引用" "FAIL" "缺少引用: ${missing_links[*]}"
        return 1
    fi
}

# 运行所有测试
main() {
    echo "开始运行测试..."
    echo ""

    local total=0
    local passed=0

    # 运行测试
    test_github_copilot && ((passed++)) || true
    ((total++))

    test_cursor && ((passed++)) || true
    ((total++))

    test_windsurf && ((passed++)) || true
    ((total++))

    test_submodule_update && ((passed++)) || true
    ((total++))

    test_content_structure && ((passed++)) || true
    ((total++))

    test_zero_skills_references && ((passed++)) || true
    ((total++))

    # 输出总结
    echo "================================================"
    echo "测试总结 / Test Summary"
    echo "================================================"
    echo "总测试数 / Total Tests: $total"
    echo -e "通过 / Passed: ${GREEN}$passed${NC}"
    echo -e "失败 / Failed: ${RED}$((total - passed))${NC}"
    echo ""

    if [ $passed -eq $total ]; then
        echo -e "${GREEN}✓ 所有测试通过！教程验证成功！${NC}"
        echo -e "${GREEN}✓ All tests passed! Tutorial verified successfully!${NC}"
    else
        echo -e "${YELLOW}⚠ 部分测试失败，请检查配置${NC}"
        echo -e "${YELLOW}⚠ Some tests failed, please check the configuration${NC}"
    fi

    echo ""
    echo "详细结果保存在: $RESULTS_FILE"
    echo "测试目录: $DEMO_DIR"
    echo ""
    echo -e "${YELLOW}提示: 测试完成后可以删除测试目录${NC}"
    echo -e "${YELLOW}Tip: You can delete the test directory after verification${NC}"
    echo "rm -rf $DEMO_DIR"
    echo ""
}

# 执行主函数
main
