import SwiftUI

struct ContentView: View {
    @State private var showDivination = false
    
    var body: some View {
        NavigationView {
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
                
                VStack(spacing: 40) {
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
                        
                        Text("提问，摇卦，推演")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .fontWeight(.medium)
                    }
                    .padding(.top, 60)
                    
                    // 中央问卦区域
                    VStack(spacing: 24) {
                        // 主要问卦按钮
                        Button(action: {
                            showDivination = true
                        }) {
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
                        
                        // 示例问题
                        VStack(spacing: 8) {
                            Text("或者问问其他的...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 12) {
                                ForEach(["工作", "感情", "健康"], id: \.self) { topic in
                                    Button(topic) {
                                        showDivination = true
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
                    
                    // 底部导航
                    HStack(spacing: 40) {
                        NavigationButton(icon: "book.fill", title: "学习", action: {})
                        NavigationButton(icon: "clock.fill", title: "历史", action: {})
                        NavigationButton(icon: "person.fill", title: "我的", action: {})
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showDivination) {
            DivinationView()
        }
    }
}

// 导航按钮组件
struct NavigationButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
}

// 问卦界面
struct DivinationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var question = ""
    @State private var showCoinToss = false
    
    var body: some View {
        NavigationView {
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
        }
        .sheet(isPresented: $showCoinToss) {
            CoinTossView(question: question)
        }
    }
}

// 抛硬币界面
struct CoinTossView: View {
    let question: String
    @Environment(\.presentationMode) var presentationMode
    @State private var currentToss = 0
    @State private var tossResults: [Bool] = []
    @State private var isAnimating = false
    @State private var showResult = false
    @State private var rotationAngle: Double = 0
    @State private var coinScale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
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
                
                // 星空效果
                ForEach(0..<20, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.3...0.8)))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        )
                }
                
                VStack(spacing: 40) {
                    // 问题显示
                    VStack(spacing: 8) {
                        Text("正在为您解答")
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
                    VStack(spacing: 16) {
                        Text("第 \(currentToss + 1) 次抛掷")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        // 进度条
                        HStack(spacing: 8) {
                            ForEach(0..<6, id: \.self) { index in
                                Circle()
                                    .fill(index <= currentToss ? 
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
                    
                    // 抛掷按钮
                    if currentToss < 6 && !isAnimating {
                        Button(action: tossCoin) {
                            HStack {
                                Image(systemName: "hand.raised.fill")
                                Text("抛掷铜钱")
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
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 完成按钮
                    if currentToss >= 6 {
                        Button(action: {
                            showResult = true
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
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showResult) {
            ResultView(question: question, tossResults: tossResults)
        }
    }
    
    private func tossCoin() {
        isAnimating = true
        
        // 复杂的动画效果
        withAnimation(.easeInOut(duration: 0.3)) {
            coinScale = 1.3
        }
        
        withAnimation(.easeInOut(duration: 2.0)) {
            rotationAngle += 720 // 旋转两圈
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 1.5)) {
                coinScale = 0.8
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.bouncy(duration: 0.4)) {
                coinScale = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            let result = Bool.random()
            tossResults.append(result)
            currentToss += 1
            isAnimating = false
        }
    }
}

// 结果展示界面
struct ResultView: View {
    let question: String
    let tossResults: [Bool]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 问题回顾
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
                    
                    // 卦象展示
                    VStack(spacing: 16) {
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
                    
                    // AI解读区域
                    VStack(alignment: .leading, spacing: 16) {
                        Text("AI解读")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple, .indigo]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("卦象分析")
                                .font(.headline)
                                .foregroundColor(.purple)
                            
                            Text("根据您的问题和卦象，此卦显示...")
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Text("建议指导")
                                .font(.headline)
                                .foregroundColor(.purple)
                                .padding(.top, 8)
                            
                            Text("建议您在此事上保持耐心，时机尚未成熟...")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        .padding(20)
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
                    }
                    
                    // 操作按钮
                    HStack(spacing: 16) {
                        Button("保存记录") {
                            // 保存功能
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
                        
                        Button("重新问卦") {
                            presentationMode.wrappedValue.dismiss()
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
                        // 关闭所有弹窗，回到主界面
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.purple)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
