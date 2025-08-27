import SwiftUI

// 学习内容数据模型
struct LearningContent: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let category: LearningCategory
    let level: LearningLevel
    let tags: [String]
}

// 学习分类
enum LearningCategory: String, CaseIterable {
    case basics = "六爻基础"
    case hexagrams = "卦象解释"
    case practice = "实战应用"
    case culture = "文化背景"
    
    var icon: String {
        switch self {
        case .basics: return "book.fill"
        case .hexagrams: return "hexagon.fill"
        case .practice: return "target"
        case .culture: return "building.columns.fill"
        }
    }
}

// 学习难度
enum LearningLevel: String, CaseIterable {
    case beginner = "入门"
    case intermediate = "进阶"
    case advanced = "高级"
    
    var color: Color {
        switch self {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

// 主学习视图
struct LearningView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: LearningCategory? = nil
    @State private var selectedContent: LearningContent? = nil
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 搜索栏
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top)
                
                if selectedCategory == nil {
                    // 分类选择视图
                    CategorySelectionView(selectedCategory: $selectedCategory)
                } else {
                    // 内容列表视图
                    ContentListView(
                        category: selectedCategory!,
                        searchText: searchText,
                        selectedContent: $selectedContent,
                        onBack: { selectedCategory = nil }
                    )
                }
            }
            .navigationTitle("学习中心")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(item: $selectedContent) { content in
            LearningDetailView(content: content)
        }
    }
}

// 搜索栏
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("搜索学习内容...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

// 分类选择视图
struct CategorySelectionView: View {
    @Binding var selectedCategory: LearningCategory?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(LearningCategory.allCases, id: \.self) { category in
                    CategoryButton(category: category) {
                        selectedCategory = category
                    }
                }
            }
            .padding()
        }
    }
}

// 分类按钮
struct CategoryButton: View {
    let category: LearningCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                
                Text(category.rawValue)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(getContentCount(for: category))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getContentCount(for category: LearningCategory) -> String {
        let count = LearningData.contents.filter { $0.category == category }.count
        return "\(count) 篇内容"
    }
}

// 内容列表视图
struct ContentListView: View {
    let category: LearningCategory
    let searchText: String
    @Binding var selectedContent: LearningContent?
    let onBack: () -> Void
    
