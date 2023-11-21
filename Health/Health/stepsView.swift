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
                            .foregroundStyle(.black)
                            .font(.system(size: 30))
                            .frame(width: 35, height: 35)
                        Spacer()
                    }
                    }
                }
                
                ZStack {
                    Rectangle().frame(width: 400, height: 500)
                    VStack {
                        Picker(selection: $selectedCharter, label: Text("")) {
                            Text("1w").tag(0)
                            Text("1m").tag(1)
                            Text("ytd").tag(2)
                        }
                        .padding()
                        .pickerStyle(.segmented)
                        
                        
                        TabView(selection: $selectedCharter){
                            ChartView(selectedCharter: .oneWeek)
                                .scaledToFit().tag(0)
                            ChartView(selectedCharter: .oneMonth).scaledToFit().tag(1)
                            
                                Text("placeholder").tag(2)
                        }
                            
                    }
                    .navigationBarBackButtonHidden()
                }
            }
        }
    }
}
