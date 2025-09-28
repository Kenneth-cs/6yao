//
//  liuyaoApp.swift
//  liuyao
//
//  Created by zhangshaocong6 on 2025/8/25.
//

import SwiftUI

@main
struct liuyaoApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
