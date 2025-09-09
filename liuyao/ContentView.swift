import SwiftUI
import Foundation
import CoreLocation

struct ContentView: View {
    @State private var currentTime = Date()
    @StateObject private var locationManager = LocationManager()
    
    // 时间格式化器
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return formatter
    }()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景渐变 - 神秘紫色主题
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
                
                // 星空装饰
                VStack {
                    HStack {
                        // 左上角地区显示
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.purple.opacity(0.6))
                                .font(.caption)
                            Text(locationManager.currentCity)
                                .font(.caption)
                                .foregroundColor(.purple.opacity(0.8))
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.8))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .onTapGesture {
                            locationManager.requestLocation()
                        }
                        
                        Spacer()
                        
                        Image(systemName: "sparkles")
                            .foregroundColor(.purple.opacity(0.6))
                            .font(.title2)
                        Spacer()
                        Image(systemName: "moon.stars.fill")
                            .foregroundColor(.indigo.opacity(0.5))
                            .font(.title3)
                    }
                    .padding(.top, 20)
                    Spacer()
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.purple.opacity(0.4))
                            .font(.caption)
                        Spacer()
                        Image(systemName: "sparkles")
                            .foregroundColor(.indigo.opacity(0.3))
                            .font(.caption2)
                    }
                    .padding(.bottom, 100)
                }
                
                VStack(spacing: 30) {
                    // 顶部标题区域
                    VStack(spacing: 16) {
                        Text("六爻智卦")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple, .indigo]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        // 实时时间模块 - 缩小间距
                        VStack(spacing: 8) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.purple.opacity(0.7))
                                    .font(.caption)
                                Text("起卦时辰")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fontWeight(.medium)
                                Text("(时间节点影响卦象解读)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary.opacity(0.8))
                                    .italic()
                            }
                            
                            Text(timeFormatter.string(from: currentTime))
                                .font(.system(size: 15, weight: .medium, design: .monospaced))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.purple.opacity(0.08))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.purple.opacity(0.25), lineWidth: 1)
                                        )
                                )
                        }
                        .padding(.horizontal, 20)
                        .onReceive(timer) { _ in
                            currentTime = Date()
                        }
                        
                        Text("提问，摇卦，推演")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .fontWeight(.medium)
                    }
                    .padding(.top, 50)
                    
                    // 中央问卦区域 - 向上调整
                    VStack(spacing: 24) {
                        // 主要问卦按钮 - 改为NavigationLink
                        NavigationLink(destination: DivinationPageView(
                            currentTime: currentTime,
                            locationManager: locationManager
                        )) {
                            VStack(spacing: 12) {
                                // 古代铜钱图标
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
                                        .frame(width: 100, height: 100)
                                    
                                    // 铜钱主体
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
                                            .frame(width: 80, height: 80)
                                            .shadow(color: .orange.opacity(0.4), radius: 8, x: 2, y: 4)
                                        
                                        // 内圈边框
                                        Circle()
                                            .stroke(Color.orange.opacity(0.8), lineWidth: 2)
                                            .frame(width: 80, height: 80)
                                        
                                        // 中央方孔
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.orange.opacity(0.9))
                                            .frame(width: 24, height: 24)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(Color.yellow.opacity(0.6), lineWidth: 1)
                                            )
                                        
                                        // 古代文字装饰
                                        VStack {
                                            HStack {
                                                Text("乾")
                                                    .font(.system(size: 8, weight: .bold))
                                                    .foregroundColor(.orange.opacity(0.8))
                                                Spacer()
                                                Text("坤")
                                                    .font(.system(size: 8, weight: .bold))
                                                    .foregroundColor(.orange.opacity(0.8))
                                            }
                                            .frame(width: 60)
                                            Spacer()
                                            HStack {
                                                Text("坎")
                                                    .font(.system(size: 8, weight: .bold))
                                                    .foregroundColor(.orange.opacity(0.8))
                                                Spacer()
                                                Text("离")
                                                    .font(.system(size: 8, weight: .bold))
                                                    .foregroundColor(.orange.opacity(0.8))
                                            }
                                            .frame(width: 60)
                                        }
                                        .frame(width: 60, height: 60)
                                    }
                                }
                                
                                Text("此刻 你想知道什么?")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                Text("点击开始问卦")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 30)
                            .padding(.horizontal, 40)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: .purple.opacity(0.2), radius: 15, x: 0, y: 8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.purple.opacity(0.3), .indigo.opacity(0.2)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // 示例问题按钮 - 改为NavigationLink
                        VStack(spacing: 8) {
                            Text("或者问问其他的...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 12) {
                                ForEach(["工作", "感情", "健康"], id: \.self) { topic in
                                    NavigationLink(destination: DivinationPageView(
                                        currentTime: currentTime,
                                        locationManager: locationManager,
                                        defaultQuestion: getDefaultQuestion(for: topic)
                                    )) {
                                        Text(topic)
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.purple.opacity(0.1), .indigo.opacity(0.05)]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                    )
                                    .foregroundColor(.purple)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 底部导航 - 改为NavigationLink
                    HStack(spacing: 40) {
                        NavigationLink(destination: LearningPageView()) {
                            NavigationButtonContent(icon: "book.fill", title: "学习")
                        }
                        NavigationLink(destination: HistoryPageView()) {
                            NavigationButtonContent(icon: "clock.fill", title: "历史")
                        }
                        Button(action: {}) {
                            NavigationButtonContent(icon: "person.fill", title: "我的")
                        }
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
    
    // 添加默认问题生成函数
    private func getDefaultQuestion(for topic: String) -> String {
        switch topic {
        case "工作":
            return "我的工作发展如何？"
        case "感情":
            return "我的感情状况怎样？"
        case "健康":
            return "我的身体健康如何？"
        default:
            return ""
        }
    }
}

// 修改导航按钮组件
struct NavigationButtonContent: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.gray)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// 问卦界面
struct DivinationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var question = ""
    @State private var showCoinToss = false
    @State private var divinationStartTime: Date?
    let onDismissToHome: () -> Void
    let currentTime: Date  // 添加起卦时间参数
    let locationManager: LocationManager  // 添加位置管理器参数
    
    var body: some View {
        ZStack {
            // 背景 - 紫色主题
            LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.08),
                        Color.indigo.opacity(0.05),
                        Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // 标题
                    VStack(spacing: 8) {
                        Text("心有所问，卦有所答")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple, .indigo]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("请输入你想要咨询的问题")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // 问题输入区域
                    VStack(alignment: .leading, spacing: 12) {
                        Text("你的问题")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("例如：我和他之间还有未来吗？", text: $question, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                            .font(.body)
                    }
                    .padding(.horizontal, 20)
                    
                    // 开始摇卦按钮
                    Button(action: {
                            if !question.isEmpty {
                                divinationStartTime = Date()  // 记录起卦开始时间
                                showCoinToss = true
                            }
                        }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("开始摇卦")
                            Image(systemName: "sparkles")
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 40)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple, .indigo]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .disabled(question.isEmpty)
                    .opacity(question.isEmpty ? 0.6 : 1.0)
                    
                    Spacer()
                    
                    // 提示信息
                    VStack(spacing: 8) {
                        Text("💡 提示")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                        
                        Text("问题越具体，解卦越准确\n建议以疑问句的形式提问")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("问卦")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.purple)
                }
        }
        .sheet(isPresented: $showCoinToss) {
            NavigationStack {
                CoinTossView(question: question, currentTime: divinationStartTime ?? currentTime, locationManager: locationManager, onDismissToHome: onDismissToHome)
            }
        }
    }
}

