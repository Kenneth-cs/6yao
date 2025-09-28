import SwiftUI
import Foundation

struct DailyInspirationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentHexagram: String = ""
    @State private var hexagramName: String = ""
    @State private var lifeAdvice: String = ""
    @State private var isShaking = false
    @State private var showResult = false
    @State private var currentTime = Date()
    @State private var inspirationType: InspirationType = .daily
    
    enum InspirationType: String, CaseIterable {
        case daily = "每日启示"
        case weekly = "每周启示"
    }
    
    // 时间格式化器
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景渐变
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.15),
                        Color.indigo.opacity(0.1),
                        Color.white
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        if !showResult {
                            // 摇卦区域
                            VStack(spacing: 20) {
                                Text(inspirationType == .daily ? "点击获取今日建议" : "获取本周人生启示")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                // 摇卦按钮
                                Button(action: {
                                    generateInspiration()
                                }) {
                                    VStack(spacing: 12) {
                                        ZStack {
                                            // 外圈光晕
                                            Circle()
                                                .fill(
                                                    RadialGradient(
                                                        gradient: Gradient(colors: [
                                                            Color.yellow.opacity(0.3),
                                                            Color.orange.opacity(0.1)
                                                        ]),
                                                        center: .center,
                                                        startRadius: 20,
                                                        endRadius: 50
                                                    )
                                                )
                                                .frame(width: 120, height: 120)
                                                .scaleEffect(isShaking ? 1.1 : 1.0)
                                                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isShaking)
                                            
                                            // 主按钮
                                            ZStack {
                                                Circle()
                                                    .fill(
                                                        LinearGradient(
                                                            gradient: Gradient(colors: [
                                                                Color.yellow.opacity(0.9),
                                                                Color.orange.opacity(0.8),
                                                                Color.yellow.opacity(0.7)
                                                            ]),
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                    .frame(width: 100, height: 100)
                                                    .shadow(color: .orange.opacity(0.4), radius: 8, x: 2, y: 4)
                                                
                                                Circle()
                                                    .stroke(Color.orange.opacity(0.8), lineWidth: 2)
                                                    .frame(width: 100, height: 100)
                                                
                                                // 中心图标
                                                Image(systemName: "sparkles")
                                                    .font(.title)
                                                    .foregroundColor(.orange.opacity(0.9))
                                                    .rotationEffect(.degrees(isShaking ? 360 : 0))
                                                    .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isShaking)
                                            }
                                        }
                                        
                                        Text("未卜先知，顺势而为")
                                            .font(.title2)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                        
                                        Text("点击获取启示")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 30)
                                    .padding(.horizontal, 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white)
                                            .shadow(color: .purple.opacity(0.2), radius: 15, x: 0, y: 8)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(isShaking)
                            }
                        } else {
                            // 结果展示区域
                            VStack(spacing: 24) {
                                // 卦象展示
                                VStack(spacing: 16) {
                                    Text(hexagramName)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundStyle(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.purple, .indigo]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                    
                                    // 卦象图案
                                    HexagramView(hexagram: currentHexagram)
                                        .frame(width: 80, height: 120)
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white)
                                        .shadow(color: .purple.opacity(0.1), radius: 8, x: 0, y: 4)
                                )
                                
                                // 人生建议
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "lightbulb.fill")
                                            .foregroundColor(.orange)
                                            .font(.title3)
                                        Text(inspirationType == .daily ? "今日人生启示" : "本周人生启示")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.orange)
                                        Spacer()
                                    }
                                    
                                    Text(lifeAdvice)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.orange.opacity(0.04),
                                                    Color.yellow.opacity(0.02)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            Color.orange.opacity(0.2),
                                                            Color.yellow.opacity(0.15)
                                                        ]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1
                                                )
                                        )
                                        .shadow(color: .orange.opacity(0.1), radius: 4, x: 0, y: 2)
                                )
                                
                                // 操作按钮
                                HStack(spacing: 16) {
                                    Button("重新获取") {
                                        resetInspiration()
                                    }
                                    .font(.body)
                                    .foregroundColor(.purple)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.purple, .indigo]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                                    
                                    Button("分享启示") {
                                        shareInspiration()
                                    }
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.purple, .indigo]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                    )
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("今日启示")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.purple)
                }
            }
        }
        .onAppear {
            currentTime = Date()
        }
    }
    
    // MARK: - 功能函数
    
    private func generateInspiration() {
        isShaking = true
        
        // 模拟摇卦动画
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isShaking = false
            
            // 生成随机卦象
            let randomHexagram = generateRandomHexagram()
            currentHexagram = randomHexagram
            
            // 获取卦象信息
            if let hexagramInfo = getHexagramInfo(for: randomHexagram) {
                hexagramName = hexagramInfo.name
                lifeAdvice = generateLifeAdvice(from: hexagramInfo, type: inspirationType)
            }
            
            withAnimation(.easeInOut(duration: 0.5)) {
                showResult = true
            }
        }
    }
    
    private func resetInspiration() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showResult = false
        }
        currentHexagram = ""
        hexagramName = ""
        lifeAdvice = ""
    }
    
    private func shareInspiration() {
        let shareText = "\(inspirationType.rawValue)：\(hexagramName)\n\n\(lifeAdvice)\n\n来自人生教练App"
        
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityViewController, animated: true)
        }
    }
    
    private func generateRandomHexagram() -> String {
        var hexagram = ""
        for _ in 0..<6 {
            hexagram += Bool.random() ? "1" : "0"
        }
        return hexagram
    }
}

