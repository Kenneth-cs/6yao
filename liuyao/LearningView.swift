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
// 在 LearningData.contents 数组中添加更多内容
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
        ), // 添加这个逗号
        
        // 六爻基础知识 - 补充内容
        LearningContent(
            title: "五行学说",
            content: "五行是六爻占卜的核理论基础，包括金、木、水、火、土五种基本元素。\n\n五行属性：\n• 金：收敛、肃杀、坚硬、清洁\n• 木：生长、条达、仁慈、温和\n• 水：润下、寒冷、智慧、流动\n• 火：炎上、温热、礼貌、光明\n• 土：稼穑、厚重、信用、包容\n\n五行关系：\n• 相生：木生火、火生土、土生金、金生水、水生木\n• 相克：木克土、土克水、水克火、火克金、金克木\n\n在六爻中，每个卦都有对应的五行属性，通过五行生克关系判断吉凶。",
            category: .basics,
            level: .intermediate,
            tags: ["五行", "生克", "理论基础"]
        ),
        LearningContent(
            title: "六神配置",
            content: "六神是六爻占卜中的重要概念，用来进一步细化爻的含义。\n\n六神包括：\n• 青龙：吉神，主喜庆、文书、酒色\n• 朱雀：凶神，主口舌、文书、信息\n• 勾陈：凶神，主田土、牢狱、迟缓\n• 螣蛇：凶神，主虚假、怪异、惊恐\n• 白虎：凶神，主疾病、孝服、刀兵\n• 玄武：凶神，主盗贼、暗昧、奸私\n\n六神配置规律：\n以起卦日的天干为准，按固定顺序配置到六个爻位上。不同的六神组合会影响卦象的具体含义。",
            category: .basics,
            level: .advanced,
            tags: ["六神", "配置", "天干"]
        ),
        LearningContent(
            title: "世应关系",
            content: "世爻和应爻是六爻占卜中最重要的两个爻位，代表主客双方的关系。\n\n世应确定：\n• 世爻：代表求测者自己\n• 应爻：代表对方或所测之事\n• 世应相隔三位，形成对应关系\n\n世应分析：\n• 世应相生：关系和谐，事情顺利\n• 世应相克：关系紧张，阻力较大\n• 世旺应弱：自己占优势\n• 世弱应旺：对方占优势\n• 世应俱旺：双方实力相当\n\n通过世应关系可以判断事情的主动权在谁手中。",
            category: .basics,
            level: .intermediate,
            tags: ["世爻", "应爻", "关系分析"]
        ),
        
        // 卦象解释 - 补充更多卦象
        LearningContent(
            title: "震卦详解",
            content: "震卦（☳☳）为震雷之卦，象征雷、长男、东方等。\n\n卦象特征：\n• 一阳在下，二阴在上\n• 代表动、震动、奋起\n• 五行属木，方位在东\n• 时间对应农历二、三月\n\n占卜含义：\n• 事业：有突破，但需谨慎行事\n• 财运：来得快去得也快\n• 感情：激情四射，但需稳定\n• 健康：肝胆问题，神经系统\n\n震卦主动，适合开始新的行动，但要注意震而不乱。",
            category: .hexagrams,
            level: .intermediate,
            tags: ["震卦", "雷", "行动"]
        ),
        LearningContent(
            title: "巽卦详解",
            content: "巽卦（☴☴）为巽风之卦，象征风、长女、东南等。\n\n卦象特征：\n• 一阴在下，二阳在上\n• 代表入、渗透、顺从\n• 五行属木，方位在东南\n• 时间对应农历三、四月\n\n占卜含义：\n• 事业：需要耐心，循序渐进\n• 财运：细水长流，积少成多\n• 感情：温柔体贴，但易变\n• 健康：呼吸系统，神经衰弱\n\n巽卦主柔顺，强调以柔克刚，润物细无声的力量。",
            category: .hexagrams,
            level: .intermediate,
            tags: ["巽卦", "风", "渗透"]
        ),
        LearningContent(
            title: "坎卦详解",
            content: "坎卦（☵☵）为坎水之卦，象征水、中男、北方等。\n\n卦象特征：\n• 一阳在中，二阴在外\n• 代表险、陷、智慧\n• 五行属水，方位在北\n• 时间对应农历十一、十二月\n\n占卜含义：\n• 事业：有困难险阻，需智慧应对\n• 财运：财路不明，需谨慎理财\n• 感情：感情深沉，但有波折\n• 健康：肾脏泌尿，血液循环\n\n坎卦主险，但险中有智，能够化险为夷。",
            category: .hexagrams,
            level: .intermediate,
            tags: ["坎卦", "水", "智慧"]
        ),
        LearningContent(
            title: "离卦详解",
            content: "离卦（☲☲）为离火之卦，象征火、中女、南方等。\n\n卦象特征：\n• 一阴在中，二阳在外\n• 代表明、美丽、文明\n• 五行属火，方位在南\n• 时间对应农历五、六月\n\n占卜含义：\n• 事业：前景光明，但需防虚火\n• 财运：财运亨通，但要防损失\n• 感情：热情如火，但易分离\n• 健康：心脏血管，眼睛视力\n\n离卦主明，象征光明和智慧，但外实内虚需注意。",
            category: .hexagrams,
            level: .intermediate,
            tags: ["离卦", "火", "光明"]
        ),
        
        // 实战应用 - 补充更多应用场景
        LearningContent(
            title: "问感情婚姻",
            content: "感情婚姻是六爻占卜的热门话题，需要重点关注特定的爻位和神煞。\n\n分析要点：\n• 世爻：代表求测者自己\n• 应爻：代表对方\n• 妻财爻（男测）：代表女友、妻子\n• 官鬼爻（女测）：代表男友、丈夫\n• 子孙爻：代表快乐、子女\n\n吉凶判断：\n• 用神旺相：感情稳定\n• 世应相生：双方和谐\n• 用神发动：感情有变化\n• 空亡、墓绝：感情有阻碍\n\n特殊情况：\n• 用神两现：三角恋情\n• 用神化绝：感情结束\n• 桃花临身：异性缘佳",
            category: .practice,
            level: .advanced,
            tags: ["感情", "婚姻", "用神"]
        ),
        LearningContent(
            title: "问财运投资",
            content: "财运投资类问题需要重点分析妻财爻和相关的生克关系。\n\n分析要点：\n• 妻财爻：代表金钱、收入\n• 父母爻：代表投资、房产\n• 官鬼爻：代表压力、风险\n• 子孙爻：代表收益、利润\n• 兄弟爻：代表竞争、损耗\n\n投资判断：\n• 妻财旺相：财运亨通\n• 子孙生财：投资有收益\n• 兄弟克财：有损失风险\n• 官鬼克身：压力较大\n\n时机选择：\n• 财爻值日：适合交易\n• 财爻空亡：暂缓投资\n• 财爻入墓：资金被套",
            category: .practice,
            level: .advanced,
            tags: ["财运", "投资", "妻财"]
        ),
        LearningContent(
            title: "问健康疾病",
            content: "健康疾病类占卜需要结合五行、六神和爻位进行综合分析。\n\n分析要点：\n• 世爻：代表求测者身体状况\n• 官鬼爻：代表疾病、病邪\n• 子孙爻：代表医生、药物\n• 父母爻：代表医院、检查\n\n疾病判断：\n• 官鬼持世：身体有恙\n• 官鬼发动：病情变化\n• 子孙旺相：有良医良药\n• 世爻衰弱：体质较差\n\n五行对应：\n• 金：肺、大肠、皮肤\n• 木：肝、胆、筋骨\n• 水：肾、膀胱、生殖\n• 火：心、小肠、血管\n• 土：脾、胃、肌肉",
            category: .practice,
            level: .advanced,
            tags: ["健康", "疾病", "五行"]
        ),
        
        // 文化背景 - 补充更多文化内容
        LearningContent(
            title: "历代易学大师",
            content: "六爻学说在历史长河中经过众多易学大师的发展完善。\n\n重要人物：\n• 伏羲：创立八卦，开易学先河\n• 文王：演绎六十四卦，作卦辞\n• 周公：作爻辞，完善卦象体系\n• 孔子：作十翼，阐释易理\n• 京房：创立纳甲法，奠定六爻基础\n• 郭璞：发展六爻理论\n• 刘伯温：明代易学集大成者\n\n现代发展：\n• 邵伟华：现代六爻推广者\n• 李洪成：六爻实战派代表\n• 王虎应：六爻理论创新者\n\n每位大师都为六爻学说的发展做出了重要贡献。",
            category: .culture,
            level: .intermediate,
            tags: ["历史", "大师", "传承"]
        ),
        LearningContent(
            title: "六爻与现代科学",
            content: "六爻占卜虽然是古代智慧，但其中蕴含的思维方式与现代科学有相通之处。\n\n共同点：\n• 系统性思维：整体考虑各种因素\n• 概率统计：通过大量实践总结规律\n• 信息论：从有限信息推导结论\n• 心理学：考虑人的主观因素\n\n现代应用：\n• 决策分析：帮助理清思路\n• 心理咨询：提供心理暗示\n• 管理学：分析复杂关系\n• 哲学思辨：探讨变化规律\n\n理性态度：\n六爻应作为思维工具，而非绝对预测，结合理性分析才能发挥最大价值。",
            category: .culture,
            level: .advanced,
            tags: ["现代科学", "思维方式", "应用"]
        )
        
        // ... existing code ...
    ]
}

#Preview {
    LearningView()
}