// 摇动检测的UIViewControllerRepresentable
struct ShakeDetector: UIViewControllerRepresentable {
    let onShake: () -> Void
    
    func makeUIViewController(context: Context) -> ShakeDetectorViewController {
        let controller = ShakeDetectorViewController()
        controller.onShake = onShake
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ShakeDetectorViewController, context: Context) {}
}

class ShakeDetectorViewController: UIViewController {
    var onShake: (() -> Void)?
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            onShake?()
        }
    }
}

// 抛硬币界面
struct CoinTossView: View {
    let question: String
    let currentTime: Date
    let locationManager: LocationManager
    @Environment(\.presentationMode) var presentationMode
    @State private var tossResults: [Bool] = []
    @State private var isAnimating = false
    @State private var showResult = false
    @State private var rotationAngle: Double = 0
    @State private var coinScale: CGFloat = 1.0
    @State private var currentAnimationIndex = 0
    @State private var hasStarted = false
    @State private var hexagramInfo: (name: String, description: String)? = nil
    let onDismissToHome: () -> Void
    
    var body: some View {
        ZStack {
            // 神秘背景
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.9),
                        Color.purple.opacity(0.6),
                        Color.indigo.opacity(0.4)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // 摇动检测
                ShakeDetector {
                    if !hasStarted && !isAnimating {
                        startDivination()
                    }
                }
                
                // 修复星空效果 - 确保所有数值都是有效的
                ForEach(0..<20, id: \.self) { index in
                    let screenWidth = max(UIScreen.main.bounds.width, 1)
                    let screenHeight = max(UIScreen.main.bounds.height, 1)
                    
                    // 使用固定的相对位置避免随机数导致的NaN
                    let positions: [(CGFloat, CGFloat)] = [
                        (screenWidth * 0.1, screenHeight * 0.15),
                        (screenWidth * 0.3, screenHeight * 0.12),
                        (screenWidth * 0.7, screenHeight * 0.18),
                        (screenWidth * 0.9, screenHeight * 0.14),
                        (screenWidth * 0.2, screenHeight * 0.25),
                        (screenWidth * 0.8, screenHeight * 0.22),
                        (screenWidth * 0.15, screenHeight * 0.35),
                        (screenWidth * 0.5, screenHeight * 0.32),
                        (screenWidth * 0.85, screenHeight * 0.38),
                        (screenWidth * 0.25, screenHeight * 0.45),
                        (screenWidth * 0.75, screenHeight * 0.42),
                        (screenWidth * 0.1, screenHeight * 0.55),
                        (screenWidth * 0.4, screenHeight * 0.52),
                        (screenWidth * 0.9, screenHeight * 0.58),
                        (screenWidth * 0.3, screenHeight * 0.65),
                        (screenWidth * 0.6, screenHeight * 0.62),
                        (screenWidth * 0.2, screenHeight * 0.75),
                        (screenWidth * 0.7, screenHeight * 0.72),
                        (screenWidth * 0.45, screenHeight * 0.82),
                        (screenWidth * 0.8, screenHeight * 0.85)
                    ]
                    
                    let position = positions[index % positions.count]
                    let sizes: [CGFloat] = [1.0, 1.5, 2.0, 2.5, 3.0]
                    let opacities: [Double] = [0.3, 0.4, 0.5, 0.6, 0.7, 0.8]
                    
                    let starSize = max(sizes[index % sizes.count], 0.5)
                    let starOpacity = max(opacities[index % opacities.count], 0.1)
                    
                    Circle()
                        .fill(Color.white.opacity(starOpacity))
                        .frame(width: starSize, height: starSize)
                        .position(x: max(position.0, 0), y: max(position.1, 0))
                }
                
                VStack(spacing: 40) {
                    // 问题显示
                    VStack(spacing: 8) {
                        Text(hasStarted ? "正在为您解答" : "准备开始占卜")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text(question)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    // 抛硬币进度
                    if hasStarted {
                        VStack(spacing: 16) {
                            Text(isAnimating ? "第 \(currentAnimationIndex + 1) 次抛掷" : "抛掷完成")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            // 进度条
                            HStack(spacing: 8) {
                                ForEach(0..<6, id: \.self) { index in
                                    Circle()
                                        .fill(index < tossResults.count ? 
                                              LinearGradient(
                                                gradient: Gradient(colors: [.yellow, .orange]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                              ) : 
                                              LinearGradient(
                                                gradient: Gradient(colors: [.white.opacity(0.3), .white.opacity(0.1)]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                              )
                                        )
                                        .frame(width: 12, height: 12)
                                        .scaleEffect(index == currentAnimationIndex && isAnimating ? 1.5 : 1.0)
                                        .animation(.easeInOut(duration: 0.3), value: currentAnimationIndex)
                                }
                            }
                        }
                    }
                    
                    // 增强的铜钱动画
                    ZStack {
                        // 外圈光环
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.yellow.opacity(0.6), .orange.opacity(0.3)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 4
                            )
                            .frame(width: 140, height: 140)
                            .opacity(isAnimating ? 1.0 : 0.3)
                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
                        
                        // 铜钱主体
                        ZStack {
                            // 主圆形
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            Color.yellow.opacity(0.9),
                                            Color.orange.opacity(0.8),
                                            Color.yellow.opacity(0.6)
                                        ]),
                                        center: .center,
                                        startRadius: 20,
                                        endRadius: 60
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .shadow(color: .yellow.opacity(0.6), radius: 20, x: 0, y: 0)
                            
                            // 外圈装饰
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.orange.opacity(0.8), .yellow.opacity(0.6)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                                .frame(width: 120, height: 120)
                            
                            // 内圈
                            Circle()
                                .stroke(Color.orange.opacity(0.7), lineWidth: 2)
                                .frame(width: 90, height: 90)
                            
                            // 中央方孔
                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.orange.opacity(0.9), .yellow.opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 30, height: 30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.yellow.opacity(0.8), lineWidth: 2)
                                )
                            
                            // 八卦符号装饰
                            VStack {
                                HStack {
                                    Text("☰")
                                        .font(.system(size: 12))
                                        .foregroundColor(.orange.opacity(0.8))
                                    Spacer()
                                    Text("☷")
                                        .font(.system(size: 12))
                                        .foregroundColor(.orange.opacity(0.8))
                                }
                                .frame(width: 80)
                                Spacer()
                                HStack {
                                    Text("☵")
                                        .font(.system(size: 12))
                                        .foregroundColor(.orange.opacity(0.8))
                                    Spacer()
                                    Text("☲")
                                        .font(.system(size: 12))
                                        .foregroundColor(.orange.opacity(0.8))
                                }
                                .frame(width: 80)
                            }
                            .frame(width: 80, height: 80)
                        }
                        .scaleEffect(coinScale)
                        .rotationEffect(.degrees(rotationAngle))
                        .rotation3DEffect(
                            .degrees(isAnimating ? 180 : 0),
                            axis: (x: 1, y: 1, z: 0)
                        )
                    }
                    
