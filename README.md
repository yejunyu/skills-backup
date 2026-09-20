# Skills 清单

换机时按下面命令安装或更新。本仓库只记来源和用法，不保存公开 skill 的文件快照。

需要 Node.js（`npx skills`）。装完重启 Codex，或重新打开 Cursor。

```bash
npx skills update -g -y          # 更新已装的全部全局 skill
npx skills find <关键词>         # 搜索；目录 https://skills.sh/
```

---

## 新机器安装

### 编程

```bash
# 公开 skill
npx skills add OthmanAdi/planning-with-files -g -y --skill planning-with-files
npx skills add zeromicro/zero-skills -g -y
npx skills add github/awesome-copilot -g -y -s excalidraw-diagram-generator
npx skills add forrestchang/andrej-karpathy-skills -g -y -s karpathy-guidelines

# Matt Pocock 工程套件（安装时务必带上 setup-matt-pocock-skills）
npx skills add mattpocock/skills -g -y

# 用图把当前话题讲清楚
npx skills add https://github.com/humanlayer/skills -g -y --skill show-me

# 输出风格：i-have-adhd（装了不自动生效，要显式开）
npx skills add ayghri/i-have-adhd -g -y                        # Codex / Cursor / 通用
cp -R ~/.cursor/skills/i-have-adhd ~/.workbuddy/skills/        # WorkBuddy：npx skills 不认，手动复制后重启
~/.bun/bin/pi install https://github.com/ayghri/i-have-adhd    # Pi 原生包（pi 不在 PATH，二进制在 ~/.bun/bin/pi）

# 自维护：学习教练（本仓库）
# 复制 guided-code-learning/ 到 ~/.codex/skills/guided-code-learning
# 复制 tenx-learning/ 到 ~/.codex/skills/tenx-learning
# Cursor 再用一份：~/.cursor/skills/ 下各复制一次

# 自维护：Figma 高保真还原（独立仓库）
# git clone https://github.com/yejunyu/figma-ui-fidelity-kit.git
# cd figma-ui-fidelity-kit && ./install.sh --with-figwright && ./doctor.sh

# 工具（不是 npx skills）
# brew install rtk && rtk init -g --codex     # Cursor: rtk init -g --agent cursor
# Codex Ponytail:
#   codex plugin marketplace add DietrichGebert/ponytail
#   codex plugin add ponytail@ponytail
# pstack（Cursor 插件，聊天里）:
#   /add-plugin pstack
# AnySearch（会要你粘贴 API key）:
# ./scripts/install-anysearch.sh
```

### 非编程（Obsidian）

```bash
# kepano，4 个
npx skills add kepano/obsidian-skills -g -y \
  -s defuddle,obsidian-bases,obsidian-cli,obsidian-markdown

# Axton 可视化，3 个（替代 json-canvas）
npx skills add axtonliu/axton-obsidian-visual-skills -g -y

# 文档/代码库 → Obsidian 知识库 → 测验
npx skills add RoundTable02/tutor-skills -g -y
```

---

## 编程

### 日常写代码：Matt Pocock

