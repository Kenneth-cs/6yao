import SwiftUI
import Network

struct DivinationResultPageView: View {
    let question: String
    let tossResults: [Bool]
    let hexagramData: (name: String, description: String)
    let currentLocation: String
    let onDismiss: () -> Void
    @State private var aiInterpretation: String = ""
    @State private var hexagramAnalysis: String = ""
    @State private var questionInterpretation: String = ""
    @State private var guidanceAdvice: String = ""
    @State private var isLoading = true
    @State private var showSaveAlert = false
    @State private var divinationTime: Date = Date() // 静态起卦时间
    @StateObject private var aiService = AIService.shared
    @StateObject private var dataService = DataService()
    @State private var networkMonitor = NWPathMonitor()
    @State private var isNetworkAvailable = true
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 顶部信息区域
                VStack(spacing: 20) {
                    // 标题和完成按钮
                    HStack {
                        Text("解卦结果")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple, .indigo]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Spacer()
                        
                         Button(action: {
                             // 回到首页 - 通过回调关闭页面
                             print("[DivinationResultPageView] 点击完成按钮")
                             onDismiss()
                         }) {
                            Text("完成")
                                .font(.headline)
                                .foregroundColor(.purple)
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // 问题显示
                    VStack(spacing: 8) {
                        Text("您的问题")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(question)
                            .font(.title2)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    
                    // 起卦信息区域 - 简洁白色背景布局
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title3)
                            Text("起卦信息")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // 卦名
                            HStack {
                                Text("卦名")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(width: 60, alignment: .leading)
                                
                                Text(hexagramData.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            
                            // 卦象描述
                            VStack(alignment: .leading, spacing: 4) {
                                Text("卦象")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(hexagramData.description)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            // 起卦时间
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                                Text("起卦时间")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(formatDate(divinationTime))
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            
                            // 起卦地点
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                                Text("起卦地点")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(currentLocation.isEmpty ? "未知地点" : currentLocation)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // 卦象显示 - 卡片样式居中显示
                    VStack(spacing: 20) {
                        Text("卦象")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                        
                        // 爻象显示卡片
                        VStack(spacing: 12) {
                            ForEach(Array(tossResults.enumerated().reversed()), id: \.offset) { index, result in
                                HStack {
                                    if result {
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.purple, .indigo]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: 100, height: 8)
                                    } else {
                                        HStack(spacing: 8) {
                                            Rectangle()
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [.purple, .indigo]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: 46, height: 8)
                                            Rectangle()
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [.purple, .indigo]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: 46, height: 8)
                                        }
                                    }
                                    
                                    Text(result ? "阳" : "阴")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                        .frame(width: 30)
                                }
                            }
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                        )
                        .frame(maxWidth: 280)
                    }
                    .padding(.horizontal, 20)
                }
                .background(Color.white)
                .padding(.bottom, 30)
                
                // AI解读内容区域
                if isLoading {
                    VStack(spacing: 16) {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(.purple)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("AI正在解读卦象...")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Text("请稍候，正在为您分析卦象含义")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // 改进的提示信息
                        VStack(spacing: 8) {
                            Text("💡 解读过程可能需要30-60秒")
                                .font(.caption)
                                .foregroundColor(.orange)
                            
                            Text("网络不佳时会自动重试，请耐心等待")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Button("取消解读") {
                            // 取消解读逻辑
                            isLoading = false
                            aiInterpretation = "解读已取消"
                        }
                        .font(.subheadline)
                        .foregroundColor(.orange)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                    .background(Color(.systemBackground))
                } else {
                    VStack(spacing: 20) {
                        // 检查是否有错误状态
                        if aiInterpretation.contains("解读失败") || aiInterpretation.contains("超时") || aiInterpretation.contains("网络") {
                            // 错误状态显示
                            VStack(spacing: 12) {
                                Image(systemName: "wifi.exclamationmark")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                
                                Text("网络请求超时")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("请检查网络连接，或稍后重试")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Button("重新解读") {
                                    isLoading = true
                                    aiInterpretation = ""
                                    hexagramAnalysis = ""
                                    questionInterpretation = ""
                                    guidanceAdvice = ""
                                    // 延迟一点重新请求
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        requestAIInterpretation()
                                    }
                                }
                                .font(.body)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.purple, .indigo]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(20)
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                        } else {
                            // 卦象解析板块
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .foregroundColor(.blue)
                                        .font(.title2)
                                    Text("卦象解析")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    Spacer()
                                }
                                
                                if !hexagramAnalysis.isEmpty {
                                    Text(hexagramAnalysis)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .lineSpacing(6)
                                        .multilineTextAlignment(.leading)
                                } else {
                                    Text("正在解析卦象含义...")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .italic()
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.blue.opacity(0.08), .cyan.opacity(0.05)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                            )
                            .padding(.horizontal, 20)
                            
                            // 问题解读板块
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "questionmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                    Text("问题解读")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                    Spacer()
                                }
                                
                                if !questionInterpretation.isEmpty {
                                    Text(questionInterpretation)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .lineSpacing(6)
                                        .multilineTextAlignment(.leading)
                                } else {
                                    Text("正在解读问题...")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .italic()
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.green.opacity(0.08), .mint.opacity(0.05)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                            )
                            .padding(.horizontal, 20)
                            
                            // 建议指导板块
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(.orange)
                                        .font(.title2)
                                    Text("建议指导")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.orange)
                                    Spacer()
                                }
                                
