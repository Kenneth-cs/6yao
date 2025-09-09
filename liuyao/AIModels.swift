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
    let divinationTime: Date  // 起卦时间
    let divinationLocation: String  // 起卦地点
    
    // 获取卦象的二进制表示
    var hexagramBinary: String {
        return tossResults.map { $0 ? "1" : "0" }.joined()
    }
    
    // 获取卦象的阴阳表示
    var hexagramYinYang: String {
        return tossResults.map { $0 ? "阳" : "阴" }.joined(separator: "-")
    }
    
    // 获取农历时间显示
    var lunarTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        let timeString = formatter.string(from: divinationTime)
        
        // 获取时辰
        let hour = Calendar.current.component(.hour, from: divinationTime)
        let chineseHour = getChineseHour(hour: hour)
        
        return "\(timeString) (\(chineseHour)时)"
    }
    
    // 获取中文时辰
    private func getChineseHour(hour: Int) -> String {
        let hours = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
        let index = (hour + 1) / 2 % 12
        return hours[index]
    }
}

// MARK: - 六十四卦数据
struct HexagramData {
    let name: String
    let description: String
    
    static let hexagrams: [String: (name: String, description: String)] = [
        "000000": ("坤", "坤为地，厚德载物，包容万象"),
        "000001": ("复", "地雷复，一阳来复，万象更新"),
        "000010": ("临", "地泽临，居高临下，教导有方"),
        "000011": ("泰", "地天泰，天地交泰，通达顺畅"),
        "000100": ("大壮", "雷天大壮，声势浩大，正大光明"),
        "000101": ("夬", "泽天夬，决断果敢，除恶务尽"),
        "000110": ("需", "水天需，等待时机，耐心坚持"),
        "000111": ("比", "水地比，亲密合作，团结一心"),
        "001000": ("震", "震为雷，震动奋起，惊而后得"),
        "001001": ("豫", "雷地豫，安乐和豫，顺势而为"),
        "001010": ("解", "雷水解，解除困难，雨过天晴"),
        "001011": ("恒", "雷风恒，持之以恒，坚持不懈"),
        "001100": ("升", "地风升，上升发展，循序渐进"),
        "001101": ("井", "水风井，井养不穷，德泽深远"),
        "001110": ("大过", "泽风大过，大过其度，谨慎行事"),
        "001111": ("随", "泽雷随，随时而动，顺应变化"),
        "010000": ("巽", "巽为风，柔顺渗透，循序渐进"),
        "010001": ("小畜", "风天小畜，小有积蓄，以小养大"),
        "010010": ("家人", "风火家人，家庭和睦，内外有别"),
        "010011": ("益", "风雷益，增益进步，损上益下"),
        "010100": ("无妄", "天雷无妄，纯真无妄，顺应自然"),
        "010101": ("噬嗑", "火雷噬嗑，咬合除障，刚柔并济"),
        "010110": ("颐", "山雷颐，颐养正道，自求口实"),
        "010111": ("蛊", "山风蛊，整治腐败，革故鼎新"),
        "011000": ("坎", "坎为水，险陷重重，智慧应对"),
        "011001": ("节", "水泽节，节制有度，适可而止"),
        "011010": ("屯", "水雷屯，万物始生，艰难创业"),
        "011011": ("既济", "水火既济，功德圆满，盛极必衰"),
        "011100": ("革", "泽火革，变革更新，除旧布新"),
        "011101": ("丰", "雷火丰，丰盛富足，功成名就"),
        "011110": ("明夷", "地火明夷，光明受伤，韬光养晦"),
        "011111": ("师", "地水师，统帅军队，领导有方"),
        "100000": ("离", "离为火，光明美丽，文明进步"),
        "100001": ("旅", "火山旅，行旅在外，小心谨慎"),
        "100010": ("鼎", "火风鼎，革故鼎新，改弦更张"),
        "100011": ("未济", "火水未济，事未完成，继续努力"),
        "100100": ("蒙", "山水蒙，启蒙教育，求知若渴"),
        "100101": ("涣", "风水涣，涣散离析，重新聚合"),
        "100110": ("讼", "天水讼，争讼纠纷，谨慎处理"),
        "100111": ("同人", "天火同人，志同道合，团结合作"),
        "101000": ("艮", "艮为山，止于至善，适时而止"),
        "101001": ("贲", "山火贲，文饰美化，外表光鲜"),
        "101010": ("大畜", "山天大畜，大有蓄积，厚德载物"),
        "101011": ("损", "山泽损，损己利人，减损求益"),
        "101100": ("睽", "火泽睽，背道而驰，求同存异"),
        "101101": ("履", "天泽履，如履薄冰，谨慎前行"),
        "101110": ("中孚", "风泽中孚，诚信为本，感化他人"),
        "101111": ("渐", "风山渐，循序渐进，平稳发展"),
        "110000": ("兑", "兑为泽，喜悦和谐，以德服人"),
        "110001": ("困", "泽水困，困顿艰难，坚守正道"),
        "110010": ("萃", "泽地萃，聚集荟萃，众志成城"),
        "110011": ("咸", "泽山咸，感应相通，心心相印"),
        "110100": ("蹇", "水山蹇，艰难险阻，知难而退"),
        "110101": ("谦", "地山谦，谦逊有礼，德高望重"),
        "110110": ("小过", "雷山小过，小有过失，谨小慎微"),
        "110111": ("归妹", "雷泽归妹，少女出嫁，顺应天时"),
        "111000": ("乾", "乾为天，刚健中正，自强不息"),
        "111001": ("姤", "天风姤，阴始生长，防微杜渐"),
        "111010": ("遁", "天山遁，退避三舍，明哲保身"),
        "111011": ("否", "天地否，闭塞不通，守正待时"),
        "111100": ("观", "风地观，观察形势，以德化人"),
        "111101": ("剥", "山地剥，剥落衰败，顺时而止"),
        "111110": ("晋", "火地晋，光明上进，受到重用"),
        "111111": ("大有", "火天大有，大有收获，盛极而衰")
    ]
    
    static func getHexagram(for binary: String) -> (name: String, description: String) {
        return hexagrams[binary] ?? ("未知卦象", "卦象信息未找到")
    }
    
    // 新增方法：根据布尔数组获取卦象数据
    static func getHexagram(for tossResults: [Bool]) -> HexagramData? {
        let binary = tossResults.map { $0 ? "1" : "0" }.joined()
        let hexagram = getHexagram(for: binary)
        return HexagramData(name: hexagram.name, description: hexagram.description)
    }
}