                    // 开始按钮或提示
                    if !hasStarted && !isAnimating {
                        VStack(spacing: 20) {
                            Button(action: {
                                startDivination()
                            }) {
                                HStack {
                                    Image(systemName: "sparkles")
                                    Text("开始占卜")
                                    Image(systemName: "sparkles")
                                }
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 40)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.yellow, .orange]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: .yellow.opacity(0.4), radius: 8, x: 0, y: 4)
                            }
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Image(systemName: "iphone.shake")
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("或摇动手机开始")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .font(.caption)
                                
                                Text("将自动生成6次抛掷结果")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                    }
                    
                    // 结果显示
                    if tossResults.count > 0 {
                        VStack(spacing: 8) {
                            Text("抛掷结果")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                ForEach(0..<tossResults.count, id: \.self) { index in
                                    Text(tossResults[index] ? "阳" : "阴")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: 
                                                    tossResults[index] ? [.yellow, .orange] : [.gray.opacity(0.7), .gray.opacity(0.5)]
                                                ),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .cornerRadius(8)
                                        .scaleEffect(index == tossResults.count - 1 && isAnimating ? 1.2 : 1.0)
                                        .animation(.bouncy(duration: 0.5), value: tossResults.count)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 完成按钮
                    if tossResults.count >= 6 && !isAnimating, let hexagramData = hexagramInfo {
                        NavigationLink(destination: DivinationResultPageView(
                            question: question,
                            tossResults: tossResults,
                            hexagramData: hexagramData
                        )) {
                            HStack {
                                Image(systemName: "eye.fill")
                                Text("查看卦象解读")
                                Image(systemName: "sparkles")
                            }
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 40)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.yellow, .orange]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: .yellow.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true)
    }
    
    // 开始占卜函数
    private func startDivination() {
        guard !hasStarted && !isAnimating else { return }
        
        hasStarted = true
        isAnimating = true
        currentAnimationIndex = 0
        tossResults = []
        
        // 连续执行6次抛掷动画
        performNextToss()
    }
    
    // 执行下一次抛掷
    private func performNextToss() {
        guard currentAnimationIndex < 6 else {
            isAnimating = false
            // 所有抛掷完成后计算卦象信息
            if tossResults.count == 6 {
                hexagramInfo = HexagramData.getHexagram(for: tossResults.map { $0 ? "1" : "0" }.joined())
            }
            return
        }
        
        // 铜钱动画效果
        withAnimation(.easeInOut(duration: 0.3)) {
            coinScale = 1.3
        }
        
        withAnimation(.easeInOut(duration: 1.5)) {
            rotationAngle += 360
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 1.0)) {
                coinScale = 0.9
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.bouncy(duration: 0.4)) {
                coinScale = 1.0
            }
            
            // 生成结果
            let result = Bool.random()
            tossResults.append(result)
            currentAnimationIndex += 1
            
            // 继续下一次抛掷
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                performNextToss()
            }
        }
    }
}




