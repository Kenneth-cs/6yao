//
//  FeedbackRecord+CoreDataProperties.swift
//  
//
//  Created by zhangshaocong6 on 2025/9/28.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension FeedbackRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedbackRecord> {
        return NSFetchRequest<FeedbackRecord>(entityName: "FeedbackRecord")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var feedback: String?
    @NSManaged public var id: UUID?
    @NSManaged public var rating: Int16
    @NSManaged public var divination: DivinationRecord?

}

extension FeedbackRecord : Identifiable {

}
