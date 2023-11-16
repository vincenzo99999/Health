//
//  HomeView.swift
//  Health
//
//  Created by Vincenzo Eboli on 15/11/23.
//

import Foundation
import SwiftUI

struct HomeView:View {
    @EnvironmentObject var manager:HealthManager
    var body: some View {
        VStack{
            LazyHGrid(rows:Array(repeating: GridItem(spacing:20),count:3)){
                ForEach(manager.activities.sorted(by:{ $0.value.id < $1.value.id}),id:  \.key){item in
                    ActivityCard(activity: item.value)
                    }
                }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