    var filteredContents: [LearningContent] {
        let categoryContents = LearningData.contents.filter { $0.category == category }
        if searchText.isEmpty {
            return categoryContents
        } else {
            return categoryContents.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 返回按钮和标题
            HStack {
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("返回")
                    }
                    .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text(category.rawValue)
                    .font(.headline)
                
                Spacer()
            }
            .padding()
            
            // 内容列表
            List(filteredContents) { content in
                LearningContentCard(content: content) {
                    selectedContent = content
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
        }
    }
}

// 学习内容卡片
struct LearningContentCard: View {
    let content: LearningContent
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(content.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(content.level.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(content.level.color.opacity(0.2))
                        .foregroundColor(content.level.color)
                        .cornerRadius(8)
                }
                
                Text(content.content)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                // 标签
                if !content.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(content.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

// 学习详情视图
struct LearningDetailView: View {
    let content: LearningContent
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 标题和难度
                    VStack(alignment: .leading, spacing: 8) {
                        Text(content.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text(content.category.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(content.level.rawValue)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(content.level.color.opacity(0.2))
                                .foregroundColor(content.level.color)
                                .cornerRadius(12)
                        }
                    }
                    
                    Divider()
                    
                    // 内容
                    Text(content.content)
                        .font(.body)
                        .lineSpacing(4)
                    
                    // 标签
                    if !content.tags.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("相关标签")
                                .font(.headline)
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                                ForEach(content.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.1))
                                        .foregroundColor(.blue)
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// 学习数据
struct LearningData {
    static let contents: [LearningContent] = [
        // 六爻基础知识
        LearningContent(
            title: "什么是六爻",
            content: "六爻是中国古代占卜方法之一，通过投掷三枚铜钱六次，根据正反面组合形成卦象，进而解读吉凶祸福。六爻起源于《易经》，是易学文化的重要组成部分。\n\n六爻占卜的基本原理是通过随机性体现天地人三才的变化规律，每一爻代表不同的时空状态和能量流动。通过分析卦象的组合、变化和相互关系，可以洞察事物的发展趋势。",
            category: .basics,
            level: .beginner,
            tags: ["入门", "基础概念", "历史"]
        ),
        LearningContent(
            title: "铜钱投掷方法",
            content: "传统六爻占卜使用三枚古铜钱，以乾隆通宝为佳。投掷时需要心诚意正，专注于所问之事。\n\n投掷规则：\n• 三枚铜钱同时投掷\n• 有字的一面为阴（背），无字的一面为阳（面）\n• 三个阳面 = 老阳（⚊）\n• 三个阴面 = 老阴（⚋）\n• 两阳一阴 = 少阴（⚋）\n• 两阴一阳 = 少阳（⚊）\n\n连续投掷六次，从下往上排列，形成完整卦象。",
            category: .basics,
            level: .beginner,
            tags: ["操作方法", "铜钱", "投掷"]
        ),
        LearningContent(
            title: "八卦基础",
            content: "八卦是六爻的基础，由三个爻组成，分别代表天地人三才。\n\n八卦及其象征：\n• 乾（☰）：天、父、金、西北\n• 坤（☷）：地、母、土、西南\n• 震（☳）：雷、长男、木、东\n• 巽（☴）：风、长女、木、东南\n• 坎（☵）：水、中男、水、北\n• 离（☲）：火、中女、火、南\n• 艮（☶）：山、少男、土、东北\n• 兑（☱）：泽、少女、金、西\n\n理解八卦的属性和相互关系是学习六爻的基础。",
            category: .basics,
            level: .intermediate,
            tags: ["八卦", "五行", "方位"]
        ),
        
        // 卦象解释
        LearningContent(
            title: "乾卦详解",
            content: "乾卦（☰☰）为纯阳之卦，象征天、龙、君王、父亲等。\n\n卦象特征：\n• 上下皆为乾卦，纯阳至刚\n• 代表创造力、领导力、权威\n• 五行属金，方位在西北\n• 时间对应农历九、十月\n\n占卜含义：\n• 事业：大吉，适合开创新事业\n• 财运：财源广进，但需防骄傲\n• 感情：男性主导，关系稳定\n• 健康：精力充沛，注意血压\n\n爻辞解读：初九至上九，从潜龙勿用到亢龙有悔，体现了事物发展的完整周期。",
            category: .hexagrams,
            level: .intermediate,
            tags: ["乾卦", "纯阳", "创造"]
        ),
        LearningContent(
            title: "坤卦详解",
            content: "坤卦（☷☷）为纯阴之卦，象征地、马、臣民、母亲等。\n\n卦象特征：\n• 上下皆为坤卦，纯阴至柔\n• 代表包容力、承载力、顺从\n• 五行属土，方位在西南\n• 时间对应农历六、七月\n\n占卜含义：\n• 事业：宜守不宜攻，稳扎稳打\n• 财运：积少成多，理财保守\n• 感情：女性主导，温柔体贴\n• 健康：脾胃消化，妇科问题\n\n坤卦强调顺应自然，以柔克刚，是阴性能量的完美体现。",
            category: .hexagrams,
            level: .intermediate,
            tags: ["坤卦", "纯阴", "包容"]
        ),
        
        // 实战应用
        LearningContent(
            title: "问事业运势",
            content: "事业运势是六爻占卜中最常见的问题之一。在问卦时需要明确具体的时间范围和关注重点。\n\n分析要点：\n• 世爻：代表求测者自身状态\n• 官鬼爻：代表工作、职位、上司\n• 妻财爻：代表收入、业绩、客户\n• 父母爻：代表文书、合同、学历\n• 兄弟爻：代表同事、竞争对手\n\n吉凶判断：\n• 世爻旺相，自身能力强\n• 官鬼持世，有升职机会\n• 妻财旺相，收入增加\n• 用神发动，事业有变化\n\n实例分析技巧和常见卦象组合。",
            category: .practice,
            level: .advanced,
            tags: ["事业", "实战", "分析"]
        ),
        
        // 文化背景
        LearningContent(
            title: "易经与六爻",
            content: "《易经》是中华文化的源头活水，六爻占卜正是易学实践的重要方法。\n\n历史渊源：\n• 伏羲画卦，创立八卦体系\n• 文王演易，发展为六十四卦\n• 孔子作传，完善易学理论\n• 历代易学家不断发展完善\n\n哲学内涵：\n• 阴阳对立统一\n• 五行相生相克\n• 天人合一思想\n• 变化发展规律\n\n六爻占卜不仅是预测工具，更是认识世界、理解人生的智慧载体。",
            category: .culture,
            level: .intermediate,
            tags: ["易经", "哲学", "文化"]
        )
    ]
}

#Preview {
    LearningView()
}
