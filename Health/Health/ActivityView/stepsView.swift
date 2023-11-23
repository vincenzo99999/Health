    //
    //  stepsView.swift
    //  Health
    //
    //  Created by Vincenzo Eboli on 17/11/23.


    import SwiftUI

struct StepsView: View {
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
                            .foregroundStyle(.blue)
                            .font(.system(size: 30))
                            .frame(width: 35, height: 35)
                        Spacer()
                    }
                    }
                }.accessibilityLabel("back button ")
                
                ZStack {
                    Rectangle().frame(width: 400, height: 500)
                    VStack {
                        Picker(selection: $selectedCharter, label: Text("")) {
                            Text(" one week steps chart").tag(ChartOptions.oneWeek)
                            Text("one  month steps chart").tag(ChartOptions.oneMonth)
                            Text("year to date steps chart").tag(ChartOptions.oneYear)
                        }
                        .padding()
                        .pickerStyle(.segmented)
                        
                        
                        TabView(selection: $selectedCharter){
                            ChartView(selectedCharter: .oneWeek)
                                .scaledToFit().tag(ChartOptions.oneWeek)
                            ChartView(selectedCharter: .oneMonth).scaledToFit().tag(ChartOptions.oneMonth)
                            
                            ChartView(selectedCharter: .oneYear).tag(ChartOptions.oneYear)
                        }
                            
                    }
                    .navigationBarBackButtonHidden()
                }
            }
        }
    }
}
