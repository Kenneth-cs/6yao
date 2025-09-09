## 📋 项目概览
项目名称 : 六爻算卦iOS应用 开发语言 : Swift + SwiftUI 架构模式 : MVVM + Core Data AI服务 : 豆包大模型API 总文件数 : 12个Swift文件 + 配置文件

## 📁 项目文件结构
liuyao/
├── liuyaoApp.swift              # 应用入口
├── ContentView.swift            # 主界面视图 (1508行)
├── AIService.swift              # AI服务类 (299行)
├── AIModels.swift               # AI数据模型 (151行)
├── DataModels.swift             # Core Data模型 (133行)
├── HistoryView.swift            # 历史记录视图 (377行)
├── LearningView.swift           # 学习模块视图 (504行)
├── LocationManager.swift        # 定位管理器 (93行)
├── NetworkService.swift         # 网络服务 (97行)
├── SharedComponents.swift       # 共享组件 (81行)
├── Assets.xcassets/             # 资源文件
├── DivinationModel.xcdatamodeld/# Core Data模型
└── Preview Content/             # 预览内容
## 🏗️ 核心架构组件
### 1. 应用入口层 `liuyaoApp.swift`
- 类型 : 应用入口结构体
- 功能 : SwiftUI应用程序的主入口点
- 关键组件 :
  - @main 标记的应用结构体
  - 配置主窗口场景
### 2. 视图层 (View Layer) `ContentView.swift` (主视图 - 1508行)
- 类型 : SwiftUI视图
- 功能 : 应用主界面，包含问卦流程
- 关键组件 :
  - 主界面布局和导航
  - 铜钱抛掷动画
  - 卦象生成和显示
  - AI解读结果展示
  - 时间和定位显示 `HistoryView.swift` (历史记录 - 377行)
- 类型 : SwiftUI视图
- 功能 : 问卦历史记录管理
- 关键组件 :
  - HistoryView : 历史记录列表视图
  - HistoryRecordCard : 记录卡片组件
  - HistoryDetailView : 详情页面视图 `LearningView.swift` (学习模块 - 504行)
- 类型 : SwiftUI视图
- 功能 : 六爻知识学习模块
- 关键组件 :
  - LearningView : 学习主界面
  - LearningDetailView : 学习内容详情
  - LearningContent : 学习内容数据模型
  - LearningCategory : 学习分类枚举
  - LearningLevel : 学习难度枚举 `SharedComponents.swift` (共享组件 - 81行)
- 类型 : SwiftUI组件库
- 功能 : 可复用的UI组件
- 关键组件 :
  - FormattedTextView : 格式化文本视图
  - FormattedTextSegment : 文本段落结构体
  - `formatAIText` : 全局文本格式化函数
### 3. 服务层 (Service Layer) `AIService.swift` (AI服务 - 299行)
- 类型 : 服务类 (单例模式)
- 功能 : AI大模型集成和卦象解读
- 关键方法 :
  - `interpretDivination` : 标准解读方法
  - `interpretDivinationStream` : 流式解读方法
  - `buildPrompt` : 私有提示词构建方法
  - `parseAIResponse` : 私有响应解析方法
- 全局函数 :
  - `getChineseHour` : 获取中文时辰 `NetworkService.swift` (网络服务 - 97行)
- 类型 : 服务类 (单例模式)
- 功能 : HTTP网络请求封装
- 关键方法 :
  - `sendRequest` : 泛型网络请求方法
- 错误处理 :
  - NetworkError : 网络错误枚举 `LocationManager.swift` (定位管理 - 93行)
- 类型 : ObservableObject类
- 功能 : 地理定位和地址解析
- 关键方法 :
  - `requestLocation` : 请求定位权限
  - `geocodeLocation` : 私有地址解析方法
- 协议实现 :
  - CLLocationManagerDelegate : 定位代理协议
