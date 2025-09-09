struct Message: Codable {
    let role: String
    let content: String  // 这里是非可选类型
}