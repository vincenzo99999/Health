//
//  Item.swift
//  Health
//
//  Created by Vincenzo Eboli on 13/11/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
