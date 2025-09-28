import SwiftUI

struct AccuracyFeedbackView: View {
    let divinationId: UUID
    let existingRating: Int?
    let existingFeedback: String?
    
    @State private var rating: Int = 0
    @State private var feedback: String = ""
    @State private var showThankYou = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    private var dataService: DataService {
        DataService(context: viewContext)
    }
    
    private var isEditing: Bool {
        existingRating != nil
    }
    
    init(divinationId: UUID, existingRating: Int? = nil, existingFeedback: String? = nil) {
        self.divinationId = divinationId
        self.existingRating = existingRating
        self.existingFeedback = existingFeedback
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // 标题区域
                VStack(spacing: 12) {
                    Image(systemName: isEditing ? "star.circle" : "star.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text(isEditing ? "修改反馈" : "准确度反馈")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(isEditing ? "修改您之前的反馈内容" : "您的反馈有助于我们改进解卦质量")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // 星级评分
                VStack(spacing: 16) {
                    Text("请为本次解卦的准确度打分")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 12) {
                        ForEach(1...5, id: \.self) { star in
                            Button(action: {
                                rating = star
                            }) {
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .font(.title)
                                    .foregroundColor(star <= rating ? .orange : .gray.opacity(0.4))
                                    .scaleEffect(star <= rating ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: rating)
                            }
                        }
                    }
                    
                    // 评分说明
                    if rating > 0 {
                        Text(getRatingDescription(rating))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .transition(.opacity)
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.orange.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                        )
                )
                
                // 文字反馈
                VStack(alignment: .leading, spacing: 12) {
                    Text("详细反馈（可选）")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextEditor(text: $feedback)
                        .frame(minHeight: 100)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .overlay(
                            // 占位符文本
                            VStack {
                                HStack {
                                    if feedback.isEmpty {
                                        Text("请分享您的想法，比如哪些方面比较准确，哪些需要改进...")
                                            .foregroundColor(.secondary.opacity(0.6))
                                            .font(.body)
                                            .padding(.top, 20)
                                            .padding(.leading, 16)
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }
                        )
                }
                
                Spacer()
                
                // 提交按钮
                VStack(spacing: 12) {
                    Button(action: submitFeedback) {
                        HStack {
                            Image(systemName: isEditing ? "checkmark.circle.fill" : "paperplane.fill")
                                .font(.body)
                            Text(isEditing ? "更新反馈" : "提交反馈")
                                .font(.body)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: rating > 0 ? [.orange, .red] : [.gray, .gray]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .disabled(rating == 0)
                    .opacity(rating > 0 ? 1.0 : 0.6)
                    
                    Button("跳过") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.body)
                    .foregroundColor(.secondary)
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
            .navigationTitle("反馈")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
        .alert(isEditing ? "反馈已更新！" : "感谢您的反馈！", isPresented: $showThankYou) {
            Button("确定") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text(isEditing ? "您的反馈已成功更新。" : "您的反馈对我们很重要，将帮助我们提供更准确的解卦服务。")
        }
        .onAppear {
            // 预填充现有数据
            if let existingRating = existingRating {
                rating = existingRating
            }
            if let existingFeedback = existingFeedback {
                feedback = existingFeedback
            }
        }
    }
    
    private func getRatingDescription(_ rating: Int) -> String {
        switch rating {
        case 1:
            return "不太准确，需要改进"
        case 2:
            return "有些偏差，部分准确"
        case 3:
            return "一般准确，还可以"
        case 4:
            return "比较准确，很满意"
        case 5:
            return "非常准确，超出期望"
        default:
            return ""
        }
    }
    
    private func submitFeedback() {
        // 保存反馈到Core Data
        dataService.saveFeedback(
            for: divinationId,
            rating: rating,
            feedback: feedback.isEmpty ? nil : feedback
        )
        
        showThankYou = true
        
        // 延迟关闭
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - 反馈按钮组件
struct FeedbackButton: View {
    let divinationId: UUID
    @State private var showFeedbackView = false
    
    var body: some View {
        Button(action: {
            showFeedbackView = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "star.bubble")
                    .font(.body)
                Text("评价准确度")
                    .font(.body)
                    .fontWeight(.medium)
            }
            .foregroundColor(.orange)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.orange, .red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 1
                    )
            )
        }
        .sheet(isPresented: $showFeedbackView) {
            AccuracyFeedbackView(divinationId: divinationId)
        }
    }
}

#Preview {
    AccuracyFeedbackView(divinationId: UUID())
}