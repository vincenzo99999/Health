import Foundation
import SwiftUI

struct CaloriesView: View {
    @EnvironmentObject var manager: HealthManager
    @Environment(\.dismiss) private var dismiss
    @State var selectedCharter :ChartOptions = .oneWeek
    var activity: Activity

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        label: do {
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(.black)
                                .font(.system(size: 30))
                                .frame(width: 35, height: 35)
                            Spacer()
                        }
                    }
                }
                .navigationBarHidden(true)
        
                ZStack {
                    Rectangle().frame(width: 400, height: 500)
                    VStack {
                        Picker(selection: $selectedCharter, label: Text("")) {
                            Text("1w").tag(ChartOptions.oneWeek)
                            Text("1m").tag(ChartOptions.oneMonth)
                            Text("ytd").tag(ChartOptions.oneYear)
                        }
                        .padding()
                        .pickerStyle(.segmented)
                        
                        
                        TabView(selection: $selectedCharter){
                            CaloriesChartView(selectedCharter: .oneWeek)
                                .scaledToFit().tag(ChartOptions.oneWeek)
                            CaloriesChartView(selectedCharter: .oneMonth).scaledToFit().tag(ChartOptions.oneMonth)
                            
                            CaloriesChartView(selectedCharter: .oneYear).tag(ChartOptions.oneYear)
                        }
                            
                    }
                    .navigationBarBackButtonHidden()
                }
            }
        }
    }
}
