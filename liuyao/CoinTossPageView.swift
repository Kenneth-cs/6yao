import SwiftUI
import Foundation
import CoreLocation

struct CoinTossPageView: View {
    let question: String
    let currentTime: Date
    let locationManager: LocationManager
    @Environment(\.dismiss) private var dismiss
    @State private var tossResults: [Bool] = []
    @State private var isAnimating = false
    @State private var showResult = false
    @State private var rotationAngle: Double = 0
    @State private var coinScale: CGFloat = 1.0
    @State private var currentAnimationIndex = 0
    @State private var hasStarted = false
    @State private var hexagramInfo: (name: String, description: String)? = nil
    @State private var showResultPage = false
    
    // iPad适配
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    private var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        ZStack {
            // 背景渐变
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
            
            // 星点背景
            ForEach(0..<20, id: \.self) { index in
                let screenWidth = max(UIScreen.main.bounds.width, 1)
                let screenHeight = max(UIScreen.main.bounds.height, 1)
                
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
                
                // 硬币动画区域
                VStack(spacing: 30) {
                    // 抛掷次数和进度指示器 - 移动到铜钱上方
                    if hasStarted {
                        VStack(spacing: 12) {
                            Text(isAnimating ? "第 \(currentAnimationIndex + 1) 次抛掷" : "抛掷完成")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            // 进度指示器
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
                    
                    // 铜钱动画
                    ZStack {
                        // 外圈 - 带动效
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.yellow.opacity(0.6), .orange.opacity(0.3)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 4
                            )
                            .frame(width: isIPad ? 160 : 120, height: isIPad ? 160 : 120)
                            .opacity(isAnimating ? 1.0 : 0.3)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
                        
                        // 硬币
                        ZStack {
                            // 外圆 - 铜钱主体
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
                                .frame(width: isIPad ? 110 : 80, height: isIPad ? 110 : 80)
                                .shadow(color: .orange.opacity(0.4), radius: 8, x: 2, y: 4)
                            
                            // 内圈边框
                            Circle()
                                .stroke(Color.orange.opacity(0.8), lineWidth: 2)
                                .frame(width: isIPad ? 110 : 80, height: isIPad ? 110 : 80)
                            
                            // 中央方孔
                            RoundedRectangle(cornerRadius: isIPad ? 6 : 4)
                                .fill(Color.orange.opacity(0.9))
                                .frame(width: isIPad ? 32 : 24, height: isIPad ? 32 : 24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: isIPad ? 6 : 4)
                                        .stroke(Color.yellow.opacity(0.6), lineWidth: 1)
                                )
                            
                            // 古代文字装饰
                            VStack {
                                HStack {
                                    Text("乾")
                                        .font(.system(size: isIPad ? 12 : 8, weight: .bold))
                                        .foregroundColor(.orange.opacity(0.8))
                                    Spacer()
                                    Text("坤")
                                        .font(.system(size: isIPad ? 12 : 8, weight: .bold))
                                        .foregroundColor(.orange.opacity(0.8))
                                }
                                .frame(width: isIPad ? 80 : 60)
                                Spacer()
                                HStack {
                                    Text("坎")
                                        .font(.system(size: isIPad ? 12 : 8, weight: .bold))
                                        .foregroundColor(.orange.opacity(0.8))
                                    Spacer()
                                    Text("离")
                                        .font(.system(size: isIPad ? 12 : 8, weight: .bold))
                                        .foregroundColor(.orange.opacity(0.8))
                                }
                                .frame(width: isIPad ? 80 : 60)
                            }
                            .frame(width: isIPad ? 80 : 60, height: isIPad ? 80 : 60)
                        }
                        .scaleEffect(coinScale)
                        .rotationEffect(.degrees(rotationAngle))
                        .rotation3DEffect(
                            .degrees(isAnimating ? 180 : 0),
                            axis: (x: 1, y: 1, z: 0)
                        )
                    }
                }
                
                // 开始占卜按钮
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
                            // 修复系统符号问题
                            HStack {
                                Image(systemName: "hand.wave.fill")  // 替换 "iphone.shake"
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
                
                // 抛掷结果显示
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
                
                // 查看卦象解读按钮
                if tossResults.count >= 6 && !isAnimating, let hexagramData = hexagramInfo {
                    VStack(spacing: 16) {
                        // 主要的解卦按钮
                        Button(action: {
                            print("🔍 [CoinTossPageView] 解卦按钮被点击")
                            print("📝 问题: \(question)")
                            print("🎲 抛掷结果: \(tossResults)")
                            print("📊 卦象信息: \(hexagramData)")
                            
                            // 延迟一点点再触发导航，确保UI更新完成
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showResultPage = true
                                print("🚀 [CoinTossPageView] 设置showResultPage = true")
                            }
                        }) {
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
                        
                        // 调试信息显示
                        if showResultPage {
                            Text("正在跳转...")
                                .font(.caption)
                                .foregroundColor(.white)
                                .opacity(0.8)
                        }
                    }
                    
                    // 使用fullScreenCover方式，确保完全独立的导航上下文
                    .fullScreenCover(isPresented: $showResultPage) {
                        DivinationResultPageView(
                            question: question,
                            tossResults: tossResults,
                            hexagramData: hexagramData,
                            currentLocation: locationManager.currentCity,
                            onDismiss: {
                                print("[CoinTossPageView] 解卦结果页面请求关闭")
                                showResultPage = false
                                
                                // 延迟一点后返回到根视图
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    dismiss()
                                    print("[CoinTossPageView] 已返回到根视图")
                                }
                            }
                        )
                    }
                }
            }
        }
        .navigationTitle("摇卦")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(hasStarted && isAnimating)
        .toolbar {
            if !hasStarted || !isAnimating {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    // MARK: - 私有方法
    private func startDivination() {
        hasStarted = true
        currentAnimationIndex = 0
        tossResults = []
        performNextToss()
    }
    
    private func performNextToss() {
        guard currentAnimationIndex < 6 else {
            isAnimating = false
            // 所有抛掷完成后计算卦象信息
            if tossResults.count == 6 {
                hexagramInfo = HexagramData.getHexagram(for: tossResults.map { $0 ? "1" : "0" }.joined())
            }
            return
        }
        
        isAnimating = true
        
        // 四阶段动画：向上抛掷 -> 旋转翻转 -> 下落收缩 -> 弹跳回复
        withAnimation(.easeOut(duration: 0.3)) {
            coinScale = 1.3
            rotationAngle += 180
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.4)) {
                self.rotationAngle += 360
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeIn(duration: 0.2)) {
                self.coinScale = 0.8
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.bouncy(duration: 0.4)) {
                self.coinScale = 1.0
            }
            
            // 生成抛掷结果
            let result = Bool.random()
            self.tossResults.append(result)
            self.currentAnimationIndex += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performNextToss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        CoinTossPageView(
            question: "测试问题",
            currentTime: Date(),
            locationManager: LocationManager()
        )
    }
}