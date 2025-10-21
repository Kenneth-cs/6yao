import SwiftUI
import Foundation

struct DailyInspirationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State private var currentHexagram: String = ""
    @State private var hexagramName: String = ""
    @State private var lifeAdvice: String = ""
    @State private var isShaking = false
    @State private var showResult = false
    @State private var currentTime = Date()
    @State private var inspirationType: InspirationType = .daily
    
    // iPad检测
    private var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
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
        Group {
            if isIPad {
                // iPad直接显示内容
                inspirationContent
            } else {
                // iPhone保持NavigationView
                NavigationView {
                    inspirationContent
                }
            }
        }
        .onAppear {
            currentTime = Date()
        }
    }
    
    // 提取的主要内容
    private var inspirationContent: some View {
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
            .navigationTitle(isIPad ? "" : "今日启示")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !isIPad {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("完成") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.purple)
                    }
                }
            }
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
    let hexagramDict: [String: HexagramInfo] = [
        "111111": HexagramInfo(name: "乾", description: "天行健，君子以自强不息"),
        "000000": HexagramInfo(name: "坤", description: "地势坤，君子以厚德载物"),
        "100010": HexagramInfo(name: "屯", description: "云雷屯，君子以经纶"),
        "010001": HexagramInfo(name: "蒙", description: "山水蒙，君子以果行育德"),
        "111010": HexagramInfo(name: "需", description: "云天需，君子以饮食宴乐"),
        "010111": HexagramInfo(name: "讼", description: "天水讼，君子以作事谋始"),
        "010000": HexagramInfo(name: "师", description: "地水师，君子以容民畜众"),
        "000010": HexagramInfo(name: "比", description: "水地比，君子以建万国，亲诸侯"),
        "111011": HexagramInfo(name: "小畜", description: "风天小畜，君子以懿文德"),
        "110111": HexagramInfo(name: "履", description: "天泽履，君子以辨上下，定民志"),
        "111000": HexagramInfo(name: "泰", description: "地天泰，君子以财成天地之道，辅相天地之宜"),
        "000111": HexagramInfo(name: "否", description: "天地否，君子以俭德辟难，不可荣以禄"),
        "101111": HexagramInfo(name: "同人", description: "天火同人，君子以类族辨物"),
        "111101": HexagramInfo(name: "大有", description: "火天大有，君子以遏恶扬善，顺天休命"),
        "001000": HexagramInfo(name: "谦", description: "地山谦，君子以裒多益寡，称物平施"),
        "000100": HexagramInfo(name: "豫", description: "雷地豫，君子以作乐崇德"),
        "100110": HexagramInfo(name: "随", description: "泽雷随，君子以向晦入宴息"),
        "011001": HexagramInfo(name: "蛊", description: "山风蛊，君子以振民育德"),
        "110000": HexagramInfo(name: "临", description: "地泽临，君子以教思无穷，容保民无疆"),
        "000011": HexagramInfo(name: "观", description: "风地观，君子以省方观民设教"),
        "100101": HexagramInfo(name: "噬嗑", description: "火雷噬嗑，君子以明罚敕法"),
        "101001": HexagramInfo(name: "贲", description: "山火贲，君子以明庶政，无敢折狱"),
        "000001": HexagramInfo(name: "剥", description: "山地剥，君子以厚下安宅"),
        "100000": HexagramInfo(name: "复", description: "地雷复，君子以见天地之心"),
        "100111": HexagramInfo(name: "无妄", description: "天雷无妄，君子以茂对时，育万物"),
        "111001": HexagramInfo(name: "大畜", description: "山天大畜，君子以多识前言往行，以畜其德"),
        "100001": HexagramInfo(name: "颐", description: "山雷颐，君子以慎言语，节饮食"),
        "011110": HexagramInfo(name: "大过", description: "泽风大过，君子以独立不惧，遁世无闷"),
        "010010": HexagramInfo(name: "坎", description: "习坎，君子以常德行，习教事"),
        "101101": HexagramInfo(name: "离", description: "明两作离，君子以继明照于四方"),
        "001110": HexagramInfo(name: "咸", description: "山泽咸，君子以虚受人"),
        "011100": HexagramInfo(name: "恒", description: "雷风恒，君子以立不易方"),
        "001111": HexagramInfo(name: "遁", description: "天山遁，君子以远小人，不恶而严"),
        "111100": HexagramInfo(name: "大壮", description: "雷天大壮，君子以非礼弗履"),
        "000101": HexagramInfo(name: "晋", description: "火地晋，君子以自昭明德"),
        "101000": HexagramInfo(name: "明夷", description: "地火明夷，君子以莅众，用晦而明"),
        "101011": HexagramInfo(name: "家人", description: "风火家人，君子以言有物，而行有恒"),
        "110101": HexagramInfo(name: "睽", description: "火泽睽，君子以同而异"),
        "001010": HexagramInfo(name: "蹇", description: "水山蹇，君子以反身修德"),
        "010100": HexagramInfo(name: "解", description: "雷水解，君子以赦过宥罪"),
        "110001": HexagramInfo(name: "损", description: "山泽损，君子以惩忿窒欲"),
        "100011": HexagramInfo(name: "益", description: "风雷益，君子以见善则迁，有过则改"),
        "111110": HexagramInfo(name: "夬", description: "泽天夬，君子以施禄及下，居德则忌"),
        "011111": HexagramInfo(name: "姤", description: "天风姤，君子以施命诰四方"),
        "000110": HexagramInfo(name: "萃", description: "泽地萃，君子以除戎器，戒不虞"),
        "011000": HexagramInfo(name: "升", description: "地风升，君子以顺德，积小以高大"),
        "010110": HexagramInfo(name: "困", description: "泽水困，君子以致命遂志"),
        "011010": HexagramInfo(name: "井", description: "水风井，君子以劳民劝相"),
        "101110": HexagramInfo(name: "革", description: "泽火革，君子以治历明时"),
        "011101": HexagramInfo(name: "鼎", description: "火风鼎，君子以正位凝命"),
        "100100": HexagramInfo(name: "震", description: "洊雷震，君子以恐惧修省"),
        "001001": HexagramInfo(name: "艮", description: "兼山艮，君子以思不出其位"),
        "001011": HexagramInfo(name: "渐", description: "风山渐，君子以居贤德善俗"),
        "110100": HexagramInfo(name: "归妹", description: "雷泽归妹，君子以永终知敝"),
        "101100": HexagramInfo(name: "丰", description: "雷火丰，君子以折狱致刑"),
        "001101": HexagramInfo(name: "旅", description: "火山旅，君子以明慎用刑，而不留狱"),
        "011011": HexagramInfo(name: "巽", description: "随风巽，君子以申命行事"),
        "110110": HexagramInfo(name: "兑", description: "丽泽兑，君子以朋友讲习"),
        "010011": HexagramInfo(name: "涣", description: "风水涣，君子以享于帝立庙"),
        "110010": HexagramInfo(name: "节", description: "水泽节，君子以制数度，议德行"),
        "110011": HexagramInfo(name: "中孚", description: "风泽中孚，君子以议狱缓死"),
        "001100": HexagramInfo(name: "小过", description: "雷山小过，君子以行过乎恭，丧过乎哀，用过乎俭"),
        "101010": HexagramInfo(name: "既济", description: "水火既济，君子以思患而豫防之"),
        "010101": HexagramInfo(name: "未济", description: "火水未济，君子以慎辨物居方")
    ]
    
    return hexagramDict[hexagram]
}

