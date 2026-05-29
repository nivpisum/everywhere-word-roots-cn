# Everywhere Word Roots CN

[English](README.md)

面向中文读者的英文论文一键词源/词根查询工作流。适合阅读生物学、医学、化学英文论文时，快速查询一个英文词或短语的词根、词源、中文义和学科常用法。

在 Chrome、PDF 阅读器、Zotero 或任何可选中文本的软件里选中单词，按 `Alt+X`，AutoHotkey 会把这个词发送到 Everywhere 的专用助手，让 AI 返回简洁的中文解释。

## 它做什么

- 复制你当前选中的英文词或短语。
- 打开 Everywhere 聊天窗口。
- 从窗口右下角定位输入框并点击。
- 粘贴词语并点击发送按钮。
- 使用 DeepSeek V4 Pro，且关闭思考模式。
- 关闭自动屏幕/文档附件，避免 AI 分析当前论文上下文，只解释这个词本身。

## 需要准备

- Windows
- [AutoHotkey v2](https://www.autohotkey.com/)
- [Everywhere](https://github.com/DearVa/Everywhere)
- 已在 Everywhere 中配置好的 DeepSeek API key

## 快速开始

1. 安装 AutoHotkey v2。
2. 在 Everywhere 中配置一个名为 `论文词根` 的助手，或运行：

   ```powershell
   node setup_everywhere_scholar.mjs
   ```

3. 双击运行 `bio_scholar_lookup.ahk`。
4. 阅读论文时选中一个词，按 `Alt+X`。

## Everywhere 推荐设置

助手建议使用这些设置：

```text
URL: https://api.deepseek.com
API 协议: OpenAI (Chat Completions)
模型 ID: deepseek-v4-pro
thinking.type: disabled
reasoning_effort: 留空 / 不发送
thinking_budget: 留空 / 不发送
支持使用工具: 关
输入模态: Text
输出模态: Text
自动添加附件: 关
自动添加选中文本: 关
```

如果 Everywhere 报错 `reasoning_effort: unknown variant auto`，不要把 `reasoning_effort` 设成 `auto`，而是清空这个值，让请求里不发送它。

## 输出风格

助手会尽量模仿 Google AI 概览式结构，用中文返回：

```markdown
**indicate**（指示；表明）源自拉丁语，核心意思是“指出、显示”。

* **in-**，前缀，在此处表示“朝向、进入”。
* **dic-**，词根，源自拉丁语 dicāre，意为“宣告、奉献”。
* **-ate**，后缀，常见英语动词后缀，用于构成动词。

**词源/历史**
...

**生物学常用法**
...
```

## 微调点击位置

Everywhere 0.7 之后浮窗可以调整大小。脚本默认从 Everywhere 窗口右下角定位输入框和发送按钮：

```ahk
INPUT_RIGHT_OFFSET := 190
INPUT_BOTTOM_OFFSET := 52
SEND_RIGHT_OFFSET := 38
SEND_BOTTOM_OFFSET := 52
```

如果你的窗口尺寸、缩放比例或任务栏位置不同，导致没有点中输入框或发送按钮，只需要微调这四个值。

## 隐私与安全

本仓库不包含任何 API key。不要提交 Everywhere 的 `settings.json`、API key、token 或日志文件。

`setup_everywhere_scholar.mjs` 会修改 `%APPDATA%\Everywhere\settings.json`，并在写入前创建带时间戳的备份。

## 许可证

MIT

