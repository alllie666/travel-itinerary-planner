# travel-itinerary-planner

一个面向国内旅行者的 **Claude Code / Codex 旅游规划 Skill**：根据你的时间、兴趣、预算和交通方式做攻略，可选择 HTML、分页图片、长图、PDF、飞书攻略或高德路书。

它由双方共同迭代：先有川西自驾旅行中整理的操作手册和 Skill，再发展出云南公共交通旅行的研究与排版能力。本版保留一个统一入口，按自驾、公共交通和混合交通分流。主要信息来源包括小红书、携程、飞猪、官方公告和高德。[脱敏案例](examples/README.md)记录了两类旅行的规划经验，不包含私人聊天、订单或完整原始行程。

## 能帮你做什么

- **先问清需求，再设计路线**：优先提取已有信息，只补问会改变方案的缺口。
- **先定大框架**：锁定必去点和返程时间，再考虑沿途景点与绕行成本。
- **说清每个点为什么去**：看什么、停多久、是否值得专程绕路、时间不够先删哪里。
- **支持三类交通方式**：自驾核对每日里程、驾驶上限与跨天衔接；公共交通核对班次、末班和往返服务；混合交通衔接取还车与车站/机场。
- **按需研究酒店和餐饮**：核对指定日期价格、卫生评价和位置；如果你打算饿了就吃、困了找店住，可以跳过这些清单。
- **利用近期攻略与官方信息**：小红书用于了解体验和季节差异，交通与开放信息尽量再核对官方来源。
- **保留弹性**：下雨、人多、订不上或徒步提前退出时，有明确备选或删减办法。
- **按用途交付**：手机翻页看图片、打印用 PDF、继续编辑用 HTML、协作用飞书、驾车导航用高德路书，也可以组合。
- **写完重新读取检查**：核对飞书正文、高德逐日节点、公里数、驾驶时间和线路衔接，不能仅凭点击保存宣布完成。

## 使用前需要准备什么

| 条件 | 用途 | 说明 |
|-|-|-|
| Claude Code 或 Codex | 执行 Skill | 安装到对应工具的技能目录 |
| AI 可以控制的浏览器 | 登录站点研究、编辑高德 | 例如 Claude in Chrome 或环境中可用的 Codex 浏览器工具；仅安装 Chrome 不等于 AI 能控制它 |
| 网页搜索/读取工具 | 查询官方公告、备用研究 | 使用当前环境提供的工具 |
| Chrome 或 Edge | 生成图片/PDF | 只输出 HTML、飞书或高德时无需运行图片渲染 |
| PowerShell 5.1+ / Bash | 运行渲染脚本 | Windows 用 PowerShell，macOS/Linux 用 Bash；渲染脚本不需要 Python |
| 中文字体 | 正确显示中文 | Windows 用微软雅黑/楷体，macOS 用苹方；Linux 可安装 Noto Sans CJK SC |
| 飞书文档工具或 lark-cli | 飞书攻略 | 仅选择飞书交付时需要；必须有相应授权和目标文档权限 |
| 高德路书编辑权限 | 保存驾车路书 | 提供目标路书链接，使用已登录浏览器或已授权工具；能查路线不代表能编辑路书 |

### 登录和验证码：需要你手动参与

- **高德路书**：走浏览器操作时，请在 AI 实际控制的电脑浏览器中登录高德，并提供可以编辑的路书链接。只有手机登录不能代替电脑登录；使用已授权接口/工具时则按该工具的权限要求。
- **小红书**：网页搜索笔记通常需要登录，请在同一个受控浏览器中完成登录。
- **携程/飞猪**：实时和账号专属价格可能要求登录；即使另一个窗口已经登录，AI 当前使用的浏览器配置也可能没有登录态。
- **飞书**：使用 CLI/连接器需要单独的账号授权与文档权限，网页已登录不代表 CLI 已授权。
- **扫码、短信验证码、滑块和安全验证**：AI 会暂停受影响的操作并告诉你是哪个平台，由你手动完成；之后重新检查页面状态再继续。AI 不代填密码、不绕过验证、不替你订票或付款。

缺少登录或工具时，可以继续整理本地攻略、查询公开信息，但会明确标记未验证的价格/班次，以及尚未完成的飞书或高德交付。

## 安装

```bash
# Claude Code：安装为个人 Skill
git clone https://github.com/alllie666/travel-itinerary-planner ~/.claude/skills/travel-itinerary-planner
```

Windows 的 Claude Code 可克隆到 `%USERPROFILE%\.claude\skills\travel-itinerary-planner`。

Codex 可克隆到其技能目录（默认 `~/.codex/skills/travel-itinerary-planner`）。目录已存在时先检查本地修改，再更新，避免覆盖自己的版本。

```bash
# Codex：安装为个人 Skill
git clone https://github.com/alllie666/travel-itinerary-planner ~/.codex/skills/travel-itinerary-planner
```

## 怎么使用

可以直接用中文描述需求，例如：

- `帮我做一个景迈山三天两夜的攻略，从西双版纳出发，两个人，不自驾，住宿300以内，想看一次日出`
- `这是我写好的版纳行程（截图），帮我补全，交通写清楚，做成长图`
- `公共交通玩四天，不赶路，住宿每晚400以内，输出PDF`
- `帮我规划云南自驾，住宿吃饭自己安排，每天最多开6小时，先分析绕路，输出HTML，确认后再更新我给的高德路书`
- `高铁到目的地后租电车三天，帮我衔接取还车，输出飞书攻略和分页图片`

最好同时提供日期、出发地、返程硬截止、必去/不去/已去过的点、交通方式、节奏和交付格式。已有截图、攻略或路书链接也可以提供。

Skill 会整理约束，研究路线，按所选格式交付，并保持各产物的行程版本一致。已明确授权编辑的文档和路书会继续处理；会改变路线的未决选择再由你决定。

## 文件结构

```
SKILL.md                          AI 执行入口和工作流程
references/research-playbook.md    小红书、携程、飞猪、高德等研究方法
references/quality-checklist.md    交付前检查项
references/self-drive-planning.md  自驾、电车、徒步与高德路书操作
references/delivery-formats.md     交付格式与飞书文档流程
examples/README.md                川西自驾、云南公共交通脱敏案例
assets/itinerary-template.html     排版模板，生成时替换示例内容
scripts/render-pages.ps1           Windows 分页图片
scripts/render.ps1                 Windows 长图和 PDF
scripts/render.sh                  macOS/Linux PNG、PDF，可选单独格式
scripts/render-pages.sh            macOS/Linux 分页图片
```

## 使用限制与验证范围

- 网页会改版，参考中的选择器和链接技巧可能失效，应回到实际页面操作。
- 部分小程序票务无法直接核实，攻略会标记需要出发前人工确认。
- 价格、班次、路况随时间变化，研究结果应注明来源和查询时间。
- 本次合并已在 macOS Chrome 实测分页图片和 PDF；Windows 原脚本此前在 Windows 10 + Edge 测试，本次未重测 Windows/Linux。
- Windows 原组合渲染脚本仍同时生成 PNG 和 PDF；macOS/Linux 脚本支持单独选择。
- 高德和飞书部分是 AI 按当前工具执行的操作流程，不是自带登录或私有 API 的独立程序。本次未使用真实旅行路书进行完整平台试跑。

## 作者与贡献者

- [@alllie666](https://github.com/alllie666)
- [@BetteDavisEyes](https://github.com/BetteDavisEyes)

## 开源许可

MIT，见 [LICENSE](LICENSE)。
