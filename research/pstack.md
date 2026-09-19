# pstack 工作流

来源：[`cursor/plugins` `pstack/`](https://github.com/cursor/plugins/tree/main/pstack)，`main`，plugin 版本 `0.15.2`（[plugin.json](https://github.com/cursor/plugins/blob/main/pstack/.cursor-plugin/plugin.json)）。作者 Lauren Tan（[@poteto](https://x.com/poteto)）。MIT。调查日 2026-09-18。

## 它是什么

Cursor 插件，不是独立 CLI。安装入口是聊天里的 `/add-plugin pstack`（[README](https://github.com/cursor/plugins/blob/main/pstack/README.md)、[guide/01-setup](https://github.com/cursor/plugins/blob/main/pstack/docs/guide/01-setup.md)）。`plugin.json` 只注册 `./skills/` 和 `./agents/`。

目标写在 README 开头：少写代码、提高可验证性，从而敢开多个 agent 并行。日常只记两个命令：`/setup-pstack` 选模型，`/poteto-mode` 做需要严谨的活。其余 skill 由 mode 按步骤调用。

`/poteto-mode` 是 sticky mode（`mode: true`，`disable-model-invocation: true`）。进了就跨轮生效，说退出才停。新话题要说 `new task`，否则它会接着上一个 playbook 做（[guide/02](https://github.com/cursor/plugins/blob/main/pstack/docs/guide/02-poteto-mode.md)）。

## 一条任务怎么走

```text
目标 + 可检查的完成条件
  -> /poteto-mode 读原则索引，匹配 23 个 playbook 之一
  -> 把该 playbook 的步骤原样抄进 todo（跳过的步骤留着，写 skip: 原因）
  -> 步骤触发 how / why / architect / arena / swarm / interrogate / tdd / unslop
  -> 父会话当 lead：设计、审 diff、在真实表面上验证
  -> 写代码的子 agent 用 poteto-agent（默认后台、按角色选模型）
  -> Opening a PR：worktree、小提交、conventional title、简报式正文
  -> 用户另说才 Babysit；再另说才 Shipping
```

路由表在 [poteto-mode/SKILL.md](https://github.com/cursor/plugins/blob/main/pstack/skills/poteto-mode/SKILL.md) 的 Playbooks 一节。常见几条：

| 你说的事 | playbook | 关键步骤 |
| --- | --- | --- |
| 只问怎么工作、为什么这样 | Investigation | 只读，不改代码 |
| 缺陷 | [Bug fix](https://github.com/cursor/plugins/blob/main/pstack/skills/poteto-mode/playbooks/bug-fix.md) | 自己复现 → 用运行时证据二分原因（并行 how + why）→ 跨函数才 architect → 同表面验证 → 有便宜测试才先写失败测试 |
| 新行为 | [Feature](https://github.com/cursor/plugins/blob/main/pstack/skills/poteto-mode/playbooks/feature.md) | how → architect → 吞吐检查点（阻塞步骤 / 可并行流 / 共享状态 / 最小拆分）→ 子 agent 写代码，lead 审 diff → 真实验证 → 小提交 |
| 只改结构 | Refactoring | 先钉住现有行为，再动结构 |
| 有测量的慢 | Perf / Hillclimb | 对照基线；Hillclimb 是同一指标持续循环，一次一个假设，赢的留下，其余丢掉 |
| 离开后要能审 | figure-it-out + show-me-your-work | 先设计这一跑的阶段，决策记进 TSV |
| 多日、很多 PR、一个协调会话 | [Orchestrate](https://github.com/cursor/plugins/blob/main/pstack/skills/poteto-mode/playbooks/orchestrate.md) | 协调者写 brief、不写代码；一个 session 能做完的不要走这里 |

没有匹配的 playbook 走 `figure-it-out`，它临时设计一套步骤。README 明确不另做规划 skill，认为最好的规格是代码；要计划就用 Cursor 自带 Plan mode。

## 并行的三种形状

来源：[guide/04](https://github.com/cursor/plugins/blob/main/pstack/docs/guide/04-design.md)、[arena](https://github.com/cursor/plugins/blob/main/pstack/skills/arena/SKILL.md)、[swarm](https://github.com/cursor/plugins/blob/main/pstack/skills/swarm/SKILL.md)。

- **architect**：先 how（动所有权再加 why），再 arena 出几份设计。每份先写调用方用法，再写类型和模块图。默认接着实现；要看设计就说 `with checkpoint`。
- **arena**：同一份 brief，N 个候选各写各的 worktree。只读 cross-judge（尽量换模型家族）打分。协调者通读后选一个底座，把输家里值得留的想法手工嫁接进去，再验证。用来比设计或实现，不用来做覆盖。
- **swarm**：按切片、覆盖矩阵或事先声明的赛马分出去。每个 worker 回报 `PASS` / `ISSUES` / `BLOCKED`。父会话等齐，交一份表。官方 swarm 默认 `environment: cloud`，只有必须用本机（浏览器、本机 transcript、模拟器、只在这台机器上的登录态）才改 local。

隔离规则：并行写代码的 agent 不能共用一个工作区。一个任务一个分支一个 worktree（[guide/02](https://github.com/cursor/plugins/blob/main/pstack/docs/guide/02-poteto-mode.md)）。

模型不写死在每次调用里。`/setup-pstack` 探测本会话能传给 Task 的 slug，问推理预算（unlimited / large / medium / small），把角色表写到 `~/.cursor/rules/pstack-models.mdc`（`alwaysApply: true`）。`inherit-parent` 和 `auto` 不是模型名，意思是省略 `model`，子 agent 跟父聊天走。面板角色是列表，列表长度就是并行人数。没写进规则的角色回落到 skill 默认：写代码默认 `grok-4.6-fast-xhigh`，判断和最难的改动默认 `claude-fable-5-1-thinking-max`，arena / architect / interrogate 默认四模型面板（fable、sol、grok、opus）。检测不到的 slug 禁止写入（[setup-pstack](https://github.com/cursor/plugins/blob/main/pstack/skills/setup-pstack/SKILL.md)）。

子 agent 默认 `run_in_background: true`。playbook 里写代码的委托用 `poteto-agent`，它必须先读完 poteto-mode。换成 `generalPurpose` 会跳过这次阅读。how / why / interrogate / swarm 按各自 skill 指定类型，不要覆盖成 poteto-agent（[poteto-agent](https://github.com/cursor/plugins/blob/main/pstack/agents/poteto-agent.md)）。

## 验证和落地

「能编译」不算完成（[principle-prove-it-works](https://github.com/cursor/plugins/blob/main/pstack/skills/principle-prove-it-works/SKILL.md)、[guide/06](https://github.com/cursor/plugins/blob/main/pstack/docs/guide/06-verify-and-ship.md)）。

- CLI 跑真实命令，UI 走真实流程，性能给 before → after，存储读回写入值。
- 项目没有现成驱动方式时，setup 会提议一次 `/create-verification-skill`，生成 `.cursor/skills/verify-<app>/`（Launch / Doctor / Drive / Evidence / Cleanup + feature map），并先自己跑通一遍。
- UI / CLI 的控制面技能 `control-ui`、`control-cli`，以及提交前的 `/deslop`，在 **cursor-team-kit**，pstack 不打包。没有 kit 时用白话要求同样结果。
- Opening a PR 不启动 Babysit。Babysit 处理冲突、评论、CI，停在可合并，不合并。Shipping 才落地：每个 PR 由没写过它的 agent 独立验证，只合并从栈底连续验证通过的那一段。
- 过夜合同（[guide/07](https://github.com/cursor/plugins/blob/main/pstack/docs/guide/07-overnight.md)）：完成条件必须能过或失败，独立 worktree，决策日志，`/loop` 是 Cursor 内置唤醒而不是 pstack skill。时长不是完成条件。单任务走 Autonomous run；独立 PR 队列走 Autopilot-full（要合并）或 Autopilot-stack（只交栈，人来合）；多日项目才 Orchestrate。

Orchestrate 的协调者本地运行，只写 brief。状态在当前 agent store 的 `orchestrate/<project-slug>/`，经 `scripts/orch/orch.ts` 读写。每个 worker 的 brief 必须有 GOAL、SCOPE、CONTEXT、ACCEPTANCE、VERIFY、TIMEBOX、FORBIDDEN、REPORT。验证账本按 PR + head SHA 记账，CI 绿不是判决。

## 和本仓库现有习惯的接法

本仓库是 skill 清单，不是 pstack 的安装位置。pstack 用 `/add-plugin`，不要用 `npx skills add` 拆进 `~/.codex/skills`。playbook、`poteto-agent`、`~/.cursor/rules/pstack-models.mdc`、`/loop`、cloud Task 都绑在 Cursor 上。

建议的日常入口：非平凡的 Cursor 任务用 `/poteto-mode` 说目标和完成条件，不要在提示里点名一串 skill。Figma 还原继续用自维护的 `figma-ui-fidelity`，不要改走 visual-parity playbook。浏览器验收已经写在用户规则里，和 Prove It Works 一致；某个 app 反复要验时再跑 `/create-verification-skill`。

冲突要在提示里压过去，否则 mode 会按自己的默认做：

- pstack 的 Opening a PR 和 Feature 步骤要求 liberal commit。用户规则是没明确要求就不提交。过夜或开 PR 之前先说「不要 commit，除非我明确说」。
- 不可逆动作两边一致：force-push、部署、删数据要停。
- 已有的 `tdd`、`grilling`、`prototype`、`diagnosing-bugs`、Karpathy / Ponytail 不要和对应 playbook 叠着喊。mode 已经会在便宜测试路径上走 `/tdd`，在跨边界时走 architect。`grilling` 是对人追问方案；`/interrogate` 是多模型拆 diff。要第二意见用后者。
- Plan mode 可以先用。不要再同时开 `planning-with-files` 和 Orchestrate 的 store，两套账本会分叉。

先不要开的：Benny（Slack 缺陷分诊自动化，文件默认不注册成 slash skill）、`/make-bot-ui`、`/automate-me`（从自己的 transcript 抽一个个人 mode，等 poteto-mode 用顺了再考虑）。
