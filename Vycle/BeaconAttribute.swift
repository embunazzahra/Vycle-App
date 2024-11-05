//
//  BeaconAttribute.swift
//  Vycle
//
//  Created by Vincent Senjaya on 05/11/24.
//

import Foundation
import ActivityKit

struct BeaconAttribute: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var connectionStatus: String
    }
}
