---
name: prelaunch-listing
description: >
  Generate a Rufus-optimized listing and COSMO pre-launch report for a new Amazon product that
  has NOT yet launched (no SP Prompts data exists). Use this skill whenever a seller asks for
  help writing a listing for a new product, generating pre-launch copy, creating a COSMO report
  for an unlaunched product, or optimizing a new product's listing before going live on Amazon.
  Also trigger when the user says things like "新品listing", "新产品文案", "上市前listing",
  "pre-launch listing", "帮我写listing", "新品COSMO报告", "还没上架的产品怎么写listing",
  or any request involving writing Amazon listing copy from scratch using COSMO/Rufus methodology.
  This skill uses competitor proxy analysis + product specs to predict the Prompt universe and
  generate listing copy that maximizes Rufus friendliness BEFORE the product goes live.
  Do NOT use the cosmo-report skill for pre-launch products — that skill requires real SP Prompts
  data. This skill is the correct choice when no advertising data exists yet.
---

# Pre-Launch Listing Generator (COSMO × Rufus)

## What this skill does

Generates a complete, Rufus-optimized Amazon listing and predictive COSMO report for a product
that has NOT yet launched. Unlike the cosmo-report skill (which diagnoses existing campaigns),
this skill works from competitor data and product specs to **predict** what Rufus will ask and
**generate** listing copy that answers those questions with high typicality.

Output is a **single HTML file** containing:
1. **Predicted Prompt Universe** — what Rufus will likely ask about this product, classified L1/L2/L3
2. **Competitor Benchmark** — how competitors cover each predicted prompt, where the gaps are
3. **Generated Listing Copy** — Title, 5 Bullet Points, A+ content outline, Backend keywords
4. **Predicted Rufus Friendliness Score** — scored per dimension (clearly labeled as prediction)
5. **Cross-Model Substitution Risk** — if the seller has other SKUs, assess cannibalization risk
6. **Post-Launch Verification Roadmap** — D+30/D+60/D+90 action plan

---

## Core Methodology Difference

