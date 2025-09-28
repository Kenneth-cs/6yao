import Foundation
import CoreData
import SwiftUI

// MARK: - Core Data Stack
class PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // 添加一些预览数据
        let sampleRecord = DivinationRecord(context: viewContext)
        sampleRecord.id = UUID()
        sampleRecord.question = "我和他之间还有未来吗？"
        sampleRecord.tossResults = [true, false, true, false, true, false]
        sampleRecord.aiInterpretation = "根据卦象显示..."
        sampleRecord.advice = "建议您..."
        sampleRecord.createdAt = Date()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DivinationModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

// MARK: - Core Data Entity Extensions
extension DivinationRecord {
    // 删除所有 @NSManaged 属性声明和 fetchRequest 方法
    // 因为 Codegen = Class Definition 会自动生成这些
    
    // 便利属性
    var tossResults: [Bool] {
        get {
            guard let data = tossResultsData else { return [] }
            return (try? JSONDecoder().decode([Bool].self, from: data)) ?? []
        }
        set {
            tossResultsData = try? JSONEncoder().encode(newValue)
        }
    }
    
    var formattedDate: String {
        guard let date = createdAt else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
    
    var hexagramDisplay: String {
        return tossResults.map { $0 ? "阳" : "阴" }.joined(separator: " ")
    }
    
    // 获取准确度评分
    var accuracyRating: Int {
        return Int(feedback?.rating ?? 0)
    }
    
    // 是否有反馈
    var hasFeedback: Bool {
        return feedback != nil
    }
}

// MARK: - FeedbackRecord Extensions
extension FeedbackRecord {
    var formattedDate: String {
        guard let date = createdAt else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
    
    var ratingStars: String {
        return String(repeating: "⭐", count: Int(rating))
    }
}

// 删除 Identifiable 扩展，因为自动生成的代码已经包含了

// MARK: - Data Service
class DataService: ObservableObject {
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
    }
    
    func saveDivinationRecord(
        question: String,
        tossResults: [Bool],
        aiInterpretation: String,
        advice: String
    ) {
        let record = DivinationRecord(context: viewContext)
        record.id = UUID()
        record.question = question
        record.tossResults = tossResults
        record.aiInterpretation = aiInterpretation
        record.advice = advice
        record.createdAt = Date()
        
        do {
            try viewContext.save()
            print("问卦记录保存成功")
        } catch {
            print("保存失败: \(error)")
        }
    }
    
    func saveFeedback(
        for divinationRecord: DivinationRecord,
        rating: Int,
        feedback: String?
    ) {
        let feedbackRecord = FeedbackRecord(context: viewContext)
        feedbackRecord.id = UUID()
        feedbackRecord.rating = Int16(rating)
        feedbackRecord.feedback = feedback
        feedbackRecord.createdAt = Date()
        feedbackRecord.divination = divinationRecord
        
        do {
            try viewContext.save()
            print("反馈保存成功")
        } catch {
            print("反馈保存失败: \(error)")
        }
    }
    
    func saveFeedback(
        for divinationId: UUID,
        rating: Int,
        feedback: String?
    ) {
        let request: NSFetchRequest<DivinationRecord> = DivinationRecord.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", divinationId as CVarArg)
        
        do {
            let records = try viewContext.fetch(request)
            if let record = records.first {
                saveFeedback(for: record, rating: rating, feedback: feedback)
            }
        } catch {
            print("查找问卦记录失败: \(error)")
        }
    }
    
    func fetchAllRecords() -> [DivinationRecord] {
        let request: NSFetchRequest<DivinationRecord> = DivinationRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DivinationRecord.createdAt, ascending: false)]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("获取记录失败: \(error)")
            return []
        }
    }
    
    func deleteRecord(_ record: DivinationRecord) {
        viewContext.delete(record)
        
        do {
            try viewContext.save()
            print("记录删除成功")
        } catch {
            print("删除失败: \(error)")
        }
    }
}