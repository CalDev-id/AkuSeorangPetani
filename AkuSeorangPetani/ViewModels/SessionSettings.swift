//
//  SessionSettings.swift
//  AkuSeorangPeternak
//
//  Created by Heical Chandra on 17/05/24.
//

import SwiftUI

class SessionSettings: ObservableObject {
    @Published var isPeopleOcclusionEnabled: Bool = false
    @Published var isObjectOcclusionEnabled: Bool = false
    @Published var isLidarDebugEnabled: Bool = false
    @Published var isMultiuserEnabled: Bool = false

}
