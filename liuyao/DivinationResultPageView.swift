import SwiftUI
import Network

struct DivinationResultPageView: View {
    let question: String
    let tossResults: [Bool]
    let hexagramData: (name: String, description: String)
    @State private var aiInterpretation: String = ""
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
                    // 完成按钮
                    HStack {
                        Spacer()
                        Button(action: {
                            // 回到首页 - 通过dismiss回到根视图
                            dismiss()
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
                                
                                Text("北京市")
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
                
                // AI解读区域
                if isLoading {
                    VStack(spacing: 16) {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(.purple)
                            Text("AI正在解读卦象...")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("预计需要10-30秒")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button("取消解读") {
                            // 取消解读逻辑
                        }
                        .font(.subheadline)
                        .foregroundColor(.orange)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                    .background(Color(.systemBackground))
                } else {
                    VStack(spacing: 0) {
                        // AI解读结果 - 简化显示
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.blue)
                                    .font(.title3)
                                Text("AI解读")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                            
                            Text(aiInterpretation)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineSpacing(4)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue.opacity(0.05), .cyan.opacity(0.03)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    }
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
                                dismiss()
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
                print("[DivinationResultPageView] 调用AIService.interpretDivinationStream")
                let hexagramStruct = HexagramData(name: hexagramData.name, description: hexagramData.description)
                
                let interpretation = try await aiService.interpretDivinationStream(
                    question: question,
                    hexagram: hexagramStruct,
                    tossResults: tossResults
                )
                
                print("[DivinationResultPageView] AI解读完成，长度: \(interpretation.count)")
                
                await MainActor.run {
                    self.aiInterpretation = interpretation
                    self.isLoading = false
                    print("[DivinationResultPageView] UI更新完成")
                }
            } catch {
                print("[DivinationResultPageView] AI解读失败: \(error.localizedDescription)")
                await MainActor.run {
                    self.aiInterpretation = "解读失败，请稍后重试。错误信息：\(error.localizedDescription)"
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
            hexagramData: (name: hexagramInfo.name, description: hexagramInfo.description)
        )
    }
}