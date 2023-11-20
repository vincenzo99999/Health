//
//  stepsView.swift
//  Health
//
//  Created by Vincenzo Eboli on 17/11/23.


import SwiftUI

struct StepsView: View {
    @EnvironmentObject var manager: HealthManager
    @State private var weeklyStepCounts: [Date: Int] = [:]
    @Environment(\.dismiss) private var dismiss
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
                        HStack {
                            Text(" \(activity.title)")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()

                            Image(systemName: activity.image)
                                .foregroundColor(.red)
                        }
                        HStack {
                            Text("\(activity.amount)\t").foregroundColor(.white)
                            Text("\(activity.subtitle)").foregroundColor(.white)
                        }
                        
                        // Utilizzo di NavigationLink per navigare a ChartView
                        NavigationLink("Chart", destination: ChartView(selectedCharter: .oneMonth))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}
