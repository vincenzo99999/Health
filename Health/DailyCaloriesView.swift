
import Foundation
import SwiftUI
import Charts
struct DailyCaloriesView:Identifiable{
    let id=UUID()
    let date:Date
    let stepCount:Double
}
enum ChartOptions{
    case oneWeek
    case oneMonth
    case oneYwar
}
struct ChartView:View {
    @State var selectedCharter :ChartOptions = .oneMonth
    @EnvironmentObject var manager:HealthManager
    var body: some View {
        VStack{
            Chart{
                ForEach(manager.oneMonthChartData){daily in
                    BarMark(x:.value(daily.date.formatted(), daily.date,unit: .day),y:.value("steps", daily.stepCount))}
            }.background(.green).foregroundColor(.yellow)
        }
        .frame(height: 350).padding()
        HStack{
            Button("1M"){
                selectedCharter = .oneMonth
            }.padding(.all).foregroundColor(.green)
        }.onAppear{print(manager.oneMonthChartData )}
    }
}
