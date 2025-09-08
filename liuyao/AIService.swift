import Foundation

class AIService {
    static let shared = AIService()
    private init() {}
    
    func interpretDivination(
        question: String,
        tossResults: [Bool],
        divinationTime: Date,
        divinationLocation: String
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
            tossResults: tossResults,
            divinationTime: divinationTime,
            divinationLocation: divinationLocation
        )
        
        // 修正API请求体格式
        let requestBody: [String: Any] = [
            "model": "doubao-seed-1-6-thinking-250715",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 2000,  // 从1000增加到2000
            "temperature": 0.7
        ]
        
        do {
            // 发送API请求
            let response = try await NetworkService.shared.sendRequest(
                body: requestBody,
                responseType: AIResponse.self
            )
            
            // 解析AI响应
            guard let choice = response.choices.first else {
                throw AIServiceError.noResponse
            }
            
            let aiContent = choice.message.content
            
            // 检查是否被截断
            if choice.finishReason == "length" {
                print("警告：AI回答因长度限制被截断")
                // 可以在这里添加重试逻辑或提示用户
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
                timestamp: Date(),
                divinationTime: divinationTime,
                divinationLocation: divinationLocation
            )
            
        } catch {
            throw AIServiceError.requestFailed(error)
        }
    }
    
    // 将 interpretDivinationStream 移到类内部
    func interpretDivinationStream(
        question: String,
        tossResults: [Bool],
        divinationTime: Date,
        divinationLocation: String,
        onUpdate: @escaping (String) -> Void
    ) async throws -> DivinationResult {
        // 获取卦象信息
        let binaryString = tossResults.map { $0 ? "1" : "0" }.joined()
        let hexagramData = HexagramData.getHexagram(for: binaryString)
        let hexagramYinYang = tossResults.map { $0 ? "阳" : "阴" }.joined(separator: "")
        
        // 构建提示词 - 现在可以访问私有方法
        let prompt = buildPrompt(
            question: question,
            hexagramName: hexagramData.name,
            hexagramDescription: hexagramData.description,
            hexagramYinYang: hexagramYinYang,
            tossResults: tossResults,
            divinationTime: divinationTime,
            divinationLocation: divinationLocation
        )
        
        // 构建请求体
        let requestBody: [String: Any] = [
            "model": "doubao-seed-1-6-thinking-250715",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 2000,
            "temperature": 0.7,
            "stream": true
        ]
        
        // 实现流式数据处理
        var accumulatedContent = ""
        
        // 创建URL请求
        guard let url = URL(string: "https://ark.cn-beijing.volces.com/api/v3/chat/completions") else {
            throw AIServiceError.requestFailed(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer ep-20241230174654-8xqzr", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            throw AIServiceError.requestFailed(error)
        }
        
        // 使用URLSession处理流式响应
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AIServiceError.requestFailed(NSError(domain: "HTTP Error", code: (response as? HTTPURLResponse)?.statusCode ?? 0, userInfo: nil))
        }
        
        // 处理响应数据
        if let responseString = String(data: data, encoding: .utf8) {
            accumulatedContent = responseString
            onUpdate(responseString)
        }
        
        // 解析AI响应 - 现在可以访问私有方法
        let parsedResponse = parseAIResponse(accumulatedContent)
        
        // 返回DivinationResult
        return DivinationResult(
            question: question,
            tossResults: tossResults,
            hexagramName: hexagramData.name,
            hexagramDescription: hexagramData.description,
            aiInterpretation: parsedResponse.interpretation,
            advice: parsedResponse.advice,
            timestamp: Date(),
            divinationTime: divinationTime,
            divinationLocation: divinationLocation
        )
    }
    
    private func buildPrompt(
        question: String,
        hexagramName: String,
        hexagramDescription: String,
        hexagramYinYang: String,
        tossResults: [Bool],
        divinationTime: Date,
        divinationLocation: String
    ) -> String {
        let yaoDetails = tossResults.enumerated().map { index, isYang in
            "第\(index + 1)爻：\(isYang ? "阳爻" : "阴爻")"
        }.joined(separator: "，")
        
        // 格式化起卦时间
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        formatter.locale = Locale(identifier: "zh_CN")
        let timeString = formatter.string(from: divinationTime)
        
        return """
        你是一位精通六爻占卜的大师，请根据以下信息为用户提供专业的卦象解读（2025年为乙巳年（木蛇））：
        
        【用户问题】：\(question)
        
        【起卦信息】：
        - 起卦时间：\(timeString)
        - 起卦地点：\(divinationLocation)
        
        【卦象信息】：
        - 卦名：\(hexagramName)
        - 卦象描述：\(hexagramDescription)
        - 爻象组合：\(hexagramYinYang)
        - 六爻详情：\(yaoDetails)
        
        请按照以下格式提供解读，注意使用清晰的分段和要点：
        
        【卦象分析】：
        整体运势：（简要概述当前情况+起卦时间、地点因素的解读）
        
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
        
        请结合起卦的具体时间和地点，考虑时空因素对卦象的影响。用温和、智慧的语调回答，内容要有深度但易于理解，多使用分段和要点来提高可读性。
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

// 保留辅助函数在类外部
private func getChineseHour(from hour: Int) -> String {
    let chineseHours = [
        "子", "丑", "丑", "寅", "寅", "卯", "卯", "辰", "辰", "巳", "巳", "午",
        "午", "未", "未", "申", "申", "酉", "酉", "戌", "戌", "亥", "亥", "子"
    ]
    return chineseHours[min(hour, 23)]
}