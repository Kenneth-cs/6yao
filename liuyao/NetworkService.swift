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
        request.timeoutInterval = 30  // 设置合理的超时时间30秒
        request.cachePolicy = .reloadIgnoringLocalCacheData  // 忽略缓存
        
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
            print("[NetworkService] 发送请求到: \(url)")
            print("[NetworkService] 请求体大小: \(request.httpBody?.count ?? 0) 字节")
            if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
                print("[NetworkService] 请求体内容: \(bodyString.prefix(500))...")
            }
            
            let startTime = Date()
            let (data, response) = try await URLSession.shared.data(for: request)
            let duration = Date().timeIntervalSince(startTime)
            
            print("[NetworkService] 请求耗时: \(String(format: "%.2f", duration))秒")
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("[NetworkService] 错误: 无效响应类型")
                throw NetworkError.invalidResponse
            }
            
            print("[NetworkService] 响应状态码: \(httpResponse.statusCode)")
            print("[NetworkService] 响应数据大小: \(data.count) 字节")
            
            if data.count < 1000 {
                print("[NetworkService] 响应数据: \(String(data: data, encoding: .utf8) ?? "无法解析")")
            } else {
                print("[NetworkService] 响应数据(前500字符): \(String(data: data, encoding: .utf8)?.prefix(500) ?? "无法解析")...")
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                print("[NetworkService] HTTP错误: \(httpResponse.statusCode)")
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            print("[NetworkService] JSON解析成功")
            return decodedResponse
        } catch {
            print("[NetworkService] 网络请求失败: \(error)")
            if let urlError = error as? URLError {
                print("[NetworkService] URLError详情: code=\(urlError.code.rawValue), description=\(urlError.localizedDescription)")
            }
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