//
//  ChartTutorialsApp.swift
//  ChartTutorials
//
//  Created by sglee237 on 2023/04/03.
//

import SwiftUI

@main
struct ChartTutorialsApp: App {
    @StateObject private var controller = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, controller.container.viewContext)
        }
    }
}
