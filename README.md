# Everywhere Word Roots CN

[中文说明](README.zh-CN.md)

One-key word-root lookup for Chinese readers of English biology, medicine, and chemistry papers.

Select a word in Chrome, a PDF reader, Zotero, or any selectable text surface, press `Alt+X`, and AutoHotkey sends the word to an Everywhere assistant configured for concise etymology, morphology, and domain usage.

## What It Does

- Copies the selected word or phrase.
- Opens the Everywhere chat window.
- Clicks the chat input from the lower-right corner of the window.
- Pastes the term and clicks Send.
- Uses a DeepSeek V4 Pro assistant with thinking disabled.
- Avoids automatic screen/document attachments, so the assistant explains the word itself instead of analyzing the current paper.

## Requirements

- Windows
- [AutoHotkey v2](https://www.autohotkey.com/)
- [Everywhere](https://github.com/DearVa/Everywhere)
- A DeepSeek API key configured in Everywhere

## Quick Start

1. Install AutoHotkey v2.
2. Configure an Everywhere assistant named `论文词根`, or run:

   ```powershell
   node setup_everywhere_scholar.mjs
   ```

3. Run `bio_scholar_lookup.ahk`.
4. Select a word and press `Alt+X`.

## Everywhere Settings

Recommended assistant settings:

```text
URL: https://api.deepseek.com
API protocol: OpenAI (Chat Completions)
Model ID: deepseek-v4-pro
thinking.type: disabled
reasoning_effort: empty / not sent
thinking_budget: empty / not sent
tool use: off
input modalities: Text
output modalities: Text
automatically add attachments: off
automatically add selected text: off
```

If Everywhere reports `reasoning_effort: unknown variant auto`, remove the `reasoning_effort` value instead of setting it to `auto`.

## Output Style

The assistant is tuned for a Google AI Overview-like structure in Chinese:

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

## Tune Click Positions

Everywhere 0.7+ chat windows are resizable. The AHK script clicks relative to the lower-right corner of the active Everywhere window:

```ahk
INPUT_RIGHT_OFFSET := 190
INPUT_BOTTOM_OFFSET := 52
SEND_RIGHT_OFFSET := 38
SEND_BOTTOM_OFFSET := 52
```

If your window size or display scaling differs, adjust these four values.

## Privacy And Safety

This repository does not contain API keys. Do not commit your Everywhere `settings.json`, API keys, tokens, or logs.

The setup script edits `%APPDATA%\Everywhere\settings.json` and creates a timestamped backup before writing changes.

## License

MIT
