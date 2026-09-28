//
//  Item.swift
//  Algorithothm
//
//  Created by Greibis Farias on 28/9/26.
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