| Dimension | cosmo-report (existing products) | prelaunch-listing (this skill) |
|-----------|----------------------------------|-------------------------------|
| Core input | SP Prompts xlsx (real ad data) | Competitor ASINs + product specs |
| Data source | Seller's ad console | Competitor listings, reviews, category data |
| COSMO classification | Based on actual Prompt performance | Inferred from competitor proxy |
| Output type | Diagnostic (what's wrong) | Generative (what to write) |
| Language tone | "Listing缺少X" (diagnostic) | "建议listing包含X" (prescriptive) |
| Score label | Rufus Friendliness Score | **Predicted** Rufus Friendliness Score |

**Critical language rule**: This report must NEVER use diagnostic language like "listing缺少X参数".
Everything is prescriptive: "建议listing包含X参数以覆盖L1 Prompt". No verification = no diagnosis
applies even more strongly here, since there is no live listing to verify against.

---

## Workflow

### Step 0 — Gather Inputs

The seller provides (minimum viable input is items 1 and 2):

| Input | Content | Who fills it |
|-------|---------|-------------|
| 1. Product Spec Sheet | Product name, category, key specs (materials, dimensions, capacity, performance numbers), USP, target audience, planned price | Seller |
| 2. Competitor ASINs | 3–5 direct competitors + 1–2 category leaders | Seller |
| 3. Brand Assets (optional) | Brand voice, visual language, existing customer profiles | Seller |
| 4. Same-brand ASINs (optional) | If the seller has other products already on Amazon, list them for cross-model substitution risk analysis | Seller |

If the seller provides an xlsx template (`PreLaunch_Input_Template`), parse it with openpyxl.
If they provide info in chat, extract and organize it.

### Step 1 — Pull Competitor Data

For each competitor ASIN:
1. `web_fetch` on `https://www.amazon.com/dp/[ASIN]` with `html_extraction_method: markdown`
2. Extract: Title, Bullet Points, Product Description, A+ content text, key specs
3. If `web_fetch` fails, try `web_search` for `[product name] amazon [ASIN]`
4. Note which COSMO relations each competitor's listing covers well vs poorly

For competitor reviews (if accessible):
1. `web_search` for `[competitor product] amazon reviews` to find review themes
2. Cluster review language by COSMO relation types (what buyers praise = capable_of signals,
   what scenarios they mention = used_for/used_in signals)

### Step 2 — Build Predicted Prompt Universe

Using the COSMO 15-relation framework (read `references/cosmo_framework.md`), generate predicted
Rufus Prompts by:

1. **L1 Prompts (高典型性)**: For each key product spec, generate `capable_of`, `used_for_func`,
   `used_to`, and `xWant` prompts. These are the highest-value prompts.
   - Example: Product has "1800Mbps dual-band" → Predict: "Does [brand] have a router with gigabit speeds?"
   - Example: Product has "pre-installed VPN" → Predict: "Does [brand] have a router with VPN built in?"

2. **L2 Prompts (中典型性)**: For each target scenario, audience, and use location, generate
   `used_for_eve`, `used_for_aud`, `used_in_loc`, `used_with`, `used_by` prompts.
   - Example: Target audience "digital nomads" → Predict: "What router is best for remote workers?"

3. **L3 Prompts (低典型性)**: Generate generic `is_a` and `xInterested_in` prompts.
   - These are low value but will appear. Flag them for monitoring, not investment.

Cross-reference against competitor data to identify:
- **Covered prompts**: Competitors answer well → must match or exceed
- **Gap prompts**: No competitor answers well → opportunity to own
- **Crowded prompts**: Many competitors answer → hard to differentiate

### Step 3 — Generate Listing Copy

Follow COSMO typicality rules strictly. Read `references/cosmo_framework.md` for the full taxonomy.

**Title (≤200 chars, front-load first 80)**:
- First 80 chars: Brand + Product type + #1 differentiating L1 spec (with number)
- Remaining: Secondary L1 specs + primary L2 scenario keyword

**5 Bullet Points** (each maps to a predicted L1 Prompt cluster):
- Use COSMO triple format: `[FEATURE LABEL]: [product] capable of [specific function] – [exact spec with numbers] for [use case]`
- Every bullet must contain at least one specific number/measurement
- Order by predicted Prompt frequency (most common L1 prompt cluster first)

**A+ Content Outline** (each module maps to an L2 scenario):
- Module 1: Hero banner with primary USP + key number
- Module 2–4: Each covers one L2 scenario (event/audience/location)
- Module 5: Comparison chart vs competitors (feature × feature)

**Backend Keywords**:
- All L1 prompt keywords NOT already in Title/Bullets
- L2 scenario terms not covered in A+
- Do NOT stuff L3 terms

**Brand Story (if Brand Registry)**:
- Handle L3 "why choose [brand]" prompts here
- Not high conversion but provides brand context

### Step 4 — Predict Rufus Friendliness Score

Score the generated listing against the predicted Prompt universe. Use the same dimensions
as the cosmo-report skill but clearly label everything as **PREDICTED**:

| Dimension | Weight | How to Score |
|-----------|--------|--------------|
| capable_of 功能覆盖度 | 40% | % of predicted L1 Prompts with specific numbers/specs in listing |
| Typicality 质量 | 30% | Quality of descriptions (vague=30, specific=80, with numbers=100) |
| 前80字符意图密度 | 15% | Do Title's first 80 chars contain key L1 feature words? |
| L2/L3场景覆盖 | 10% | Diversity of scenario/audience coverage in Bullets + A+ |
| Cross-Model Risk | -5% | Deduct if same-brand SKUs have overlapping feature descriptions |

**Rating**: 0–40 = 🔴 Critical, 41–60 = 🟡 Needs Work, 61–80 = 🟢 Good, 81–100 = ✨ Excellent

**MANDATORY caveat** in the report: "本分数为预测值，基于COSMO方法论和竞品数据推演。
COSMO模型持续更新，实际Rufus行为可能与预测存在偏差。建议上市D+30后使用真实SP Prompts数据进行验证。"

### Step 5 — Cross-Model Substitution Risk (if applicable)

If the seller has other ASINs already on Amazon:
1. `web_fetch` each existing ASIN's listing
2. Compare feature descriptions with the new product's generated listing
3. Flag any overlapping descriptions that could cause Rufus to recommend the wrong SKU
4. Suggest differentiation strategies (e.g., "existing SKU emphasizes portability,
   new SKU should emphasize performance/throughput")

### Step 6 — Post-Launch Verification Roadmap

This section is MANDATORY. It's what turns a one-time prediction into a data loop.

| Timeline | Action | Deliverable |
|----------|--------|-------------|
| D+30 | Pull first SP Prompts report | Compare predicted vs actual Prompt universe; calculate hit rate |
| D+60 | Run full cosmo-report skill | First real diagnostic; identify prediction misses |
| D+90 | Review prediction accuracy | Feed back into methodology; adjust listing if needed |

Include exact Amazon console navigation paths for pulling SP Prompts data.

---

## HTML Report Structure

Use the same design system as the cosmo-report (read `references/report_design.md`).
Key visual differences from the diagnostic report:

1. **Hero header**: Include "预测性报告 · Pre-Launch" badge prominently.
   Use a different accent — amber/yellow (#f4a261) instead of red for the badge,
   to visually distinguish from diagnostic reports.

2. **Predicted Prompt Universe table**: Same table format as cosmo-report's COSMO Analysis,
   but columns are: Predicted Prompt | COSMO Relation | Level | Competitor Coverage | Listing Coverage

3. **Competitor Benchmark**: Heat map or coverage matrix showing each competitor's
   coverage of each predicted prompt

4. **Generated Listing**: Display Title, Bullets, A+ outline, Backend in styled code blocks
   with copy-paste formatting

5. **Predicted Score**: Same score ring component but with amber color and "PREDICTED" label

6. **Verification Roadmap**: Timeline visualization with D+30/D+60/D+90 milestones

---

## Output

Save the report as `[ProductName]_PreLaunch_COSMO优化报告.html` in `/mnt/user-data/outputs/`
and call `present_files` to share it with the user.

Tell the user: "这是一份预测性报告。下载后用浏览器打开查看。产品上市30天后，请提供真实SP Prompts数据，我们会出具验证报告。"

---

## Reference Files

- `references/cosmo_framework.md` — Full 15-relation COSMO taxonomy with examples and typicality scoring
- `references/report_design.md` — HTML/CSS design system for the report

These are the same reference files used by the cosmo-report skill. Read them when you need
detail on classification rules or when writing the HTML output.
