import SwiftUI
import Charts

struct DailyCaloriesView:Identifiable{
    let id=UUID()
    let date:Date
    let caloriesCount:Double
}

struct CaloriesChartView: View {
    @State var selectedCharter: ChartOptions = .oneWeek
    @EnvironmentObject var manager: HealthManager

    var body: some View {
        VStack {
            Chart {
                if (selectedCharter == .oneMonth){
                    ForEach(manager.oneMonthChartCaloriesData) { daily in
                        BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("calories", daily.caloriesCount)).accessibilityLabel(String(format:"%.0f",daily.caloriesCount) + " calories were burned on \(daily.date.formatted())")
                        
                    }
                }
                if (selectedCharter == .oneWeek){
                    ForEach(manager.pastWeekChartCaloriesData) { daily in
                        BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("calories", daily.caloriesCount)).accessibilityLabel(String(format:"%.0f",daily.caloriesCount) + " calories were burned on \(daily.date.formatted())")
                            
                    }

                }
                if(selectedCharter == .oneYear){
                    ForEach(manager.pastYTDChartCaloriesData) { daily in
                        BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("calories", daily.caloriesCount)).accessibilityLabel(String(format:"%.0f",daily.caloriesCount) + " calories were burned on \(daily.date.formatted())")
                    }
                }
            }.foregroundColor(.red).background(.white)
                .padding(.horizontal).scaledToFit()
        }
            }
        }
