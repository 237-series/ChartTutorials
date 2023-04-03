//
//  DataController.swift
//  ChartTutorials
//
//  Created by sglee237 on 2023/04/03.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "StepsModel")
    static let shared = DataController()
    
    private init() {
        container.loadPersistentStores { desc, err in
            if let error = err {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    
    func save() {
        let context = self.container.viewContext
        do {
            try context.save()
            print("Data Saved!!")
        } catch {
            print("We could not save the data...")
        }
    }
    
    func addSteps(dateAt: Date, steps: Int) {
        let step = Step(context: self.container.viewContext)
        
        step.id = UUID()
        step.dateAt = dateAt
        step.steps = Int32(steps)
        
        save()
    }
    
    
    func makeExampleData() {
        let interval_days = 360
        var dateComponent = DateComponents()
        dateComponent.day = -interval_days
        
        if let startDate = Calendar.current.date(byAdding: dateComponent, to: Date()) {
            
            for i in 0..<interval_days {
                dateComponent.day = i
                if let date = Calendar.current.date(byAdding: dateComponent, to: startDate) {
                    dateComponent.minute = 0
                    dateComponent.second = 0
                    dateComponent.timeZone = .current
                    
                    for h in 8..<22 {
                        dateComponent.hour = h
                        
                        if let hourDate = Calendar.current.date(bySettingHour: h, minute: 0, second: 0, of: date) {
//                            print(hourDate)
                            let step = Int.random(in: 50...500)
                            addSteps(dateAt: hourDate, steps: step)
                        }
                    }
                    
                }
            }
        }
//        print(startDate)
        
    }
    
}
