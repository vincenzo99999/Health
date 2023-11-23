//
//  ContentView.swift
//  Health
//
//  Created by Vincenzo Eboli on 13/11/23.
//

import SwiftUI
import SwiftData
import HealthKitUI
import HealthKit

struct ContentView: View {
    @Environment (\.dismiss) private var dismiss

    var body: some View {
        VStack {
            HStack {
                
                Button(action: {
                    dismiss()
                }){
                label: do {
                    Image(systemName: "chevron.backward").foregroundStyle(.blue).font(.system(size: 30))
                        .frame(width: 35, height: 35)
                    Spacer()
                }}
            }
        }
        VStack{
            Image(systemName: "globe").imageScale(.large).foregroundColor(.accentColor)
            Text("hello,world!")
        }
    }
}

    
#Preview {
    ContentView()
}
