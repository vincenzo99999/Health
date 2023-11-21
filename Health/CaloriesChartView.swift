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
                        BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("calories", daily.caloriesCount))
                    }
                }
                if (selectedCharter == .oneWeek){
                    ForEach(manager.pastWeekChartCaloriesData) { daily in
                        BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("calories", daily.caloriesCount))
                    }

                }
                if(selectedCharter == .oneYear){
                    ForEach(manager.pastYTDChartCaloriesData) { daily in
                        BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("calories", daily.caloriesCount))
                    }
                }
            }.foregroundColor(.black)
                .padding(.horizontal).scaledToFit()
                
            }
            }
        }
