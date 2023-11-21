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
                    Rectangle()
                        .frame(width: 400, height: 500)
                    TabView(selection: $selectedCharter,
                            content:  {
                        Text("1W").tabItem { CaloriesChartView() }.tag(1)
                        Text("1M").tabItem { CaloriesChartView() }.tag(2)
                    })
                    VStack (alignment: .leading){
                        HStack {
                            Text("\(activity.title)")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()

                            Image(systemName: activity.image)
                                .foregroundColor(.red)
                        }

                        HStack {
                            Text("\(activity.amount)\t")
                                .foregroundColor(.white)
                            Text("\(activity.subtitle)")
                                .foregroundColor(.white)
                        }

                        
                    }
                }
            }
        }
    }
}
