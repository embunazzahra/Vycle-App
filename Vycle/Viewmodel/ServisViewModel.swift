//
//  ServisViewModel.swift
//  Vycle
//
//  Created by Vincent Senjaya on 24/10/24.
//

import SwiftUI

final class ServiceDetailViewModel: ObservableObject {
    @Published var serviceName: String = ""

    init(serviceID: UUID) {
        // Fetch the service based on the serviceID
    }
}
