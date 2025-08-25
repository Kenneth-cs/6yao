import Foundation

class AIService {
    static let shared = AIService()
    private init() {}
    
    func interpretDivination(
        question: String,
        tossResults: [Bool]
    ) async throws -> DivinationResult {
        
        // 获取卦象信息
        let hexagramBinary = tossResults.map { $0 ? "1" : "0" }.joined()
        let hexagramInfo = HexagramData.getHexagram(for: hexagramBinary)
        let hexagramYinYang = tossResults.map { $0 ? "阳" : "阴" }.joined(separator: "-")
        
        // 构建AI提示词
        let prompt = buildPrompt(
            question: question,
            hexagramName: hexagramInfo.name,
            hexagramDescription: hexagramInfo.description,
            hexagramYinYang: hexagramYinYang,
            tossResults: tossResults
        )
        
        // 修正API请求体格式
        let requestBody: [String: Any] = [
            "model": "doubao-seed-1-6-thinking-250715",
            "messages": [
                [
                    "role": "user",
                    "content": prompt  // 直接使用字符串，不需要数组格式
                ]
            ],
            "max_tokens": 1000,
            "temperature": 0.7
        ]
        
        do {
            // 发送API请求
            let response = try await NetworkService.shared.sendRequest(
                body: requestBody,
                responseType: AIResponse.self
            )
            
            // 解析AI响应
            guard let aiContent = response.choices.first?.message.content else {
                throw AIServiceError.noResponse
            }
            
            // 解析AI回复内容
            let parsedResult = parseAIResponse(aiContent)
            
            return DivinationResult(
                question: question,
                tossResults: tossResults,
                hexagramName: hexagramInfo.name,
                hexagramDescription: hexagramInfo.description,
                aiInterpretation: parsedResult.interpretation,
                advice: parsedResult.advice,
                timestamp: Date()
            )
            
        } catch {
            throw AIServiceError.requestFailed(error)
        }
    }
    
    private func buildPrompt(
        question: String,
        hexagramName: String,
        hexagramDescription: String,
        hexagramYinYang: String,
        tossResults: [Bool]
    ) -> String {
        let yaoDetails = tossResults.enumerated().map { index, isYang in
            "第\(index + 1)爻：\(isYang ? "阳爻" : "阴爻")"
        }.joined(separator: "，")
        
        return """
        你是一位精通六爻占卜的大师，请根据以下信息为用户提供专业的卦象解读：
        
        【用户问题】：\(question)
        
        【卦象信息】：
        - 卦名：\(hexagramName)
        - 卦象描述：\(hexagramDescription)
        - 爻象组合：\(hexagramYinYang)
        - 六爻详情：\(yaoDetails)
        
        请按照以下格式提供解读，注意使用清晰的分段和要点：
        
        【卦象分析】：
        整体运势：（简要概述当前情况）
        
        核心含义：（解释卦象的主要寓意）
        
        具体分析：
        - 要点一：（具体分析某个方面）
        - 要点二：（具体分析另一个方面）
        - 要点三：（如有需要，继续分析）
        
        【建议指导】：
        行动建议：（给出具体的行动指导）
        
        注意事项：
        - 注意点一：（具体的注意事项）
        - 注意点二：（另一个注意事项）
        
        时机把握：（关于时机的建议）
        
        请用温和、智慧的语调回答，内容要有深度但易于理解，多使用分段和要点来提高可读性。
        """
    }
    
    private func parseAIResponse(_ content: String) -> (interpretation: String, advice: String) {
        let lines = content.components(separatedBy: "\n")
        var interpretation = ""
        var advice = ""
        var currentSection = ""
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmedLine.contains("【卦象分析】") {
                currentSection = "interpretation"
                continue
            } else if trimmedLine.contains("【建议指导】") {
                currentSection = "advice"
                continue
            }
            
            if !trimmedLine.isEmpty {
                switch currentSection {
                case "interpretation":
                    interpretation += trimmedLine + "\n"
                case "advice":
                    advice += trimmedLine + "\n"
                default:
                    break
                }
            }
        }
        
        // 如果解析失败，使用整个内容
        if interpretation.isEmpty && advice.isEmpty {
            let parts = content.components(separatedBy: "【建议指导】")
            if parts.count >= 2 {
                interpretation = parts[0].replacingOccurrences(of: "【卦象分析】", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                advice = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                interpretation = content
                advice = "请根据卦象分析，谨慎行事，顺应天时。"
            }
        }
        
        return (
            interpretation: interpretation.trimmingCharacters(in: .whitespacesAndNewlines),
            advice: advice.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
}

enum AIServiceError: Error, LocalizedError {
    case noResponse
    case requestFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .noResponse:
            return "AI未返回有效响应"
        case .requestFailed(let error):
            return "请求失败: \(error.localizedDescription)"
        }
    }
}