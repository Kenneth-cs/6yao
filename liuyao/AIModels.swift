import Foundation

// MARK: - AI API 响应模型
struct AIResponse: Codable {
    let choices: [Choice]
    let usage: Usage?
}

struct Choice: Codable {
    let message: Message
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
    }
}

struct Message: Codable {
    let role: String
    let content: String
}

struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - 卦象数据模型
struct DivinationResult {
    let question: String
    let tossResults: [Bool]
    let hexagramName: String
    let hexagramDescription: String
    let aiInterpretation: String
    let advice: String
    let timestamp: Date
    
    // 获取卦象的二进制表示
    var hexagramBinary: String {
        return tossResults.map { $0 ? "1" : "0" }.joined()
    }
    
    // 获取卦象的阴阳表示
    var hexagramYinYang: String {
        return tossResults.map { $0 ? "阳" : "阴" }.joined(separator: "-")
    }
}

// MARK: - 六十四卦数据
struct HexagramData {
    static let hexagrams: [String: (name: String, description: String)] = [
        "111111": ("乾", "乾为天，刚健中正，自强不息"),
        "000000": ("坤", "坤为地，厚德载物，包容万象"),
        "100010": ("屯", "水雷屯，万物始生，艰难创业"),
        "010001": ("蒙", "山水蒙，启蒙教育，求知若渴"),
        "111010": ("需", "水天需，等待时机，耐心坚持"),
        "010111": ("讼", "天水讼，争讼纠纷，谨慎处理"),
        "010000": ("师", "地水师，统帅军队，领导有方"),
        "000010": ("比", "水地比，亲密合作，团结一心"),
        // 可以继续添加其他卦象...
    ]
    
    static func getHexagram(for binary: String) -> (name: String, description: String) {
        return hexagrams[binary] ?? ("未知卦象", "此卦象暂未收录，请咨询专业人士")
    }
}