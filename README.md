# prelaunch-listing

> **Pre-Launch Listing Generator (COSMO × Rufus)** —— 一个为**尚未上市的 Amazon 产品**生成 Rufus 友好型 Listing + 预测性 COSMO 报告的 Claude Skill。

## 这个 Skill 解决什么问题

新品上线前，卖家无法用 SP Prompts 数据做诊断（因为还没有数据）。这个 skill 反过来：

- 从**竞品 ASIN + 产品规格**出发
- 用 **COSMO 15 关系框架**推演 Rufus 大概率会问什么（Predicted Prompt Universe）
- 生成命中这些 Prompt 的 **Title / 5 Bullets / A+ 大纲 / Backend Keywords**
- 给出**预测性 Rufus 友好度评分**（明确标注为预测值）
- 输出 **D+30 / D+60 / D+90 上市后验证路线图**

最终交付：一份**单文件 HTML 报告**。

## 与 cosmo-report 的关系

```
新品选品 → prelaunch-listing (写 listing) → 产品上市 → cosmo-report (诊断优化)
                  ↑                                            |
                  └────── D+30 验证闭环 ←──────────────────────┘
```

| 对比项 | cosmo-report | prelaunch-listing（本 skill） |
|--------|--------------|------------------------------|
| 核心输入 | SP Prompts xlsx（真实广告数据） | 竞品 ASIN + 产品 spec |
| 输出类型 | 诊断（哪里有问题） | 生成（应该怎么写） |
| 语气 | "listing 缺少 X" | "建议 listing 包含 X" |
| 评分标签 | Rufus Friendliness Score | **Predicted** Rufus Friendliness Score |

## 安装

### 方法一：一键安装脚本（推荐）

```bash
git clone https://github.com/<your-org>/prelaunch-listing.git
cd prelaunch-listing
./install.sh
```

脚本会将 skill 复制到 `~/.claude/skills/prelaunch-listing/`。

### 方法二：手动复制

```bash
# 个人级别（所有项目都可用）
mkdir -p ~/.claude/skills/prelaunch-listing
cp -r SKILL.md references ~/.claude/skills/prelaunch-listing/

# 或项目级别（仅本项目可用）
mkdir -p your-project/.claude/skills/prelaunch-listing
cp -r SKILL.md references your-project/.claude/skills/prelaunch-listing/
```

安装后，在 Claude Code 中输入 `/prelaunch-listing` 即可触发。

## 使用方式

在 Claude Code 中直接调用：

```
/prelaunch-listing

产品：GL.iNet Beryl AX 旅行路由器
关键规格：Wi-Fi 6, 1800Mbps 双频, 内置 WireGuard/OpenVPN, USB 3.0, 手掌大小
目标人群：数字游民、出差商务人士
计划售价：$99
竞品 ASIN: B0XXXXXXX1, B0XXXXXXX2, B0XXXXXXX3
```

### 最小必需输入

1. **产品规格** —— 品类、关键参数（材料、尺寸、容量、性能数字）、USP、目标人群、计划售价
2. **竞品 ASIN** —— 3–5 个直接竞品 + 1–2 个品类头部

### 可选输入

3. 品牌资产（品牌调性、视觉语言、现有客户画像）
4. 同品牌其他 ASIN —— 用于跨型号自相残杀风险分析

## 输出报告包含

1. **Predicted Prompt Universe** —— Rufus 预测问题库（L1/L2/L3 分级）
2. **Competitor Benchmark** —— 竞品覆盖热力图，找差距
3. **Generated Listing Copy** —— Title / 5 Bullets / A+ 大纲 / Backend Keywords
4. **Predicted Rufus Friendliness Score** —— 各维度评分（带预测说明）
5. **Cross-Model Substitution Risk** —— 同品牌 SKU 自相残杀风险
6. **Post-Launch Verification Roadmap** —— D+30 / D+60 / D+90 行动计划

## 文件结构

```
prelaunch-listing/
├── SKILL.md                      # 主指令文件（触发条件 + 工作流程）
├── references/
│   ├── cosmo_framework.md        # COSMO 15 关系完整分类体系
│   └── report_design.md          # HTML 报告设计系统（暗色主题、组件、色彩）
├── install.sh                    # 一键安装脚本
├── LICENSE
└── README.md
```

## 重要说明

报告中所有分数与判断**明确标注为预测值**。COSMO 模型持续更新，真实 Rufus 行为可能存在偏差。产品上市 D+30 后，请用真实 SP Prompts 数据 + `cosmo-report` skill 回验预测准确度。

## License

MIT
