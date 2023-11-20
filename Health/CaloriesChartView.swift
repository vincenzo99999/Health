import SwiftUI
import Charts

struct DailyCaloriesView:Identifiable{
    let id=UUID()
    let date:Date
    let caloriesCount:Double
}

struct CaloriesChartView: View {
    @State private var selectedCharter: ChartOptions = .oneMonth
    @EnvironmentObject var manager: HealthManager

    var body: some View {
        VStack {
            Chart {
                ForEach(manager.oneMonthChartCaloriesData) { daily in
                    BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("calories", daily.caloriesCount))
                }
            }.foregroundColor(.black)
            .frame(height: 350)
            .padding()

            HStack {
                Button("1M") {
                    selectedCharter = .oneMonth
                }
                .padding(.all)
            }
            .onAppear {
                print(manager.oneMonthChartCaloriesData)
            }
        }
    }
}
