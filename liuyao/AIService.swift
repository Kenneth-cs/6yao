import Foundation

class AIService: ObservableObject {
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
        
        let requestBody: [String: Any] = [
            "model": "doubao-seed-1-6-thinking-250715",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 2000,
            "temperature": 0.7
        ]
        
        do {
            let response = try await NetworkService.shared.sendRequest(
                body: requestBody,
                responseType: AIResponse.self
            )
            
            if let content = response.choices.first?.message.content {
                let parsed = parseAIResponse(content)
                return DivinationResult(
                    question: question,
                    tossResults: tossResults,
                    hexagramName: hexagramInfo.name,
                    hexagramDescription: hexagramInfo.description,
                    aiInterpretation: parsed.interpretation,
                    advice: parsed.advice,
                    timestamp: Date(),
                    divinationTime: divinationTime,
                    divinationLocation: divinationLocation
                )
            } else {
                throw AIServiceError.noResponse
            }
        } catch {
            throw AIServiceError.requestFailed(error)
        }
    }
    
    func interpretDivinationStream(
        question: String,
        tossResults: [Bool],
        divinationTime: Date,
        divinationLocation: String,
        onUpdate: @escaping (String) -> Void
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
        
        let requestBody: [String: Any] = [
            "model": "doubao-seed-1-6-thinking-250715",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 2000,
            "temperature": 0.7
        ]
        
        do {
            let response = try await NetworkService.shared.sendRequest(
                body: requestBody,
                responseType: AIResponse.self
            )
            
            if let content = response.choices.first?.message.content {
                let parsed = parseAIResponse(content)
                onUpdate(parsed.interpretation)
                
                return DivinationResult(
                    question: question,
                    tossResults: tossResults,
                    hexagramName: hexagramInfo.name,
                    hexagramDescription: hexagramInfo.description,
                    aiInterpretation: parsed.interpretation,
                    advice: parsed.advice,
                    timestamp: Date(),
                    divinationTime: divinationTime,
                    divinationLocation: divinationLocation
                )
            } else {
                throw AIServiceError.noResponse
            }
        } catch {
            throw AIServiceError.requestFailed(error)
        }
    }
    
    // 添加新的流式解读方法，接受HexagramData参数
    func interpretDivinationStream(
        question: String,
        hexagram: HexagramData,
        tossResults: [Bool]
    ) async throws -> String {
        
        let hexagramYinYang = tossResults.map { $0 ? "阳" : "阴" }.joined(separator: "-")
        
        // 构建AI提示词
        let prompt = buildPrompt(
            question: question,
            hexagramName: hexagram.name,
            hexagramDescription: hexagram.description,
            hexagramYinYang: hexagramYinYang,
            tossResults: tossResults,
            divinationTime: Date(),
            divinationLocation: "未知"
        )
        
        let requestBody: [String: Any] = [
            "model": "doubao-seed-1-6-thinking-250715",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 2000,
            "temperature": 0.7
        ]
        
        do {
            print("[AIService] 开始发送AI请求...")
            print("[AIService] 请求体大小: \(requestBody.description.count) 字符")
            
            let response = try await NetworkService.shared.sendRequest(
                body: requestBody,
                responseType: AIResponse.self
            )
            
            print("[AIService] 收到AI响应")
            
            if let content = response.choices.first?.message.content {
                print("[AIService] AI响应内容长度: \(content.count) 字符")
                return content
            } else {
                print("[AIService] 错误: AI响应为空")
                throw AIServiceError.noResponse
            }
        } catch {
            print("[AIService] 请求失败: \(error.localizedDescription)")
            if let networkError = error as? NetworkError {
                print("[AIService] 网络错误详情: \(networkError.localizedDescription)")
            }
            throw AIServiceError.requestFailed(error)
        }
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        let timeString = formatter.string(from: divinationTime)
        
        let hour = Calendar.current.component(.hour, from: divinationTime)
        let chineseHour = getChineseHour(from: hour)
        
        return """
        作为一位资深的六爻占卜师，请为以下问题进行详细解读：
        
        问题：\(question)
        
        卦象信息：
        - 卦名：\(hexagramName)
        - 卦象描述：\(hexagramDescription)
        - 爻位组合：\(hexagramYinYang)
        - 占卜时间：\(timeString)（\(chineseHour)）
        - 占卜地点：\(divinationLocation)
        
        请按以下格式提供解读：
        
        【卦象解析】
        [详细分析卦象的含义和象征]
        
        【问题解读】
        [针对具体问题的分析和解答]
        
        【建议指导】
        [给出具体的行动建议和注意事项]
        
        请用专业而通俗易懂的语言进行解读，既要体现六爻占卜的传统智慧，又要贴近现代人的理解方式。
        """
    }
    
    private func parseAIResponse(_ content: String) -> (interpretation: String, advice: String) {
        let lines = content.components(separatedBy: .newlines)
        var interpretation = ""
        var advice = ""
        var currentSection = ""
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            
            if trimmedLine.contains("【卦象解析】") || trimmedLine.contains("【问题解读】") {
                currentSection = "interpretation"
            } else if trimmedLine.contains("【建议指导】") {
                currentSection = "advice"
            } else if !trimmedLine.isEmpty && !trimmedLine.hasPrefix("【") {
                if currentSection == "interpretation" {
                    interpretation += trimmedLine + "\n"
                } else if currentSection == "advice" {
                    advice += trimmedLine + "\n"
                }
            }
        }
        
        // 如果解析失败，使用原始内容
        if interpretation.isEmpty {
            interpretation = content
        }
        if advice.isEmpty {
            advice = "请根据卦象指引，谨慎行事，顺应天时。"
        }
        
        return (interpretation.trimmingCharacters(in: .whitespacesAndNewlines),
                advice.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    private func getChineseHour(from hour: Int) -> String {
        let hours = ["子时", "丑时", "寅时", "卯时", "辰时", "巳时",
                    "午时", "未时", "申时", "酉时", "戌时", "亥时"]
        let index = (hour + 1) / 2 % 12
        return hours[index]
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