### 4. 数据层 (Data Layer) `DataModels.swift` (数据模型 - 133行)
- 类型 : Core Data管理类
- 功能 : 数据持久化和管理
- 关键组件 :
  - `PersistenceController` : Core Data堆栈管理
  - DivinationRecord 扩展: 实体便利属性
  - `DataService` : 数据服务类 `AIModels.swift` (AI数据模型 - 151行)
- 类型 : 数据结构定义
- 功能 : AI服务相关数据模型
- 关键结构体 :
  - AIResponse : AI响应模型
  - Choice : 选择项模型
  - Message : 消息模型
  - Usage : 使用统计模型
  - DivinationResult : 占卜结果模型
  - ParsedAIResponse : 解析后的AI响应
- 静态数据 :
  - `HexagramData` : 卦象数据管理类
## 🔧 函数分布统计
### 全局函数 (Global Functions)
1. 1.
   `formatAIText` - AI文本格式化
2. 2.
   `getChineseHour` - 获取中文时辰
### 类方法分布 AIService类 (6个方法)
- 公有方法: 2个 (interpretDivination, interpretDivinationStream)
- 私有方法: 4个 (buildPrompt, parseAIResponse等) NetworkService类 (1个方法)
- 公有方法: 1个 (sendRequest) LocationManager类 (5个方法)
- 公有方法: 1个 (requestLocation)
- 私有方法: 1个 (geocodeLocation)
- 协议方法: 3个 (CLLocationManagerDelegate) DataService类 (4个方法)
- 公有方法: 4个 (saveDivinationRecord, fetchAllRecords, deleteRecord, deleteAllRecords) PersistenceController类 (1个方法)
- 初始化方法: 1个 (init)
## 📊 数据模型架构
### Core Data实体
- DivinationRecord : 问卦记录实体
  - 属性: id, question, tossResultsData, aiInterpretation, advice, createdAt
  - 便利属性: tossResults, formattedDate, hexagramDisplay
### 枚举类型
- LearningCategory : 学习分类 (4种)
- LearningLevel : 学习难度 (3种)
- NetworkError : 网络错误类型 (6种)
### 结构体模型
- AI相关 : AIResponse, Choice, Message, Usage, DivinationResult, ParsedAIResponse
- UI相关 : LearningContent, FormattedTextSegment
## 🎯 架构特点分析
### 优势
1. 1.
   清晰的分层架构 : 视图层、服务层、数据层职责分明
2. 2.
   单例模式应用 : AIService、NetworkService使用单例，确保资源统一管理
3. 3.
   SwiftUI现代化 : 全面采用SwiftUI和Combine框架
4. 4.
   Core Data集成 : 完整的数据持久化方案
5. 5.
   错误处理完善 : 网络、定位、数据操作都有相应错误处理
### 待优化点
1. 1.
   ContentView过大 : 1508行代码，建议拆分为多个子视图
2. 2.
   全局函数较少 : 大部分功能封装在类中，可考虑提取更多通用函数
3. 3.
   依赖注入 : 可考虑使用依赖注入容器管理服务依赖
## 📈 后续开发建议
### 代码重构
1. 1.
   拆分ContentView : 将主视图拆分为多个功能模块
2. 2.
   提取通用组件 : 将重复的UI组件提取到SharedComponents
3. 3.
   优化数据流 : 考虑使用@StateObject和@ObservedObject优化数据传递
### 功能扩展
1. 1.
   完善AI功能 : 当前AI解读功能基本完成，可优化提示词
2. 2.
   增强学习模块 : 添加更多交互式学习内容
3. 3.
   用户系统 : 添加用户账户和云同步功能
### 性能优化
1. 1.
   懒加载 : 对大型视图实现懒加载
2. 2.
   缓存机制 : 添加网络请求和图片缓存
3. 3.
   内存管理 : 优化大数据量场景下的内存使用
文档生成时间 : 2025年1月 项目版本 : v1.0 分析范围 : 全部Swift源文件 (12个文件，共3,355行代码)**