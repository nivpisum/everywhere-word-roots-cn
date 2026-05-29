import fs from "node:fs";
import path from "node:path";

const assistantNameBefore = "学者";
const assistantNameAfter = "论文词根";
const modelId = "deepseek-v4-pro";

const systemPrompt = `你是 Google AI 概览风格的英文词源查词助手。只解释用户输入的词/短语本身；忽略当前窗口、文档、截图、附件、来源芯片和系统提供的上下文，不要写“在这篇论文/文档中”。

输出中文，Markdown，像搜索结果 AI 概览：
第一段：**词**（中文常译）是什么；若不是单一词根，要直接说明。
接着用 2-5 个项目符号拆词根、前缀、后缀、化学后缀或命名来源。每条必须只讲一个部件，并以该部件开头，格式如：\`* **in-**，前缀，在此处表示“朝向、进入”。\` 不要把多个部件合并到同一条。
然后写“词源/历史”：1-2 句，讲来源故事；不确定就说“不宜硬拆/词源不确定”。
最后写“生物学常用法”：最多 1 句，说明在生物/医学/化学中常怎么用。

总长 180-320 字。不翻译整段，不分析具体文档语境，不列参考文献，不编词源。`;

const appData = process.env.APPDATA;
if (!appData) {
  throw new Error("APPDATA is not set; cannot locate Everywhere settings.json.");
}

const settingsPath = path.join(appData, "Everywhere", "settings.json");
const settings = JSON.parse(fs.readFileSync(settingsPath, "utf8"));
const assistants = settings.Model?.CustomAssistants;

if (!Array.isArray(assistants)) {
  throw new Error("Everywhere settings.json does not contain Model.CustomAssistants.");
}

const assistant =
  assistants.find((item) => item.Name === assistantNameAfter) ??
  assistants.find((item) => item.Name === assistantNameBefore) ??
  assistants[1] ??
  assistants[0];

if (!assistant) {
  throw new Error("Could not find an Everywhere assistant to configure.");
}

const assistantIndex = assistants.indexOf(assistant);
const stamp = new Date().toISOString().replace(/[:.]/g, "-");
const backupPath = `${settingsPath}.word-roots-backup-${stamp}`;
fs.copyFileSync(settingsPath, backupPath);

settings.ChatWindow ??= {};
settings.ChatWindow.AutomaticallyAddElement = false;
settings.ChatWindow.AutomaticallyAddTextSelection = false;
settings.ChatWindow.AlwaysStartNewChat = true;

assistant.Name = assistantNameAfter;
assistant.Description = "选词后一键解释词源、词根、词义和生物学常用法";
assistant.ConfiguratorType = "Advanced";
assistant.ModelProviderTemplateId = null;
assistant.Endpoint = "https://api.deepseek.com";
assistant.Schema = 0;
assistant.ModelDefinitionTemplateId = null;
assistant.SystemPrompt = systemPrompt;
assistant.ModelId = modelId;
assistant.ContextLimit = 64000;
assistant.SupportsReasoning = true;
assistant.ThinkingType = "disabled";
delete assistant.ReasoningEffort;
delete assistant.ThinkingBudget;
assistant.SupportsToolCall = false;
assistant.InputModalities = "Text";
assistant.OutputModalities = "Text";
assistant.Temperature = { DefaultValue: 1, CustomValue: 0.2, ResetCommand: {} };
assistant.TopP = { DefaultValue: 0.9, CustomValue: 0.7, ResetCommand: {} };
assistant.MaxTokens = { DefaultValue: 64000, CustomValue: 800, ResetCommand: {} };

const legacyApiKeyPath = `Model.CustomAssistants[${assistantIndex}].ApiKey`;
if (settings.LegacyApiKeys?.[legacyApiKeyPath] && !assistant.ApiKey) {
  assistant.ApiKey = settings.LegacyApiKeys[legacyApiKeyPath];
}

settings.Model.SelectedCustomAssistantId = assistant.Id;

fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2) + "\n", "utf8");

console.log(`Updated assistant: ${assistant.Name}`);
console.log(`Model ID: ${assistant.ModelId}`);
console.log("Disabled automatic context attachments");
console.log(`Backup: ${backupPath}`);

