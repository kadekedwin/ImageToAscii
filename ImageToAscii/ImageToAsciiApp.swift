//
//  ImageToAsciiApp.swift
//  ImageToAscii
//
//  Created by Kadek Edwin on 20/11/23.
//

import SwiftUI

@main
struct ImageToAsciiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
