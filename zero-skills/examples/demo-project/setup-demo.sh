#!/bin/bash

# 设置演示项目脚本
# Demo project setup script for testing GitHub Copilot with go-zero

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_NAME="userapidemo"
DEMO_DIR="$(pwd)/demo-workspace"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}go-zero AI 工具生态演示项目${NC}"
echo -e "${BLUE}Demo Project for go-zero AI Ecosystem${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# 检查依赖
echo "检查依赖..."
if ! command -v go &> /dev/null; then
    echo -e "${YELLOW}警告: Go 未安装，请先安装 Go${NC}"
    exit 1
fi

if ! command -v goctl &> /dev/null; then
    echo -e "${YELLOW}警告: goctl 未安装，正在安装...${NC}"
    go install github.com/zeromicro/go-zero/tools/goctl@latest
fi

echo -e "${GREEN}✓ 依赖检查完成${NC}"
echo ""

# 创建演示目录
echo "创建演示项目目录: $DEMO_DIR/$PROJECT_NAME"
mkdir -p "$DEMO_DIR"
cd "$DEMO_DIR"

# 初始化 git 仓库
if [ ! -d ".git" ]; then
    git init -q
    echo -e "${GREEN}✓ 初始化 Git 仓库${NC}"
fi

# 配置 GitHub Copilot（添加 ai-context）
echo ""
echo "配置 GitHub Copilot..."
if [ ! -d ".github/ai-context" ]; then
    git submodule add -q https://github.com/zeromicro/ai-context.git .github/ai-context 2>/dev/null || echo "Submodule already exists"
    mkdir -p .github
    ln -sf ai-context/00-instructions.md .github/copilot-instructions.md
    echo -e "${GREEN}✓ GitHub Copilot 配置完成${NC}"
    echo -e "  - Submodule: .github/ai-context"
    echo -e "  - Instructions: .github/copilot-instructions.md"
else
    echo -e "${YELLOW}⚠ GitHub Copilot 已配置${NC}"
fi

# 使用 goctl 创建基础项目结构
echo ""
echo "创建 go-zero API 项目: $PROJECT_NAME"
if [ ! -d "$PROJECT_NAME" ]; then
    goctl api new $PROJECT_NAME
    echo -e "${GREEN}✓ 项目创建完成${NC}"
else
    echo -e "${YELLOW}⚠ 项目已存在${NC}"
fi

cd $PROJECT_NAME

# 创建示例 API 定义文件
echo ""
echo "创建示例 API 定义..."
cat > user.api << 'EOF'
syntax = "v1"

info (
	title: "用户服务 API"
	desc: "用户管理相关接口"
	author: "go-zero"
	version: "1.0"
)

type (
	// 用户信息
	User {
		Id       int64  `json:"id"`
		Username string `json:"username"`
		Email    string `json:"email"`
		CreateAt string `json:"create_at"`
	}

	// 创建用户请求
	CreateUserRequest {
		Username string `json:"username"`
		Email    string `json:"email"`
		Password string `json:"password"`
	}

	// 创建用户响应
	CreateUserResponse {
		User User `json:"user"`
	}

	// 获取用户请求
	GetUserRequest {
		Id int64 `path:"id"`
	}

	// 获取用户响应
	GetUserResponse {
		User User `json:"user"`
	}

	// 用户列表请求
	ListUsersRequest {
		Page     int `form:"page,default=1"`
		PageSize int `form:"page_size,default=10"`
	}

	// 用户列表响应
	ListUsersResponse {
		Users []User `json:"users"`
		Total int64  `json:"total"`
	}
)

service user-api {
	@doc "创建用户"
	@handler CreateUser
	post /api/users (CreateUserRequest) returns (CreateUserResponse)

	@doc "获取用户详情"
	@handler GetUser
	get /api/users/:id (GetUserRequest) returns (GetUserResponse)

	@doc "获取用户列表"
	@handler ListUsers
	get /api/users (ListUsersRequest) returns (ListUsersResponse)
}
EOF

echo -e "${GREEN}✓ API 定义文件创建完成: user.api${NC}"

# 生成代码
echo ""
echo "生成 go-zero 代码..."
goctl api go -api user.api -dir . -style go_zero

echo -e "${GREEN}✓ 代码生成完成${NC}"

# 创建 README 说明
cat > README.md << 'EOF'
# User API Demo - go-zero with GitHub Copilot

这是一个使用 GitHub Copilot + ai-context 配置的 go-zero 演示项目。

## 项目结构

```
user-api-demo/
├── etc/              # 配置文件
├── internal/
│   ├── handler/      # HTTP 处理层
│   ├── logic/        # 业务逻辑层
│   ├── svc/          # 服务上下文
│   └── types/        # 类型定义
├── user.api          # API 定义文件
└── userademo.go      # 主程序入口
```

## 测试 GitHub Copilot

1. 在 VS Code 中打开此项目
2. GitHub Copilot 会自动读取 `.github/copilot-instructions.md`
3. 尝试以下操作来测试 Copilot 的 go-zero 支持：

