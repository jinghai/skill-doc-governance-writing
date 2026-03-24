---
name: "doc-governance-writing"
description: "Use when writing or reorganizing PRD/SRS/HLD/LLD docs to enforce audit-friendly folder layering, code-consistent content, and governance artifacts."
---

# 文档治理与工程一致性写作技能

## Overview
将“审计友好编排”与“工程友好内容”同时落地。  
本技能适用于设计文档编写、改版、补齐、归档、评审前整理。

## When To Use
- 用户提到 PRD、SRS、HLD、LLD 编写或补全
- 用户提到“文档整理”“设计文档归档”“审计”“评审”
- 用户仅说“整理文档”“归档”但未限定目录，且仓库内存在设计类文档散落场景
- 用户要求将文档与源码一致、可追溯、可发布
- 用户要求输出到 `docs/design` 或类似交付目录

## Boundary
- 本技能聚焦 `docs/design` 交付层，不负责 `docs/项目规范` 的主规范治理。
- 涉及项目规范治理时，先调用 `project-governance-execution`。
- 用户同时提到“提交工作区”“归档计划”“整理链接”时，这些都属于收尾动作，不得覆盖 `docs/design` 交付主目标。

## Portability Mode
- 本技能采用 `local-first` 资产包模式，避免跨项目复制后失效。
- 资产清单定义在 `MANIFEST.json`。
- 内置模板目录：`assets/templates/`。
- 当目标仓库缺少 `docs/文档模板` 时，必须先执行 Bootstrap，再开始文档编写。

## Tools
- 本技能自带项目内工具脚本：`tools/doc-skillctl.sh`。
- 脚本仅在“已挂载本技能”的项目中可用，不做全局安装。
- 推荐调用方式：
  - `bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh doctor`
  - `bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh install <repo-url>`
  - `bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh update-all`
  - `bash ./.trae/skills/doc-governance-writing/tools/doc-skillctl.sh export-repo /Users/jinghai/Projects/open-source/skills`

## Bootstrap Gate
执行前必须先检查：
1. `docs/文档模板` 是否存在
2. 7份模板文件是否齐全
3. 模板版本是否满足当前任务

若不满足，按下列映射初始化（默认只补缺失，不覆盖已有）：
- `assets/templates/01-standard-project-structure.md` → `docs/文档模板/01-标准项目目录结构.md`
- `assets/templates/02-document-format-spec.md` → `docs/文档模板/02-文档格式规范.md`
- `assets/templates/03-prd-template.md` → `docs/文档模板/03-产品需求文档 PRD.md`
- `assets/templates/04-srs-template.md` → `docs/文档模板/04-软件需求规格说明书 SRS.md`
- `assets/templates/05-hld-template.md` → `docs/文档模板/05-概要设计说明书 HLD.md`
- `assets/templates/06-lld-template.md` → `docs/文档模板/06-详细设计说明书 LLD.md`
- `assets/templates/07-doc-governance-spec.md` → `docs/文档模板/07-文档治理与审计规范.md`

可选远程模式：
- 若团队维护统一模板仓库，可按 `MANIFEST.json` 版本做远程同步。
- 离线场景必须回退本地资产包，不得跳过模板校验。

## Required Outputs
必须同时产出两类结果：

1. **阶段文档层**
- `01-prd/PRD_Vx.y.z.md`
- `02-srs/SRS_Vx.y.z.md`
- `03-hld/HLD_Vx.y.z.md`
- `04-lld/LLD_<module>_Vx.y.z.md`

2. **治理文档层**
- `README.md`（索引、阅读顺序、责任人）
- `TRACEABILITY.md`（需求→规格→设计→代码→验证）
- `PUBLISH_CHECKLIST.md`（发布前门禁）
- `REVIEW_CHECKLIST.md`（评审结论）

若源文档散落于 `需求/`、`docs/` 其他目录、`README` 链接或专题目录，必须先建立来源清单与归位映射，再迁移或重组到 `docs/design`。

## Directory Standard
```text
docs/design/
├── 01-prd/
├── 02-srs/
├── 03-hld/
├── 04-lld/
├── README.md
├── TRACEABILITY.md
├── PUBLISH_CHECKLIST.md
└── REVIEW_CHECKLIST.md
```

## Content Standard
- 章节结构必须对齐模板（基础信息、变更履历、核心章节、附件）
- API 路径、响应结构、配置项名称必须与当前源码一致
- 核心流程图必须可映射到真实模块与方法
- 性能/可用性指标必须可验证，禁止臆造

## Governance Gates
发布前必须全部满足：
- 目录分层完整
- 文档命名规范合规
- 追溯矩阵完整
- 出版清单完整
- 评审清单完整
- 抽样源码一致性通过

## Integration with Superpowers
- 保持流程技能优先：
  - `using-superpowers`
  - 实现类任务前 `test-driven-development`
  - 异常类任务前 `systematic-debugging`
  - 完成声明前 `verification-before-completion`
- 本技能只负责设计文档治理，不替代实现流程技能。

## Execution Checklist
1. 执行 Bootstrap Gate，确保模板资产可用
2. 盘点仓库内现有设计文档、需求文档、专题文档与 README 链接中的候选来源
3. 建立候选来源到 PRD/SRS/HLD/LLD 的归类与归位映射
4. 按分层目录重排文档；若 `docs/design` 不存在，先建标准结构再迁移内容
5. 补齐治理文档四件套
6. 抽样核对源码一致性
7. 更新发布与评审状态
8. 若任务包含“提交”“归档”“更新索引”，仅可在上述交付完成后作为收尾执行

## Common Mistakes
- 只写内容不建治理文档
- 目录分层正确但接口路径沿用旧版本
- LLD 按模块拆分后未补追溯矩阵
- 发布前未填写评审和出版清单
- 复制技能到新仓库后，跳过模板初始化直接开写
- 在未挂载技能的项目里直接调用工具脚本
- 仅修改 README 链接或目录索引，就宣称完成文档整理
- 仅移动文件到 `archive/`，未建立 `docs/design` 分层交付
- 仅更新规则文件、技能文件或提交说明，未完成设计文档治理
- 用户说“整理文档并提交”时，先提交已有工作区，导致主任务被提交动作覆盖

## Done Criteria
- 文档可被审计快速定位
- 文档可被研发直接执行
- 需求到代码存在显式追溯链路
- `docs/design` 分层目录与治理四件套齐备，或对缺失项有显式登记
- 已存在设计类原始文档时，来源清单与归位映射清晰可追溯
- 仅当分层交付完成后，归档、索引更新、提交工作区才可视为完成收尾
