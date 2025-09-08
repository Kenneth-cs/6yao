import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    // 请确认您的API密钥是否正确
    private let apiKey = "9e404d1b-7d3a-420f-9a39-34ceb2dd71d6"
    // 移除URL末尾可能的逗号或空格
    private let baseURL = "https://ark.cn-beijing.volces.com/api/v3/chat/completions"
    
    func sendRequest<T: Codable>(
        body: [String: Any],
        responseType: T.Type
    ) async throws -> T {
        // 确保URL格式正确
        guard let url = URL(string: baseURL.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // 增加超时时间到180秒
        request.timeoutInterval = 180.0
        
        // 添加调试输出
        print("API Request URL: \(baseURL)")
        print("API Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            if let bodyString = String(data: request.httpBody!, encoding: .utf8) {
                print("API Request Body: \(bodyString)")
            }
        } catch {
            print("JSON编码失败: \(error)")
            throw NetworkError.encodingError
        }
        
        do {
            print("开始发送网络请求...")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // 打印响应信息
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP状态码: \(httpResponse.statusCode)")
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("API响应: \(responseString)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            print("网络请求失败: \(error)")
            throw NetworkError.networkError(error)
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case encodingError
    case invalidResponse
    case serverError(Int)
    case networkError(Error)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的URL"
        case .encodingError:
            return "数据编码失败"
        case .invalidResponse:
            return "无效的响应"
        case .serverError(let code):
            return "服务器错误: \(code)"
        case .networkError(let error):
            return "网络错误: \(error.localizedDescription)"
        case .decodingError:
            return "数据解析失败"
        }
    }
}