# Demo Project - GitHub Copilot with go-zero

这个演示项目展示如何使用 GitHub Copilot + ai-context 来开发 go-zero 应用。

## 快速开始

### 前置要求

- Go 1.19+
- Git
- VS Code with GitHub Copilot extension
- goctl (会自动安装)

### 设置演示项目

```bash
# 运行设置脚本
cd /Users/kevin/Develop/go/zero-skills/examples/demo-project
./setup-demo.sh
```

脚本会自动：
1. ✅ 检查并安装依赖（Go、goctl）
2. ✅ 创建演示工作目录
3. ✅ 配置 GitHub Copilot（添加 ai-context submodule）
4. ✅ 使用 goctl 生成 go-zero API 项目
5. ✅ 创建示例 API 定义（用户管理）
6. ✅ 生成完整的项目结构

### 验证配置

```bash
cd demo-workspace
./verify-copilot.sh
```

应该看到：
```
✓ ai-context submodule 存在
✓ copilot-instructions.md 符号链接存在
✓ 配置文件包含 go-zero 内容
✓ go-zero 项目结构正确
✓ 所有检查通过！
```

## 项目结构

```
demo-workspace/
├── .github/
│   ├── ai-context/              # ai-context submodule
│   └── copilot-instructions.md  # -> ai-context/00-instructions.md
├── userapidemo/
│   ├── etc/
│   │   └── userapidemo.yaml    # 配置文件
│   ├── internal/
│   │   ├── config/             # 配置定义
│   │   ├── handler/            # HTTP 处理层
│   │   │   ├── createuserhandler.go
│   │   │   ├── getuserhandler.go
│   │   │   └── listusershandler.go
│   │   ├── logic/              # 业务逻辑层
│   │   │   ├── createuserlogic.go
│   │   │   ├── getuserlogic.go
│   │   │   └── listuserslogic.go
│   │   ├── svc/                # 服务上下文
│   │   │   └── servicecontext.go
│   │   └── types/              # 类型定义
│   │       └── types.go
│   ├── user.api                # API 定义文件
│   ├── userademo.go            # 主程序入口
│   └── README.md               # 项目说明
└── verify-copilot.sh           # 验证脚本
```

## 测试 GitHub Copilot

### 测试场景 1: 实现 CreateUser 业务逻辑

1. 在 VS Code 中打开项目：
   ```bash
   cd demo-workspace/userapidemo
   code .
   ```

2. 打开文件：`internal/logic/createuserlogic.go`

3. 在 `CreateUser` 方法中，尝试输入以下注释：
   ```go
   // 验证用户名不能为空
   ```

4. **期望行为**：
   - ✅ Copilot 建议使用 go-zero 的错误处理方式
   - ✅ 使用 `errorx` 或标准错误返回
   - ✅ 遵循 Logic 层的职责划分
   - ✅ 正确使用 `req` 和 `types` 定义

5. **示例实现**（Copilot 可能建议）：
   ```go
   func (l *CreateUserLogic) CreateUser(req *types.CreateUserRequest) (*types.CreateUserResponse, error) {
       // 验证用户名不能为空
       if req.Username == "" {
           return nil, errors.New("username is required")
       }

       // 验证邮箱格式
       if req.Email == "" {
           return nil, errors.New("email is required")
       }

       // TODO: 保存到数据库
       user := types.User{
           Id:       1,
           Username: req.Username,
           Email:    req.Email,
           CreateAt: time.Now().Format("2006-01-02 15:04:05"),
       }

       return &types.CreateUserResponse{
           User: user,
       }, nil
   }
   ```

### 测试场景 2: 添加中间件

1. 创建新文件：`internal/middleware/auth.go`

2. 输入：
   ```go
   package middleware

   import "net/http"

   // JWT 认证中间件
   ```

3. **期望行为**：
   - ✅ Copilot 建议 go-zero 风格的中间件
   - ✅ 返回 `func(http.HandlerFunc) http.HandlerFunc`
   - ✅ 正确的错误响应处理
   - ✅ 使用 `httpx` 工具包

### 测试场景 3: 添加数据库操作

1. 创建注释：
   ```go
   // TODO: 添加 MySQL 连接和用户表操作
   ```

2. **期望行为**：
   - ✅ Copilot 建议使用 `sqlx` 或 `go-zero/core/stores/sqlx`
   - ✅ 建议使用 `goctl model` 生成 model 代码
   - ✅ 提供正确的数据库配置方式

## 对比测试

### 有 ai-context 的 Copilot

```go
// 输入：实现用户创建
// Copilot 建议：
func (l *CreateUserLogic) CreateUser(req *types.CreateUserRequest) (*types.CreateUserResponse, error) {
    // ✅ 正确的参数验证
    // ✅ 使用 go-zero 错误处理
    // ✅ 返回类型符合 types 定义
    // ✅ 遵循业务逻辑在 Logic 层的原则
}
```

### 没有 ai-context 的 Copilot

```go
// 输入：实现用户创建
// Copilot 可能建议：
func CreateUser(w http.ResponseWriter, r *http.Request) {
    // ❌ 直接在 handler 中写业务逻辑
    // ❌ 使用通用的 HTTP 写法，不符合 go-zero 规范
    // ❌ 错误处理可能使用 http.Error
}
```

## 验证效果

### 1. 检查 Copilot 配置

```bash
# 确认 Copilot 加载了配置
cat demo-workspace/.github/copilot-instructions.md | head -20

# 应该看到 go-zero 相关的指令
```

### 2. 测试代码建议质量

在实现业务逻辑时，观察 Copilot 的建议：
- 是否遵循三层架构？
- 是否使用正确的错误处理？
- 是否了解 go-zero 的工具包？

### 3. 运行项目

```bash
cd demo-workspace/userapidemo

# 运行服务
go run userapidemo.go

# 测试 API（在另一个终端）
curl http://localhost:8888/api/users
```

## 常见问题

### Q: Copilot 没有使用 go-zero 模式？

**A:** 检查：
1. VS Code 是否正确打开了项目目录？
2. `.github/copilot-instructions.md` 文件是否存在？
3. 重启 VS Code 让 Copilot 重新加载配置

### Q: 符号链接在 Windows 上不工作？

**A:** 在 Windows 上，使用管理员权限运行：
```cmd
mklink .github\copilot-instructions.md .github\ai-context\00-instructions.md
```

或者直接复制文件：
```cmd
copy .github\ai-context\00-instructions.md .github\copilot-instructions.md
```

### Q: goctl 命令未找到？

**A:** 安装 goctl：
```bash
go install github.com/zeromicro/go-zero/tools/goctl@latest
```

## 清理

删除演示项目：
```bash
rm -rf demo-workspace
```

## 更多资源

- [ai-context](https://github.com/zeromicro/ai-context) - GitHub Copilot 指令
- [zero-skills](https://github.com/zeromicro/zero-skills) - go-zero 知识库
- [go-zero 文档](https://go-zero.dev)
- [AI 生态指南](../../articles/ai-ecosystem-guide.md)