                                if !guidanceAdvice.isEmpty {
                                    Text(guidanceAdvice)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .lineSpacing(6)
                                        .multilineTextAlignment(.leading)
                                } else {
                                    Text("正在生成建议指导...")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .italic()
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.orange.opacity(0.08), .yellow.opacity(0.05)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 30)
                    .background(Color(.systemBackground))
                }
                
                // 底部功能按钮
                if !isLoading {
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            // 保存记录按钮
                            Button(action: saveResult) {
                                Text("保存记录")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.purple)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.purple, lineWidth: 1.5)
                                            .background(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(Color(.systemBackground))
                                            )
                                    )
                            }
                            
                             // 重新问卦按钮
                             Button(action: {
                                 // 通过回调关闭页面，返回首页
                                 print("[DivinationResultPageView] 点击重新问卦按钮")
                                 onDismiss()
                             }) {
                                Text("重新问卦")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.purple, .indigo]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(25)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                    .background(Color(.systemBackground))
                }
            }
        }
        .navigationTitle("解卦结果")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .alert("保存成功", isPresented: $showSaveAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text("解卦结果已保存到历史记录中")
        }
        .onAppear {
            divinationTime = Date() // 设置起卦时间为当前时间
            // 延迟执行网络相关操作，避免阻塞导航
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startNetworkMonitoring()
                requestAIInterpretation()
            }
        }
        .onDisappear {
            stopNetworkMonitoring()
        }
    }
    
    // MARK: - 私有方法
    private func requestAIInterpretation() {
        print("[DivinationResultPageView] 开始请求AI解读")
        
        // 检查网络连接
        if !isNetworkAvailable {
            print("[DivinationResultPageView] 网络不可用")
            aiInterpretation = "网络连接不可用，请检查网络设置后重试。"
            isLoading = false
            return
        }
        
        print("[DivinationResultPageView] 卦象信息: \(hexagramData.name)")
        
        Task {
            do {
                // 先测试API连接
                print("[DivinationResultPageView] 测试API连接...")
                let testResult = try await aiService.testAPIConnection()
                print("[DivinationResultPageView] API连接测试结果: \(testResult)")
                
                // 如果测试成功，进行正式解读
                print("[DivinationResultPageView] 调用AIService.interpretDivinationStream")
                let hexagramStruct = HexagramData(name: hexagramData.name, description: hexagramData.description)
                
                let interpretation = try await aiService.interpretDivinationStream(
                    question: question,
                    hexagram: hexagramStruct,
                    tossResults: tossResults,
                    divinationTime: divinationTime,
                    divinationLocation: currentLocation.isEmpty ? "未知地点" : currentLocation
                )
                
                print("[DivinationResultPageView] AI解读完成，长度: \(interpretation.count)")
                
                await MainActor.run {
                    self.aiInterpretation = interpretation
                    self.parseAIInterpretation(interpretation)
                    self.isLoading = false
                    print("[DivinationResultPageView] UI更新完成")
                }
            } catch {
                print("[DivinationResultPageView] AI解读失败: \(error.localizedDescription)")
                
                // 更详细的错误处理
                let errorMessage: String
                if let networkError = error as? NetworkError {
                    errorMessage = networkError.localizedDescription
                } else if let aiError = error as? AIServiceError {
                    errorMessage = aiError.localizedDescription
                } else {
                    errorMessage = "网络连接超时，请检查网络后重试"
                }
                
                await MainActor.run {
                    self.aiInterpretation = "解读失败：\(errorMessage)"
                    self.isLoading = false
                }
            }
        }
    }
    
    private func saveResult() {
        dataService.saveDivinationRecord(
            question: question,
            tossResults: tossResults,
            aiInterpretation: aiInterpretation,
            advice: aiInterpretation
        )
        showSaveAlert = true
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    private func parseAIInterpretation(_ interpretation: String) {
        // 根据关键词分割内容到三个板块
        let lines = interpretation.components(separatedBy: .newlines)
        var hexagramContent = ""
        var questionContent = ""
        var guidanceContent = ""
        var currentSection = "hexagram" // 默认开始是卦象解析
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // 检查是否是问题解读的开始
            if trimmedLine.contains("问题解读") || trimmedLine.contains("问题分析") || trimmedLine.contains("你的问题") || trimmedLine.contains("问题含义") {
                currentSection = "question"
                continue
            }
            // 检查是否是建议指导的开始
            else if trimmedLine.contains("建议指导") || trimmedLine.contains("指导建议") || trimmedLine.contains("建议") || trimmedLine.contains("指导") {
                currentSection = "guidance"
                continue
            }
            // 检查是否是卦象解析的开始
            else if trimmedLine.contains("卦象解析") || trimmedLine.contains("卦象含义") || trimmedLine.contains("核心含义") {
                currentSection = "hexagram"
                continue
            }
            
            // 根据当前部分添加内容
            if currentSection == "hexagram" && !trimmedLine.isEmpty {
                if !hexagramContent.isEmpty {
                    hexagramContent += "\n"
                }
                hexagramContent += trimmedLine
            } else if currentSection == "question" && !trimmedLine.isEmpty {
                if !questionContent.isEmpty {
                    questionContent += "\n"
                }
                questionContent += trimmedLine
            } else if currentSection == "guidance" && !trimmedLine.isEmpty {
                if !guidanceContent.isEmpty {
                    guidanceContent += "\n"
                }
                guidanceContent += trimmedLine
            }
        }
        
        // 如果没有找到明确的分割，按长度分割成三部分
        if hexagramContent.isEmpty && questionContent.isEmpty && guidanceContent.isEmpty {
            let totalLength = interpretation.count
            let firstThird = totalLength / 3
            let secondThird = firstThird * 2
            
            hexagramContent = String(interpretation.prefix(firstThird))
            questionContent = String(interpretation.dropFirst(firstThird).prefix(firstThird))
            guidanceContent = String(interpretation.suffix(totalLength - secondThird))
        }
        
        // 更新状态
        DispatchQueue.main.async {
            self.hexagramAnalysis = hexagramContent.isEmpty ? "暂无卦象解析" : hexagramContent
            self.questionInterpretation = questionContent.isEmpty ? "暂无问题解读" : questionContent
            self.guidanceAdvice = guidanceContent.isEmpty ? "暂无建议指导" : guidanceContent
        }
    }
    
    private func startNetworkMonitoring() {
        let queue = DispatchQueue(label: "NetworkMonitor")
        networkMonitor.start(queue: queue)
        
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isNetworkAvailable = path.status == .satisfied
                print("[DivinationResultPageView] 网络状态: \(path.status == .satisfied ? "可用" : "不可用")")
            }
        }
    }
    
    private func stopNetworkMonitoring() {
          networkMonitor.cancel()
      }
}

#Preview {
    NavigationStack {
        let hexagramInfo = HexagramData.getHexagram(for: [true, false, true, false, true, false].map { $0 ? "1" : "0" }.joined())
        DivinationResultPageView(
            question: "我的事业发展如何？",
            tossResults: [true, false, true, false, true, false],
            hexagramData: (name: hexagramInfo.name, description: hexagramInfo.description),
            currentLocation: "北京市",
            onDismiss: {}
        )
    }
}