// MARK: - 卦象数据和转换逻辑

struct HexagramInfo {
    let name: String
    let description: String
}

func getHexagramInfo(for hexagram: String) -> HexagramInfo? {
    let hexagramDict: [String: (String, String)] = [
        "111111": ("乾为天", "纯阳之卦，象征天、创造与刚健。意味着强大的力量和无限潜能，但需谨记物极必反，刚健不息的同时也要避免刚愎自用。"),
        "000000": ("坤为地", "纯阴之卦，象征地、包容与柔顺。德行宽广，厚德载物。强调柔顺辅佐，静守持重，以柔克刚。"),
        "100010": ("水雷屯", "云雷交加，万物初生，充满艰难。象征初生、艰难。宜建立诸侯，但不可轻动，应积蓄力量，坚毅行动。"),
        "010001": ("山水蒙", "山下出泉，水气朦胧，启蒙发智。象征蒙昧、启蒙。君子应以果敢的行为培育品德，教育重在诱导与身教。"),
        "111010": ("水天需", "云（水）升于天，待时降雨。象征等待、时机。前方有险，不可贸然前进，应耐心等待，坚守正道则终吉。"),
        "010111": ("天水讼", "天西转与水东流，背道而驰。象征争讼、纠纷。告诫人们慎始免争，一旦卷入争执，以中和为贵，适可而止。"),
        "010000": ("地水师", "地中有水，聚众成师。象征军队、战争、众。强调师出有名，纪律严明，并需有德高望重之人统领方能成功。"),
        "000010": ("水地比", "水在地上，亲密无间。象征亲附、比和。九五阳刚中正，为群阴所亲附，吉祥。但应亲附贤者，慎始善终。"),
        "111011": ("风天小畜", "风行天上，密云不雨。象征小的蓄积、暂时停顿。阳气被阴气稍稍蓄积，力量不足，降雨尚待时机，宜于修养等待。"),
        "110111": ("天泽履", "上天下泽，尊卑有别，循礼而行。象征实践、履行。如同踩虎尾般危险，唯有小心谨慎，循礼而行，方可化险为夷。"),
        "111000": ("地天泰", "地在上天在下，阴阳交合，万物通泰。象征通达、安泰、和谐。是盛世之象，但泰极否来，居安思危方能长久。"),
        "000111": ("天地否", "天在上地在下，阴阳不交，万物不通。象征闭塞、阻滞的时期，宜守静待时，不可妄动。"),
        "101111": ("天火同人", "天与火，光明向上，志同道合。象征团结、协作。利于汇聚众人之力，攻克难关，但需心胸宽广，无私心。"),
        "111101": ("火天大有", "火在天上，普照万物，大获所有。象征大有所获、富有。君子应遏恶扬善，顺应天道，保持谦逊方能保有财富。"),
        "001000": ("地山谦", "地中有山，山高地卑，却藏于地下。象征谦虚、卑下。君子取多补少，称物平施。谦逊之道，亨通终身。"),
        "000100": ("雷地豫", "雷出地奋，万物欣欣向荣。象征愉悦、安乐。利于建立诸侯、出兵行动，但需顺情而动，不可乐极生悲。"),
        "100110": ("泽雷随", "泽中有雷，雷伏泽中，随时休息。象征随从、跟随。天下随时，君子应依时作息。随从之道在於使人悦服，守正则吉。"),
        "011001": ("山风蛊", "山下有风，风被山阻，流通不畅而腐败。象征腐败、革新。拯弊治乱，拨乱反正，虽有艰险，终能亨通。"),
        "110000": ("地泽临", "地高于泽，泽容于地，居高临下。象征监督、领导。君子应教化、保育万民，并时刻反省自身。"),
        "000011": ("风地观", "风行地上，观览万物。象征观察、展示。君王观民设教，臣民观君德行。观天之神道，而四时不忒，重在诚敬。"),
        "100101": ("火雷噬嗑", "火雷相交，如口中咬合食物。象征咬合、排除障碍。利于处理狱事，消除障碍，需刚柔相济，果断坚决。"),
        "101001": ("山火贲", "山下有火，火光装饰山峦。象征装饰、美化。贲卦亨通，但只是小利，应注重本质，勿流于虚文浮饰。"),
        "000001": ("山地剥", "山附于地，风雨剥蚀。象征剥落、侵蚀。阴盛阳衰，小人得势，君子应顺应时势，隐忍待机，不可有所行动。"),
        "100000": ("地雷复", "雷在地中，一阳复生。象征回复、复兴。是黑暗过后的第一缕曙光，生机重现，凡事盼头，应顺势而动。"),
        "100111": ("天雷无妄", "天下雷行，万物不敢虚妄。象征真实、不虚伪。行事要顺乎自然，守正为本，出乎意料的好运或灾祸皆因妄动而生。"),
        "111001": ("山天大畜", "天藏于山中，所畜至大。象征大有积蓄、阻止。既指积蓄才德，也指阻止乾阳的躁进，厚积薄发，利涉大川。"),
        "100001": ("山雷颐", "山下有雷，春雷一动，万物颐养。象征颐养、自食其力。观察事物的颐养之道，当以正道自求口实。"),
        "011110": ("泽风大过", "泽灭木，水淹没了树木，太过常分。象征大的过度、非常行动。栋梁弯曲，危机四伏，需以非常手段应对，独立不惧。"),
        "010010": ("坎为水", "两水相叠，险陷重重。象征险陷、坎坷。水流而不盈，行险而不失其信。维心亨，乃以刚中也。习教事，反复练习可渡险关。"),
        "101101": ("离为火", "两火相叠，光明相继。象征依附、光明与美丽。利贞，亨通。如同火焰必须依附于可燃之物，人也需依附于正道方能成功。"),
        "001110": ("泽山咸", "山上有泽，山泽通气，相互感应。象征感应、夫妇之道。以虚受人，天地感而万物化生。强调以真诚的感情相互感应。"),
        "011100": ("雷风恒", "雷动风随，持之以恒。象征恒久、稳定。天地之道，恒久不已。立身处世应有持之以恒的精神，但需守正不移。"),
        "001111": ("天山遁", "天下有山，山势逼天，天则退避。象征退隐、逃避。君子应知时而退，明哲保身，以待来日。"),
        "111100": ("雷天大壮", "雷声响彻天际，声势浩大。象征强盛、壮大。阳气虽盛，已过半程，切忌过分强硬，应知止而行。"),
        "000101": ("火地晋", "太阳出于地上，前进光明。象征前进、晋升。君子应如太阳般自昭明德，柔进上行，得以晋升，前程光明。"),
        "101000": ("地火明夷", "太阳（火）沉入地底，光明受伤。象征黑暗、挫折。君子于黑暗时期应韬光养晦，守持正固，以待黎明。"),
        "101011": ("风火家人", "风自火出，外风助内火，家道之象。象征家庭、家人。君子言有物而行有恒。女主内，男主外，各守本分，家道正而天下定。"),
        "110101": ("火泽睽", "火向上烧，泽向下浸，二者相背。象征背离、乖离。万物睽而其事同，求同存异是处理对立关系的根本。"),
        "001010": ("水山蹇", "山上有水，水路受阻，山高水险。象征险阻、艰难。利西南不利东北，见险而能止，知矣哉！当反身修德以待时。"),
        "010100": ("雷水解", "雷雨交作，天地解冻。象征解脱、缓解。利于从险难中解脱出来，抓住时机，解除困难，走向舒坦。"),
        "110001": ("山泽损", "山下有泽，泽水浸蚀山基。象征减损、损失。损下益上，但应损而有度，损益盈虚，与时偕行。"),
        "100011": ("风雷益", "风雷相助，其势愈增。象征增益、利益。损上益下，民悦无疆。利于有所前往，利涉大川。见善则迁，有过则改。"),
        "111110": ("泽天夬", "泽水化气升于天，决降成雨。象征决断、果决。五阳决一阴，君子道长，小人道忧。宜于宣扬于王庭，但需警惕用武。"),
        "011111": ("天风姤", "天下有风，风行天下，无所不遇。象征相遇、邂逅。阴爻初生，预示着不期而遇的机缘，但也暗藏阴柔势力的蔓延。"),
        "000110": ("泽地萃", "泽在地上，聚水成沼。象征汇聚、聚集。君王至庙祭祀，聚人以享。但大聚之时易生乱，须备兵器以防不测。"),
        "011000": ("地风升", "地中生出树木，不断成长。象征上升、成长。强调柔顺而依时上升，积小成大，前程远大。"),
        "010110": ("泽水困", "泽中无水，困窘之象。象征困穷、受困。君子处困之时，应致命遂志。虽困于身，而道亨通，守正可获吉祥。"),
        "011010": ("水风井", "木上有水，如井水滋养于人。象征水井、滋养不变。村邑可变，井道不移。君子应劳民劝相，修身养德，惠人无穷。"),
        "101110": ("泽火革", "泽中有火，水灭火又生火，变革之象。象征变革、革新。天地革而四时成。顺天应人，改革之时机至为亨通。"),
        "011101": ("火风鼎", "木上有火，烹任用鼎。象征鼎新、稳固。鼎器革新食物，喻指去故立新，权力稳固。君子应正位凝命。"),
        "100100": ("震为雷", "双雷相叠，震动不息。象征震动、行动与惊醒。雷声令人恐惧，从而反省致福；也喻指巨变与动荡，需从容应对。"),
        "001001": ("艮为山", "两山重叠，稳重静止。象征停止、静止。教导人们当止则止，思不出其位，抑制邪欲，内心宁静。"),
        "001011": ("风山渐", "山上有木，树木在山上渐渐成长。象征渐进、循序渐进。女子出嫁，依礼而行则吉祥。进得位，往有功，不可躁进。"),
        "110100": ("雷泽归妹", "震长男娶兑少女，非正配。象征婚嫁，但也喻指不正当的结合或行为。名不正则言不顺，前进有凶险。"),
        "101100": ("雷火丰", "雷电交加，盛大光明。象征丰盛、盛大。盛极必衰，在丰大的时刻，更需警惕忧患，持中守正，保其光明。"),
        "001101": ("火山旅", "火在山上，火势流动不止。象征旅行、不安定。身处异乡，宜守正持柔，明慎用刑，不可贪图享乐，斤斤计较。"),
        "011011": ("巽为风", "两风相随，顺从无阻。象征顺从、进入。君子应申命行事，以柔克刚。柔顺因其位，小亨，利有攸往，利见大人。"),
        "110110": ("兑为泽", "两泽相连，互相滋润。象征喜悦、言说。君子应朋友讲习，以真诚的言行使人喜悦，自己也喜悦，亨通利贞。"),
        "010011": ("风水涣", "风行水上，冰释涣散。象征涣散、消散。君王以至诚享祭立庙，凝聚人心。利于渡过大河巨川，化险为夷。"),
        "110010": ("水泽节", "泽上有水，容量有限，需加以节制。象征节制、制度。天地有节而成四时。制数度，议德行。苦节不可贞，适中为贵。"),
        "110011": ("风泽中孚", "泽上有风，风吹泽水，诚信感于内外。象征诚信、信实。诚信如孵卵，不容半点虚假。利于涉越险阻，坚守正道则吉。"),
        "001100": ("雷山小过", "山上有雷，雷声被阻，其声稍小。象征小的过度。可做小事，不可做大事；宜下不宜上，行为须谨慎收敛。"),
        "101010": ("水火既济", "水在火上，烹任已成。象征已完成、成功。事虽成，但初吉终乱。君子思患而豫防之，防微杜渐以保成功。"),
        "010101": ("火水未济", "火在水上，难以相济。象征未完成、事未成。虽然形势不明，但阴阳各得其位，蕴含着向既济转化的可能，慎辨物居方。")
    ]
    
    if let info = hexagramDict[hexagram] {
        return HexagramInfo(name: info.0, description: info.1)
    }
    return nil
}

