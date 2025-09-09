// 当前的错误代码
guard let choice = response.choices.first,
      let aiContent = choice.message.content else {  // 错误：content不是可选类型
    throw AIServiceError.noResponse
}