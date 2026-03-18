# 标准研发项目目录结构
## 目录总览（代码+文档一体化）
```text
project-root/
├── src/
├── docs/
│   ├── 00-project-manage/
│   ├── 01-prd/
│   ├── 02-srs/
│   ├── 03-hld/
│   ├── 04-lld/
│   ├── 05-test/
│   ├── 06-deploy/
│   ├── 07-standard/
│   └── README.md
├── .gitignore
├── CHANGELOG.md
├── README.md
└── LICENSE
```

## 关键说明
- `src/` 按技术栈分层，目录职责清晰。
- `docs/` 与代码同仓管理，具备版本可追溯性。
- 根目录必须保留 README、CHANGELOG、.gitignore。

## 设计交付审计编排（强制）
```text
docs/design/
├── 01-prd/
│   └── PRD_Vx.y.z.md
├── 02-srs/
│   └── SRS_Vx.y.z.md
├── 03-hld/
│   └── HLD_Vx.y.z.md
├── 04-lld/
│   ├── LLD_core_xxx_Vx.y.z.md
│   ├── LLD_api_xxx_Vx.y.z.md
│   └── LLD_..._Vx.y.z.md
├── README.md
├── TRACEABILITY.md
├── PUBLISH_CHECKLIST.md
└── REVIEW_CHECKLIST.md
```

强制规则：
- 每阶段仅保留一个当前生效版本，历史进入 `archive/`。
- `README.md` 必须包含索引、阅读顺序、责任人。
- `TRACEABILITY.md` 必须覆盖“需求→规格→设计→代码→验证”。
- 发布前必须完成 `PUBLISH_CHECKLIST.md` 与 `REVIEW_CHECKLIST.md`。