### 测试场景 1: 实现 CreateUser Logic

打开 `internal/logic/createuserlogic.go`，在 `CreateUser` 方法中输入注释：

```go
// TODO: 实现用户创建逻辑
```

Copilot 应该建议符合 go-zero 规范的代码，包括：
- 参数验证
- 错误处理使用 `errorx`
- 返回符合 types 定义的结构

### 测试场景 2: 添加数据库 Model

在项目根目录创建注释：

```go
// TODO: 添加 MySQL 用户表 model
```

Copilot 应该建议：
- 使用 goctl model 命令
- 正确的表结构定义
- sqlx 的使用方式

### 测试场景 3: 添加中间件

创建新文件 `internal/middleware/auth.go`，输入：

```go
// TODO: 实现 JWT 认证中间件
```

Copilot 应该建议：
- 符合 go-zero 中间件模式的代码
- 正确的 JWT 验证逻辑
- 上下文传递方式

## 运行项目

```bash
# 运行服务
go run userademo.go

# 测试 API
curl http://localhost:8888/api/users
```

## 验证 Copilot 配置

检查 Copilot 是否正确加载了 ai-context：

```bash
# 查看配置文件
cat ../.github/copilot-instructions.md

# 确认包含 go-zero 相关内容
grep "go-zero" ../.github/copilot-instructions.md
```

## 预期效果

使用配置了 ai-context 的 GitHub Copilot：
- ✅ 代码建议遵循 go-zero 三层架构
- ✅ 错误处理使用 errorx
- ✅ 使用正确的 context 传递方式
- ✅ HTTP 响应使用 httpx.OkJson/Error
- ✅ 配置加载使用 conf.MustLoad

没有 ai-context 的普通 Copilot：
- ❌ 可能生成通用的 HTTP handler
- ❌ 可能不遵循 Handler->Logic 分层
- ❌ 错误处理可能使用 fmt.Errorf
- ❌ 不了解 go-zero 特定的工具和模式
EOF

echo -e "${GREEN}✓ README 创建完成${NC}"

# 初始化 Go module
if [ ! -f "go.mod" ]; then
    echo ""
    echo "初始化 Go module..."
    go mod init $PROJECT_NAME
    go mod tidy
    echo -e "${GREEN}✓ Go module 初始化完成${NC}"
fi

# 创建验证脚本
cat > ../verify-copilot.sh << 'EOF'
#!/bin/bash

# 验证 GitHub Copilot 配置

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "验证 GitHub Copilot 配置..."
echo ""

# 检查 1: submodule 存在
if [ -d ".github/ai-context" ]; then
    echo -e "${GREEN}✓${NC} ai-context submodule 存在"
else
    echo -e "${RED}✗${NC} ai-context submodule 不存在"
    exit 1
fi

# 检查 2: 符号链接存在
if [ -L ".github/copilot-instructions.md" ]; then
    echo -e "${GREEN}✓${NC} copilot-instructions.md 符号链接存在"
else
    echo -e "${RED}✗${NC} copilot-instructions.md 符号链接不存在"
    exit 1
fi

# 检查 3: 文件内容包含 go-zero
if grep -q "go-zero" .github/copilot-instructions.md; then
    echo -e "${GREEN}✓${NC} 配置文件包含 go-zero 内容"
else
    echo -e "${RED}✗${NC} 配置文件不包含 go-zero 内容"
    exit 1
fi

# 检查 4: 项目结构
if [ -d "userapidemo/internal" ]; then
    echo -e "${GREEN}✓${NC} go-zero 项目结构正确"
else
    echo -e "${RED}✗${NC} go-zero 项目结构不正确"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ 所有检查通过！${NC}"
echo ""
echo "现在可以在 VS Code 中打开项目，GitHub Copilot 将使用 go-zero 上下文！"
echo ""
echo "  cd $(pwd)/user-api-demo"
echo "  code ."
EOF

chmod +x ../verify-copilot.sh

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${GREEN}✓ 演示项目设置完成！${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo "项目位置: $DEMO_DIR/$PROJECT_NAME"
echo ""
echo "下一步操作："
echo ""
echo "1. 验证配置："
echo -e "   ${YELLOW}cd $DEMO_DIR && ./verify-copilot.sh${NC}"
echo ""
echo "2. 在 VS Code 中打开项目："
echo -e "   ${YELLOW}cd $DEMO_DIR/$PROJECT_NAME${NC}"
echo -e "   ${YELLOW}code .${NC}"
echo ""
echo "3. 测试 GitHub Copilot："
echo "   - 打开 internal/logic/createuserlogic.go"
echo "   - 尝试实现 CreateUser 方法"
echo "   - Copilot 会根据 ai-context 提供 go-zero 规范的建议"
echo ""
echo "4. 运行服务："
echo -e "   ${YELLOW}go run userapidemo.go${NC}"
echo ""
