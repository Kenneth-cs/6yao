import SwiftUI
import Foundation
import CoreLocation

struct DivinationPageView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var question = ""
    @State private var divinationStartTime: Date?
    let currentTime: Date
    let locationManager: LocationManager
    let defaultQuestion: String?
    
    init(currentTime: Date, locationManager: LocationManager, defaultQuestion: String? = nil) {
        self.currentTime = currentTime
        self.locationManager = locationManager
        self.defaultQuestion = defaultQuestion
    }
    
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
                NavigationLink(destination: CoinTossPageView(
                    question: question.isEmpty ? (defaultQuestion ?? "") : question,
                    currentTime: divinationStartTime ?? currentTime,
                    locationManager: locationManager
                )) {
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
                .disabled(question.isEmpty && defaultQuestion == nil)
                .opacity((question.isEmpty && defaultQuestion == nil) ? 0.6 : 1.0)
                .simultaneousGesture(TapGesture().onEnded {
                    divinationStartTime = Date()
                })
                
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
        .onAppear {
            if let defaultQ = defaultQuestion {
                question = defaultQ
            }
        }
    }
}