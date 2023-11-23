//
//  ChartView.swift
//  Health
//
//  Created by Vincenzo Eboli on 20/11/23.
//
import UIKit
import Foundation
import SwiftUI
import Charts
struct DailyStepView:Identifiable{
    let id=UUID()
    let date:Date
    let stepCount:Double
}

enum ChartOptions{
    case oneWeek
    case oneMonth
    case oneYear
}
struct ChartView:View {
    @State var selectedCharter :ChartOptions = .oneWeek
    @EnvironmentObject var manager:HealthManager
    var body: some View {
        VStack{
            Chart{
                if(selectedCharter == .oneMonth){
                    ForEach(manager.oneMonthChartData){daily in
                        BarMark(x:.value(daily.date.formatted(), daily.date,unit: .day),y:.value("steps", daily.stepCount)).accessibilityLabel(String(format:"%.0f",daily.stepCount) + " steps were taken on \(daily.date.formatted())")}

                }
                if(selectedCharter == .oneWeek){
                    ForEach(manager.pastWeekChartStepData){daily in
                        BarMark(x:.value(daily.date.formatted(), daily.date,unit: .day),y:.value("steps", daily.stepCount)).accessibilityLabel(String(format:"%.0f",daily.stepCount) + " steps were taken on \(daily.date.formatted())")}
                }
                if(selectedCharter == .oneYear){
                    ForEach(manager.pastYTDChartStepData){daily in
                        BarMark(x:.value(daily.date.formatted(), daily.date,unit: .day),y:.value("steps", daily.stepCount)).accessibilityLabel(String(format:"%.0f",daily.stepCount) + " steps were taken on \(daily.date.formatted())")
                    }
                }
            }.padding().scaledToFit()
        }
        
        }
    }

