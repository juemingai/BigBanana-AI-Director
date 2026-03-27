---
name: prop-image-prompt-generator
description: 为用户生成可直接用于图片生成的道具提示词。适用于根据道具名称、分类、描述、题材、语言、视觉风格和可选的全局美术指导，输出单段、可渲染、适合图像模型使用的道具 visual prompt。
---

# 道具图片提示词生成 Skill

这个 skill 的目标是直接为用户生成“道具提示词”，用于图片生成。

输出结果应当是：

- 一段可直接用于图像生成模型的 `visualPrompt`
- 聚焦单个道具本身
- 不输出解释、分析过程或多余说明

## 适用场景

- 用户要为单个道具生成出图提示词
- 用户已经有道具名称和描述，希望整理成更强的图片生成 prompt
- 用户要在“道具库”中填写或重写道具提示词

## 必要输入

- `name`: 道具名称
- `category`: 道具分类
- `description`: 道具描述
- `genre`: 题材或故事语境
- `visualStyle`: 视觉风格
- `language`: 输出语言

## 可选输入

- `artDirection`
  - `consistencyAnchors`
  - `colorPalette.primary`
  - `colorPalette.secondary`
  - `colorPalette.accent`
  - `colorPalette.temperature`
  - `colorPalette.saturation`
  - `lightingStyle`
  - `textureStyle`
  - `moodKeywords`
- `stylePrompt`

## 输出要求

- 只输出一段 prompt 文本
- 单段落
- 逗号分隔
- 55-95 词左右
- 必须强调 `visualStyle`
- 必须适合图片生成，不要写成剧情说明
- 只描述道具，不允许出现人物、角色、手部、持握动作
- 内容应覆盖：
  - 外形与轮廓
  - 材质与纹理
  - 色彩与表面质感
  - 工艺与细节
  - 陈列/拍摄方式
  - 技术质量与风格锚点

## 生成步骤

1. 读取用户提供的道具数据。
2. 如果存在 `artDirection`，把全局风格一致性要求融入 prompt。
3. 将道具信息整理为可渲染的视觉描述，避免抽象空话。
4. 输出单段 `visualPrompt`，可直接放入图片生成流程。

## 生成原则

- 道具必须是“单体主角”，不是场景一部分的顺带描述
- 细节必须具体，可被图像模型画出来
- 优先写可见特征，不要写隐含设定
- 如果是武器、器物、科技设备等，要突出辨识度最高的结构特征
- 如果用户描述过于短，补全合理的视觉细节，但不要偏离原始设定
- 如果提供了全局美术指导，优先服从项目统一风格

## 内部参考模板

当前项目的原始模板可参考：

- [道具提示词模板](/Users/jueming/github_project/BigBanana-AI-Director/项目拆解/道具提示词生成-skill/references/道具提示词模板.md)

使用时不要向用户暴露“模板说明”，而是直接输出最终的道具提示词。

## 返回格式

默认直接返回纯文本 prompt。

如果调用方明确要求结构化结果，可返回：

```json
{
  "visualPrompt": "..."
}
```

