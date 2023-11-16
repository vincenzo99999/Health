//
//  Health2App.swift
//  Health2
//
//  Created by Vincenzo Eboli on 15/11/23.
//

import SwiftUI
import SwiftData

@main
struct Health2App: App {
    @StateObject var manager=HealthManager()
    
    var body: some Scene {
        WindowGroup {
            HealthTabView().environmentObject(manager)
        }
    }
}