来源：[mattpocock/skills](https://github.com/mattpocock/skills)

小而可组合的工程 skill，不接管整个开发流程。装完后，**每个仓库先跑一次** `/setup-matt-pocock-skills`：选 issue tracker（GitHub / Linear / 本地文件）、triage 标签、文档存放位置。

最常用的一条线：

1. **对齐**：改代码前用 `/grill-with-docs`。它会追问方案，并顺手维护项目的 `CONTEXT.md` 和 ADR（共享术语，减少 agent 啰嗦）。非代码话题用 `/grill-me`。
2. **落成规格**：讨论清楚后 `/to-spec`（写成 issue），或 `/to-tickets`（拆成带依赖的小票）。
3. **实现**：`/implement`。它按约定的缝用 `/tdd`（先红后绿），结束前用 `/code-review`（标准轴 + 规格轴，两个子 agent 并行）。
4. **卡住**：难 bug 或变慢用 `/diagnosing-bugs`（先做出能复现的红灯，再缩小、假设、打点、修、补回归）。
5. **太大**：一轮会话装不下的工作用 `/wayfinder`，在 tracker 上画决策地图，一次只解一张票。
6. **不知道用哪个**：`/ask-matt`。某句话没听懂：`/wait-what`。换会话：`/handoff`。

隔几天跑一次 `/improve-codebase-architecture`：扫「接口小、行为深」的加深机会，出 HTML 报告，再挑一个 grilling。它是巡检，不会替你拆泥球。

| 你说 | 它做什么 |
| --- | --- |
| `/grill-with-docs` | 追问 + 更新领域文档 |
| `/tdd` | 红-绿-重构，一次一个垂直切片 |
| `/code-review` | 对照仓库规范和原规格审 diff |
| `/prototype` | 用可丢弃的原型回答设计问题 |
| `/research` | 查一手来源，写成带引用的 Markdown |
| `/wizard` | 生成只有人能做的步骤的交互 bash（填 key、点控制台） |

### 把当前话题画出来：show-me

来源：[humanlayer/skills](https://github.com/humanlayer/skills) 的 `show-me`

只在你点名时用（不会自动抢对话）。说 `/show-me` 或「画一下」。它少写散文，用最小的图说明当前问题：伪代码、调用树、组件树、文件树、Mermaid，或一个聚焦的 HTML 文件并打开。一次通常只用一两种，不要全上。

### 其它 skill

#### planning-with-files

[OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files)

多步任务（大约 5 次工具调用以上）时用。在**项目根**（不是 skill 目录）维护三份文件：`task_plan.md`（阶段）、`findings.md`（发现）、`progress.md`（日志）。`/clear` 或崩溃后靠磁盘上的计划接上。入口常是 `/planning-with-files:plan`。

#### zero-skills

[zeromicro/zero-skills](https://github.com/zeromicro/zero-skills)

写 go-zero（REST / RPC / 数据库 / 熔断）时加载。可以说 `/zero-skills`，或直接问「用 go-zero 怎么做 X」。它按 Handler → Logic → Model 约束写法，并引用 `goctl`。

#### excalidraw-diagram-generator

[github/awesome-copilot](https://github.com/github/awesome-copilot/tree/main/skills/excalidraw-diagram-generator)

说「画流程图 / 架构图 / 思维导图 / 时序图」，它产出可在 Excalidraw 打开的 `.excalidraw`。支持流程图、关系图、思维导图、架构、数据流、泳道、类图、时序、ER。Obsidian 里手绘风格用下面的 `excalidraw-diagram`。

#### karpathy-guidelines

[forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)

写代码时的行为约束，不用单独下命令。四条：先想清楚再写、能少就少、只改该改的、用可验证的目标收尾。小事自行判断，不必每句都走这套。

#### i-have-adhd

[ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd)

改的是**回复的形状**，不是写代码的方法。默认装了不生效，必须显式开：

- Codex：`$i-have-adhd`
- Cursor / WorkBuddy：`/i-have-adhd`
- Pi：`/i-have-adhd` 切换，状态栏出现 `● ADHD ON`；`pi --adhd` 直接以该模式启动；`stop adhd mode` 或 `normal mode` 关

十条规则的要点：第一行就是能执行的动作；多步就编号、每步一个动作；结尾只留一个两分钟内能做的下一步；每轮重述「第 3 步 / 共 5 步」；时间给具体单位，不说「一会儿」；压住跑题，第二件事等第一件做完再单独提；错误只说位置、原因、修法；列表不超过 5 条；不要开场白和收尾客套。

想默认常开：Pi 用 `touch ~/.pi/agent/.i-have-adhd-always`（或写 `~/.pi/agent/i-have-adhd.json` 的 `alwaysOn: true`）；其它 agent 把那 10 条贴进各自的 User Rules / `AGENTS.md`。常开之前先想清楚——它会一直改所有回复的语气。

### 自维护

#### guided-code-learning

本仓库 [`guided-code-learning/`](./guided-code-learning/)。复制到 `~/.codex/skills/guided-code-learning`。

学习不是一轮讲完。说「用 guided-code-learning 学 xxx」：

1. 网上核对，只留最重要的约 20%（大约 5～10 个概念）。
2. 排成小章节，每章有练习和测验；不过关不翻章。
3. 全部通过后再做结业大作业。

进度写在项目的 `.learning/<主题>/`（`COURSE.md`、`syllabus.md`、`progress.md`、`capstone.md`）。新会话先读这些文件再继续。

Obsidian 知识库 + 测验用下面的 `tutor-skills`。

#### tenx-learning

本仓库 [`tenx-learning/`](./tenx-learning/)。复制到 `~/.codex/skills/tenx-learning`，Cursor 再复制到 `~/.cursor/skills/tenx-learning`。

打开一个陌生领域，或在写文章、做决策、面试、投资、谈判、演讲之前先建立判断。说「十倍速学 xxx」或「用 STORM 看看 xxx」：

1. 五视角对着检索结果互相质疑，压成一页简报，再挑刺改一版。
2. 只留五个真实资源，标出你在五级阶梯的哪一级，把核心约 20% 排成 10 次课。
3. 一次一题考到答不上来，费曼补缺口，最后压成一页速查表。

进度写在 `~/code/learning/<主题>/` 的 `brief.md`、`path.md`、`cheatsheet.md`、`loop.md`，不写进当前仓库。和 `guided-code-learning` 分开：那个不代做、要过关才翻章；这个先搭判断和结构。要改成课程制时，阶段二之后交给 `guided-code-learning`。

#### figma-ui-fidelity

[yejunyu/figma-ui-fidelity-kit](https://github.com/yejunyu/figma-ui-fidelity-kit)

```bash
git clone https://github.com/yejunyu/figma-ui-fidelity-kit.git
cd figma-ui-fidelity-kit
./install.sh --with-figwright
./doctor.sh
```

Figma 桌面版导入 [Figwright](https://github.com/awdr74100/figwright/releases/latest) 插件，打开目标文件并保持 Connected。不要只丢截图。

工作流：给**精确节点链接**、**真实路由**和**视口**（例如 1440×900 与 375×812）。实现以 Figma 结构为准，验收以页面截图 diff 为准。在被测项目里装 Playwright，全局装 `odiff-bin`，再用 kit 里的 `scripts/shoot.mjs` 和 `scripts/diff.sh`。触发词：`figma`、`还原这个 Frame`、`UI 还原`、`走查`。

### 工具（不是 Agent Skill）

#### RTK

[rtk-ai/rtk](https://github.com/rtk-ai/rtk)

压缩 agent 读到的 **shell 输出**（`git`、`ls`、测试日志），不是整张账单。

```bash
brew install rtk
rtk init -g --codex              # Codex
rtk init -g --agent cursor       # Cursor；若报 ~/.claude 不存在，先 mkdir -p ~/.claude
```

之后 agent 跑 `git status` 会被改写成 `rtk git status`，返回压缩结果。看节省：`rtk gain`。内置的 Read/Grep 不经过这个 hook。crates.io 上另有同名包，用 Homebrew 或官方安装脚本。

#### Ponytail

[DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail)

让 agent 少写代码：能复用就不新建，能一行就不写框架。

```bash
# Codex
codex plugin marketplace add DietrichGebert/ponytail
codex plugin add ponytail@ponytail
# 然后在 /hooks 里信任它的两个生命周期钩子，开新线程

# Cursor：先 clone，再
node ponytail/scripts/cursor-hooks.js install
```

对话里发 `/ponytail lite`、`/ponytail full`、`/ponytail ultra` 或 `/ponytail off` 切换强度。需要本机有 `node`。

#### pstack

来源：[cursor/plugins `pstack/`](https://github.com/cursor/plugins/tree/main/pstack)。Cursor 插件，不要用 `npx skills add`。

聊天里 `/add-plugin pstack`。日常只记两个命令：先 `/setup-pstack` 选模型，再 `/poteto-mode` 说目标和可检查的完成条件。其余 skill 由 mode 按 playbook 调用。新话题要说 `new task`，否则会接着上一件做。

用法、和本仓库其它 skill 的接法见 [`research/pstack.md`](./research/pstack.md)。

#### AnySearch

[认证](https://www.anysearch.com/docs/auth) · [MCP](https://www.anysearch.com/docs/mcp-install) · [Skill](https://www.anysearch.com/docs/skill-install)

统一搜索，不绑某一个 agent。带 key 走付费配额；key 无效会 401/403，不会悄悄变成匿名。**本仓库不存 API key**；换机后重新跑脚本粘贴。key 只写到本机 `~/.anysearch/.env` 和各 skill 目录的 `.env`。

```bash
./scripts/install-anysearch.sh
```

脚本会打开控制台让你粘贴 key，再逐项问装到哪（回车是装，`n` 是跳过）：

- skill：`~/.codex/skills/anysearch`、`~/.agents/skills/anysearch`、`~/.cursor/skills/anysearch`
- WorkBuddy：脚本不认。从上面某个目录复制到 `~/.workbuddy/skills/anysearch`，然后重启
- MCP：各客户端自己的配置，见[安装文档](https://www.anysearch.com/docs/mcp-install)。脚本这一步只写入 Cursor 的 `~/.cursor/mcp.json`（`mcp-remote` + Bearer）；Codex 在 `~/.codex/config.toml`

装完重载对应的客户端。之后让那个 agent 用 AnySearch 搜，而不是自己猜 API 参数。

### Codex 自带（一般不用从这里装）

| Skill | 用途 |
| --- | --- |
| `openai-docs` | 查 OpenAI 官方文档（MCP） |
| `skill-creator` | 新建 skill |
| `skill-installer` | 从 GitHub 装 skill |

仓库：[openai/skills](https://github.com/openai/skills) 的 `skills/.system`。

---

## 非编程（Obsidian）

现阶段除了 Obsidian，其余一律放编程。

### kepano 四件套

来源：[kepano/obsidian-skills](https://github.com/kepano/obsidian-skills)

| Skill | 什么时候 | 怎么用 |
| --- | --- | --- |
| `obsidian-markdown` | 写/改库里的 `.md` | 直接让它处理 wikilink、embed、callout、properties；不要当普通 Markdown 乱改 |
| `obsidian-bases` | 写 `.base` | 视图、过滤、公式、汇总 |
| `obsidian-cli` | 在已打开的 Obsidian 里搜笔记、改属性、调试插件 | 先 `obsidian help`；常用 `obsidian search`、`read`、`create`、`daily:append` |
| `defuddle` | 用户给了普通网页 URL，要读正文 | 用 `defuddle parse <url> --md`，不要用网页抓取把导航一起吞进来。`.md` 链接直接抓原文 |

### 可视化三件套

来源：[axtonliu/axton-obsidian-visual-skills](https://github.com/axtonliu/axton-obsidian-visual-skills)

替代原先的 `json-canvas`。说「画 Canvas / Mermaid / Excalidraw」时用；默认写进 Obsidian 库。

| Skill | 什么时候 | 怎么用 |
| --- | --- | --- |
| `obsidian-canvas-creator` | 写 `.canvas`（思维导图或自由布局） | 说「Canvas」「思维导图」；它会调间距、上色、分组，避免节点重叠 |
| `mermaid-visualizer` | 要流程图 / 时序图 / 状态图，并在 Obsidian 里渲染 | 说「Mermaid」「时序图」；内置语法纠错 |
| `excalidraw-diagram` | 要手绘风格图，在 Obsidian 里打开 | 说「Excalidraw」「画图」；默认出 `.md`。独立 `.excalidraw` 仍用编程侧的 `excalidraw-diagram-generator` |

### tutor-skills

[RoundTable02/tutor-skills](https://github.com/RoundTable02/tutor-skills)

把文档或代码库变成 Obsidian StudyVault，再用测验暴露知识盲区。两步：

1. `/tutor-setup`：扫描当前目录（PDF / Markdown / 网页 / 代码库），生成带笔记、仪表盘、练习题的 `StudyVault/`。
2. `/tutor`：无提示测验，按概念记进度；弱项再钻。

和编程侧的 `guided-code-learning` 不同：那个是章节制教练（讲→练→过关）；这个是「先建库，再反复测」。

---

## 装到哪里

| Agent | 路径 |
| --- | --- |
| Codex | `~/.codex/skills` |
| Cursor | `~/.cursor/skills` 或项目 `.cursor/skills` |
| 通用 | `~/.agents/skills` |
| WorkBuddy | `~/.workbuddy/skills` |
| Pi | `~/.pi/agent/skills`；GitHub 包用 `pi install <url>`（二进制在 `~/.bun/bin/pi`，不在 PATH），登记在 `~/.pi/agent/settings.json` 的 `packages` |

`npx skills add -g` 按已安装的 agent 写入对应目录，**不认 WorkBuddy** —— 要手动从上面某个目录复制（`cp -R <源>/<skill> ~/.workbuddy/skills/`），装完重启 WorkBuddy 才会加载。

新增条目：在「新机器安装」和对应章节（编程 / 非编程）各写一次来源、安装命令、最常用的一步。除了 Obsidian 都放编程。自维护的学习 skill 留在本仓库；Figma kit 只记 GitHub；pstack 的接法记在 `research/pstack.md`。