func generateLifeAdvice(from hexagramInfo: HexagramInfo, type: DailyInspirationView.InspirationType) -> String {
    let adviceTemplates: [String] = [
        "根据\(hexagramInfo.name)卦的启示，\(hexagramInfo.description)。今日宜保持内心平静，顺应自然规律，在变化中寻找机遇。",
        "\(hexagramInfo.name)卦提醒我们，\(hexagramInfo.description)。建议今日多思考，少冲动，以智慧应对挑战。",
        "从\(hexagramInfo.name)卦中可以看出，\(hexagramInfo.description)。今日适合反思过往，规划未来，保持积极心态。",
        "\(hexagramInfo.name)卦象显示，\(hexagramInfo.description)。今日宜谨慎行事，与人为善，积累正能量。",
        "根据\(hexagramInfo.name)卦的指引，\(hexagramInfo.description)。建议今日专注当下，珍惜眼前，感恩生活中的美好。"
    ]
    
    let timePrefix = type == .daily ? "今日" : "本周"
    let selectedAdvice = adviceTemplates.randomElement() ?? adviceTemplates[0]
    
    return selectedAdvice.replacingOccurrences(of: "今日", with: timePrefix)
}

// MARK: - 卦象视图组件

struct HexagramView: View {
    let hexagram: String
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(Array(hexagram.reversed().enumerated()), id: \.offset) { index, char in
                HStack {
                    if char == "1" {
                        // 阳爻（实线）
                        Rectangle()
                            .fill(Color.purple)
                            .frame(width: 60, height: 6)
                    } else {
                        // 阴爻（断线）
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