// 结果展示界面
struct ResultView: View {
    let question: String
    let tossResults: [Bool]
    let divinationTime: Date  // 静态起卦时间
    let divinationLocation: String  // 起卦地点
    @Environment(\.presentationMode) var presentationMode
    @State private var divinationResult: DivinationResult?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @StateObject private var dataService = DataService()
    @State private var isSaved = false
    @State private var streamingContent = ""
    @State private var isStreaming = false
    let onDismissToHome: () -> Void
    
    // 添加计算属性来获取卦名和卦象描述
    private var hexagramInfo: (name: String, description: String) {
        let binary = tossResults.map { $0 ? "1" : "0" }.joined()
        return HexagramData.getHexagram(for: binary)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 问题显示
                    VStack(spacing: 8) {
                        Text("您的问题")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(question)
                            .font(.title3)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    // 起卦信息部分 - 优化布局
                    VStack(alignment: .leading, spacing: 20) {
                        // 标题
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title3)
                            Text("起卦信息")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.bottom, 8)
                        
                        // 卦名和描述
                        VStack(alignment: .leading, spacing: 16) {
                            // 卦名
                            HStack(alignment: .top, spacing: 12) {
                                Text("卦名")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                    .frame(width: 60, alignment: .leading)
                                
                                Text(hexagramInfo.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            
                            // 卦象描述
                            HStack(alignment: .top, spacing: 12) {
                                Text("卦象")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                    .frame(width: 60, alignment: .leading)
                                
                                Text(hexagramInfo.description)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            
                            // 分隔线
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                                .padding(.vertical, 8)
                            
                            // 起卦时间（静态）
                            HStack(alignment: .center, spacing: 12) {
                                HStack(spacing: 6) {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(.blue)
                                        .font(.body)
                                    Text("起卦时间")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                }
                                .frame(width: 80, alignment: .leading)
                                
                                Text(DateFormatter.divinationTime.string(from: divinationTime))
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            
                            // 起卦地点
                            HStack(alignment: .center, spacing: 12) {
                                HStack(spacing: 6) {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(.blue)
                                        .font(.body)
                                    Text("起卦地点")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                }
                                .frame(width: 80, alignment: .leading)
                                
                                Text(divinationLocation)
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color.clear)
                    )
                    
                    // 卦象显示
                    VStack(spacing: 16) {
                        HStack {
                            Text("卦象")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.purple, .indigo]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            if let result = divinationResult {
                                Spacer()
                                Text(result.hexagramName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.purple)
                            }
                        }
                        
                        VStack(spacing: 4) {
                            ForEach(0..<6, id: \.self) { index in
                                HStack(spacing: 8) {
                                    if tossResults[5-index] {
                                        // 阳爻
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.purple, .indigo]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: 60, height: 8)
                                    } else {
                                        // 阴爻
                                        HStack(spacing: 4) {
                                            Rectangle()
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [.purple, .indigo]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: 28, height: 8)
                                            Rectangle()
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [.purple, .indigo]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: 28, height: 8)
                                        }
                                    }
                                    
                                    Text(tossResults[5-index] ? "阳" : "阴")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.purple.opacity(0.05), .indigo.opacity(0.03)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.purple.opacity(0.3), .indigo.opacity(0.2)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                        )
                    }
                    
                    // AI解读部分
                    VStack(alignment: .leading, spacing: 20) {
                        if isStreaming {
                            // 流式显示正在生成的内容
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.blue)
                                        .font(.title3)
                                    Text("卦象分析")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    
                                    // 添加打字机效果指示器
                                    Text("●")
                                        .foregroundColor(.blue)
                                        .opacity(0.7)
                                        .scaleEffect(1.2)
                                        .animation(.easeInOut(duration: 0.8).repeatForever(), value: isStreaming)
                                    
                                    Spacer()
                                }
                                
                                // 实时显示生成的内容
                                Text(streamingContent)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .animation(.easeInOut(duration: 0.3), value: streamingContent)
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                            )
                        } else if isLoading {
                            // 改进的加载状态
                            VStack(spacing: 16) {
                                // 添加进度指示
                                HStack(spacing: 12) {
                                    ProgressView()
                                        .scaleEffect(1.2)
                                        .tint(.purple)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("AI正在解读卦象...")
                                            .font(.body)
                                            .foregroundColor(.primary)
                                        
                                        Text("预计需要10-30秒")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                // 添加取消按钮
                                Button("取消解读") {
                                    // 取消当前请求
                                    cancelAIRequest()
                                }
                                .font(.caption)
                                .foregroundColor(.orange)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(30)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.purple.opacity(0.05), .indigo.opacity(0.03)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                        } else if let error = errorMessage {
                            // 错误状态
                            VStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                
                                Text("解读失败")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(error)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Button("重新解读") {
                                    Task {
                                        await loadAIInterpretation()
                                    }
                                }
                                .font(.body)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
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
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.orange.opacity(0.05), .red.opacity(0.03)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                        } else if let result = divinationResult {
                            // 成功状态 - 显示AI解读
                            VStack(alignment: .leading, spacing: 20) {
                                // 卦象分析
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "sparkles")
                                            .foregroundColor(.blue)
                                            .font(.title3)
                                        Text("卦象分析")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                        Spacer()
                                    }
                                    
                                    // 使用格式化显示替代简单Text
                                    FormattedTextView(segments: formatAIText(result.aiInterpretation))
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.blue.opacity(0.03),
                                                    Color.cyan.opacity(0.02)
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
                                                            Color.blue.opacity(0.15),
                                                            Color.cyan.opacity(0.1)
                                                        ]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1
                                                )
                                        )
                                        .shadow(color: .blue.opacity(0.08), radius: 4, x: 0, y: 2)
                                )
                                
                                // 建议指导
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "lightbulb.fill")
                                            .foregroundColor(.orange)
                                            .font(.title3)
                                        Text("建议指导")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.orange)
                                        Spacer()
                                    }
                                    
                                    FormattedTextView(segments: formatAIText(result.advice))
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
                            }
                        }
                    }
                    
                    // 操作按钮
                    HStack(spacing: 16) {
                        Button(isSaved ? "已保存" : "保存记录") {
                            if !isSaved {
                                saveRecord()
                            }
                        }
                        .font(.body)
                        .foregroundColor(isSaved ? .secondary : .purple)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: isSaved ? [.gray, .gray] : [.purple, .indigo]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .disabled(isSaved)
                        
                        Button("重新问卦") {
                            onDismissToHome()
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
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("解卦结果")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        onDismissToHome()
                    }
                    .foregroundColor(.purple)
                }
            }
        }
        .task {
            await loadAIInterpretation()
        }
    }
    
    private func saveRecord() {
        guard let result = divinationResult else { return }
        
        dataService.saveDivinationRecord(
            question: question,
            tossResults: tossResults,
            aiInterpretation: result.aiInterpretation,
            advice: result.advice
        )
        
        withAnimation {
            isSaved = true
        }
    }
    
    private func cancelAIRequest() {
        isLoading = false
        isStreaming = false
        streamingContent = ""
        errorMessage = "解读已取消"
    }
    
    private func loadAIInterpretation() async {
        isLoading = true
        errorMessage = nil
        
        do {
            print("开始AI解读请求...")
            print("问题: \(question)")
            print("抛掷结果: \(tossResults)")
            
            let result = try await AIService.shared.interpretDivination(
                question: question,
                tossResults: tossResults,
                divinationTime: divinationTime,
                divinationLocation: divinationLocation
            )
            print("AI解读成功: \(result)")
            
            // 检查回答完整性
            if result.aiInterpretation.isEmpty || result.advice.isEmpty {
                print("警告：AI回答可能不完整")
            }
            
            await MainActor.run {
                self.divinationResult = result
                self.isLoading = false
            }
        } catch {
            print("AI解读失败: \(error)")
            
            // 更详细的错误信息
            let detailedError: String
            if let networkError = error as? NetworkError {
                switch networkError {
                case .networkError(let underlyingError):
                    if (underlyingError as NSError).code == -1001 {
                        detailedError = "网络请求超时，请检查网络连接后重试"
                    } else {
                        detailedError = "网络连接失败: \(underlyingError.localizedDescription)"
                    }
                case .serverError(let code):
                    detailedError = "服务器错误 (\(code))，请稍后重试"
                default:
                    detailedError = networkError.localizedDescription
                }
            } else {
                detailedError = error.localizedDescription
            }
            
            await MainActor.run {
                self.errorMessage = detailedError
                self.isLoading = false
            }
        }
    }
}



// 添加DateFormatter扩展
extension DateFormatter {
    static let divinationTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return formatter
    }()
}

#Preview {
    ContentView()
}
