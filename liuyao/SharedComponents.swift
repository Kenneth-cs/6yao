import SwiftUI
import Foundation

// 格式化文本段落结构
struct FormattedTextSegment {
    let text: String
    let isTitle: Bool
    let isBullet: Bool
    let isNormal: Bool
    
    init(text: String, isTitle: Bool = false, isBullet: Bool = false, isNormal: Bool = false) {
        self.text = text
        self.isTitle = isTitle
        self.isBullet = isBullet
        self.isNormal = isNormal
    }
}

// 格式化文本视图
struct FormattedTextView: View {
    let segments: [FormattedTextSegment]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(segments.enumerated()), id: \.offset) { index, segment in
                HStack(alignment: .top) {
                    if segment.isTitle {
                        Text(segment.text)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    } else if segment.isBullet {
                        Text(segment.text)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, 12)
                    } else {
                        Text(segment.text)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                }
                .padding(.vertical, segment.isTitle ? 4 : 2)
            }
        }
    }
}

// 格式化AI解读文本函数
func formatAIText(_ text: String) -> [FormattedTextSegment] {
    var segments: [FormattedTextSegment] = []
    let lines = text.components(separatedBy: "\n")
    
    for line in lines {
        let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedLine.isEmpty { continue }
        
        // 检测标题行（包含：的行）
        if trimmedLine.contains("：") {
            segments.append(FormattedTextSegment(text: trimmedLine, isTitle: true))
        }
        // 检测要点行（以-开头的行）
        else if trimmedLine.hasPrefix("-") {
            let bulletText = trimmedLine.replacingOccurrences(of: "-", with: "•")
            segments.append(FormattedTextSegment(text: bulletText, isBullet: true))
        }
        // 普通段落
        else {
            segments.append(FormattedTextSegment(text: trimmedLine, isNormal: true))
        }
    }
    
    return segments
}
