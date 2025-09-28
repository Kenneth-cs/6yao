//
//  DivinationRecord+CoreDataProperties.swift
//  
//
//  Created by zhangshaocong6 on 2025/9/28.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension DivinationRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DivinationRecord> {
        return NSFetchRequest<DivinationRecord>(entityName: "DivinationRecord")
    }

    @NSManaged public var advice: String?
    @NSManaged public var aiInterpretation: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var question: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var tossResultsData: Data?
    @NSManaged public var feedback: FeedbackRecord?

}

extension DivinationRecord : Identifiable {

}
