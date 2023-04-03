//
//  ContentView.swift
//  ChartTutorials
//
//  Created by sglee237 on 2023/04/03.
//

import SwiftUI
import Charts
// 밑에서 쭉 설명할 Marks에 대해서도 동일한 Postings 데이터 적용
struct Posting: Identifiable {
  let name: String
  let count: Int
  
  var id: String { name }
}

let postings: [Posting] = [
  .init(name: "Green", count: 250),
  .init(name: "James", count: 100),
  .init(name: "Tony", count: 70)
]

// 차트 그리기
struct BarChartView: View {
  var body: some View {
    Chart {
      ForEach(postings) { posting in
        BarMark(
          x: .value("Name", posting.name),
          y: .value("Posting", posting.count)
        )
      }
    }
  }
}

struct PointChartView: View {
  var body: some View {
    Chart {
      ForEach(postings) { posting in
        PointMark(
          x: .value("Posting", posting.count),
          y: .value("Name", posting.name)
        )
      }
    }
  }
}

struct AreaChartView: View {
  var body: some View {
    Chart {
      ForEach(postings) { posting in
        AreaMark(
          x: .value("Name", posting.name),
          y: .value("Posting", posting.count)
        )
      }
    }
  }
}

struct RuleMarkChartView: View {
  var body: some View {
    Chart {
      ForEach(postings) { posting in
        RuleMark(
          xStart: .value("Posting", posting.count),
          xEnd: .value("Posting", posting.count + 20),
          y: .value("Name", posting.name)
        )
      }
    }
  }
}

struct RectangleMarkChartView: View {
  var body: some View {
    Chart {
      ForEach(postings) { posting in
        RectangleMark(
          x: .value("Name", posting.name),
          y: .value("Posting", posting.count)
        )
      }
    }
  }
}

struct ChartExample: View {
    var body: some View {
        HStack {
            VStack {
                BarChartView()
                PointChartView()
                RectangleMarkChartView()
            }
            VStack {
                AreaChartView()
                RuleMarkChartView()
            }
        }
        
            .navigationTitle("차트 활용")
    }
}

enum StepsDateInterval: String, CaseIterable {
    case daily
    case weekly
    case monthly
    case yearHalf
    case yearly
    
    var calendarComponent: Calendar.Component {
        switch self {
            
        case .daily: return   .hour
        case .weekly: return  .day
        case .monthly: return .weekday
        case .yearHalf: return .month
        case .yearly: return .month
        }
        
    }
    
    var interval: Int {
        switch self {
            
        case .daily:
            return 1
        case .weekly:
            return 7
        case .monthly:
            return 30
        case .yearHalf:
            return 180
        case .yearly:
            return 360
        }
    }
}

struct ContentView: View {
    @State private var selection:StepsDateInterval = .daily
    @State private var refreshingID = UUID()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateAt, order: .reverse)]) var stepList: FetchedResults<Step>
    @State private var isShow = false
    
    func totalStepCount() -> String {
        var count = 0
        for steps in stepList {
            count += Int(steps.steps)
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: count) ?? ""
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selection) {
                    ForEach(StepsDateInterval.allCases, id: \.self) { stepsInterval in
                        Text(stepsInterval.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                
                VStack(alignment: .leading) {
                    Text("총")
                    HStack{
                        Text(totalStepCount())
                            .font(.largeTitle)
                            .foregroundColor(.black)
                        Text("걸음")
                    }
                    Text("오늘")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
                
                Chart {
                    if isShow {
                        ForEach(stepList) { step in
                            BarMark(
                                x: .value("날짜", step.dateAt!, unit: selection.calendarComponent),
                                y: .value("걸음 수", step.steps)
                            )
                            
//                            .annotation(position: .automatic, alignment: .leading) {
//                            .annotation(position: .automatic) {
//                                Text("\(step.steps)")
//                            }
                        }

                    }
                }
                .id(refreshingID)
                
                
                
                Spacer()
                
                Button("데이터 생성") {
                    DataController.shared.makeExampleData()
                }
                .frame(maxWidth: .infinity)
                
            }
            .onAppear {
                var dateComponent = DateComponents()
                dateComponent.day = -selection.interval
                
                if let startDate = Calendar.current.date(byAdding: dateComponent, to: Date()),
                   let startAt = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: startDate) {
                    
                   
//                   let endAt = Calendar.current.date(bySettingHour: 22, minute: 59, second: 59, of: Date()) {
                    stepList.nsPredicate = NSPredicate(format: "dateAt > %@", startAt as NSDate)
                                                       
                    isShow = true
                    refreshingID = UUID()
                }
                
//                stepList.nsPredicate = NSPredicate
            }
            
            .onChange(of: selection, perform: { newValue in
                var dateComponent = DateComponents()
                dateComponent.day = -selection.interval
                
                if let startDate = Calendar.current.date(byAdding: dateComponent, to: Date()),
                   let startAt = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: startDate) {
                    
                   
//                   let endAt = Calendar.current.date(bySettingHour: 22, minute: 59, second: 59, of: Date()) {
                    stepList.nsPredicate = NSPredicate(format: "dateAt > %@", startAt as NSDate)
                                                       
                    isShow = true
                    refreshingID = UUID()
                }
            })
            .padding()
            .navigationTitle("걸음")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
