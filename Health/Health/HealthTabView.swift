//
//  HealthTabView.swift
//  Health
//
//  Created by Vincenzo Eboli on 15/11/23.
//

import Foundation
import SwiftUI

struct HealthTabView:View {
    @EnvironmentObject var manager:HealthManager
    @State var selectedTab="Home"
    var body: some View {
            HomeView().tag("Home").tabItem{
                Image(systemName: "house")
            }
            .environmentObject(manager)
            
    }
}

#Preview {
    HealthTabView()
}
