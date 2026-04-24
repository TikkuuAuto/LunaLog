# LunaLog

LunaLog 是一个像素风、月面基地主题的私人情绪记录 App。

## 项目定位

- 形态：Flutter 移动端 MVP
- 主题：月面基地、轻科幻、像素风、安静陪伴
- 核心体验：记录当天情绪与状态，生成一段月面基地反馈和一条简短信号文本

## MVP 范围

当前 MVP 以“先跑起来”为目标，聚焦 PRD 中的核心闭环：

- Home：首页月面场景卡片、今日信号、状态摘要
- Log：每日记录表单
- Archive：时间线与月视图
- Settings：中英文切换、深浅主题切换

## 设计输入

- PRD：`D:\LunaLog\luna_log_prd_draft.xlsx`
- 视觉参考：`D:\LunaLog\vision reference`
- 素材目录：`D:\LunaLog\assets`

## 当前状态

- PRD 已阅读并完成 MVP 功能拆解
- Flutter 方案已确定
- 本地运行环境仍在搭建中
- Android Studio / Android SDK / JDK 目前尚未完成可运行配置

## 技术方案

- Flutter
- Android Emulator（目标设备：Pixel 10）
- 本地优先的轻量数据存储
- 双语文案与深浅主题支持

## 近期目标

1. 补齐 JDK 与 Android command-line tools
2. 建立 Flutter 工程骨架
3. 实现 Home / Log / Archive / Settings 四个核心页面
4. 跑通 Android 模拟器中的首个可用版本

## 说明

这个仓库当前处于 MVP 启动阶段，优先级只有一个：先把项目跑起来，再逐步补视觉细节和交互精修。
