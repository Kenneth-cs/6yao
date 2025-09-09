// ... existing code ...
if tossResults.count >= 6 && !isAnimating {
    NavigationLink(destination: DivinationResultPageView(
        question: question,
        tossResults: tossResults,
        hexagramData: Optional(HexagramData.getHexagram(for: tossResults.map { $0 ? "1" : "0" }.joined()))
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
}
// ... existing code ...