func generateLifeAdvice(from hexagramInfo: HexagramInfo, type: DailyInspirationView.InspirationType) -> String {
    let timePrefix = type == .daily ? "今天" : "本周"
    
    // 根据卦象名称生成人生建议
    switch hexagramInfo.name {
    case "乾为天":
        return "\(timePrefix)要保持积极主动的态度，发挥你的领导力和创造力。但记住，强势之中也要保持谦逊，避免过于刚愎自用。"
    case "坤为地":
        return "\(timePrefix)适合以柔克刚，用包容和耐心来处理问题。倾听他人意见，以合作代替对抗，厚德载物。"
    case "水雷屯":
        return "\(timePrefix)可能会遇到一些困难和挑战，但这是成长的机会。要有耐心，积蓄力量，不要急于求成。"
    case "山水蒙":
        return "\(timePrefix)是学习和启蒙的好时机。保持开放的心态，虚心求教，通过学习来提升自己。"
    case "水天需":
        return "\(timePrefix)不要急躁，耐心等待合适的时机。做好准备工作，当机会来临时你就能抓住它。"
    case "天水讼":
        return "\(timePrefix)要避免不必要的争执和冲突。如果遇到分歧，以和为贵，寻求双赢的解决方案。"
    case "地水师":
        return "\(timePrefix)适合团队合作，发挥集体的力量。如果你是领导者，要以身作则，建立良好的团队纪律。"
    case "水地比":
        return "\(timePrefix)重视人际关系，与他人建立真诚的友谊。选择值得信赖的伙伴，互相支持。"
    case "风天小畜":
        return "\(timePrefix)适合积累和储备，不要急于展现成果。专注于提升内在修养，为将来做准备。"
    case "天泽履":
        return "\(timePrefix)要谨慎行事，遵循规则和礼仪。即使面临风险，也要保持正直的品格。"
    case "地天泰":
        return "\(timePrefix)是和谐顺利的时期，但要居安思危。享受成功的同时，也要为可能的变化做准备。"
    case "天地否":
        return "\(timePrefix)可能会遇到阻碍，但不要灰心。保持内心的平静，等待转机的到来。"
    case "天火同人":
        return "\(timePrefix)适合与志同道合的人合作，发挥团队精神。放下个人成见，为共同目标努力。"
    case "火天大有":
        return "\(timePrefix)可能会有不错的收获，但要保持谦逊。用你的成功去帮助他人，分享你的智慧。"
    case "地山谦":
        return "\(timePrefix)要保持谦逊的态度，不要骄傲自满。谦虚使人进步，这是获得他人尊重的最好方式。"
    case "雷地豫":
        return "\(timePrefix)保持愉快的心情，享受生活的美好。但也要适度，不要过分沉溺于享乐。"
    case "泽雷随":
        return "\(timePrefix)要学会适应变化，跟随时势的发展。灵活调整自己的计划和策略。"
    case "山风蛊":
        return "\(timePrefix)是改革和创新的时机。勇于打破陈旧的模式，但要有计划地进行改变。"
    case "地泽临":
        return "\(timePrefix)适合承担领导责任，关心和指导他人。用你的影响力去创造积极的改变。"
    case "风地观":
        return "\(timePrefix)要仔细观察周围的环境和人事变化。通过观察学习，提高自己的洞察力。"
    case "火雷噬嗑":
        return "\(timePrefix)要果断地解决问题，不要拖延。面对障碍时，要有决心和行动力去克服。"
    case "山火贲":
        return "\(timePrefix)注重外在形象和内在修养的平衡。美化生活的同时，不要忽视实质内容。"
    case "山地剥":
        return "\(timePrefix)要保持低调，避免锋芒太露。在不利的环境中，保存实力，等待时机。"
    case "地雷复":
        return "\(timePrefix)是新的开始，充满希望。过去的困难即将过去，要积极迎接新的机遇。"
    case "天雷无妄":
        return "\(timePrefix)要保持真实和诚实，不要有虚假的行为。顺应自然，以真诚的态度对待一切。"
    case "山天大畜":
        return "\(timePrefix)适合积累知识和经验，提升自己的能力。厚积薄发，为将来的成功做准备。"
    case "山雷颐":
        return "\(timePrefix)关注自己的身心健康，注意饮食和休息。通过自我修养来获得内在的平衡。"
    case "泽风大过":
        return "\(timePrefix)可能需要采取非常规的方法来解决问题。要有勇气面对挑战，独立思考。"
    case "坎为水":
        return "\(timePrefix)可能会遇到一些困难，但要保持信心。像水一样，以柔韧的方式克服障碍。"
    case "离为火":
        return "\(timePrefix)要保持热情和光明的态度。用你的正能量去影响他人，但也要依附于正确的道路。"
    default:
        return "\(timePrefix)要保持内心的平静和智慧，用心感受生活的变化，顺应自然的规律。"
    }
}

// MARK: - 卦象视图组件

struct HexagramView: View {
    let hexagram: String
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(Array(hexagram.reversed().enumerated()), id: \.offset) { index, char in
                HStack {
                    if char == "1" {
                        // 阳爻 - 实线
                        Rectangle()
                            .fill(Color.purple)
                            .frame(width: 60, height: 6)
                    } else {
                        // 阴爻 - 断线
                        HStack(spacing: 8) {
                            Rectangle()
                                .fill(Color.purple)
                                .frame(width: 26, height: 6)
                            Rectangle()
                                .fill(Color.purple)
                                .frame(width: 26, height: 6)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DailyInspirationView()
}