import SwiftUI

// 学习页面视图
struct LearningPageView: View {
    @State private var selectedCategory: LearningCategory? = nil
    @State private var selectedContent: LearningContent? = nil
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // 搜索栏
            SearchBar(text: $searchText)
                .padding(.horizontal)
                .padding(.top)
            
            // 内容区域
            if selectedCategory == nil {
                // 分类选择视图
                CategorySelectionView(selectedCategory: $selectedCategory)
            } else {
                // 内容列表视图
                ContentListView(
                    category: selectedCategory!,
                    searchText: searchText,
                    selectedContent: $selectedContent,
                    onBack: { selectedCategory = nil }
                )
            }
        }
        .navigationTitle("学习中心")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedContent) { content in
            LearningDetailView(content: content)
        }
    }
}

#Preview {
    NavigationStack {
        LearningPageView()
    }
}