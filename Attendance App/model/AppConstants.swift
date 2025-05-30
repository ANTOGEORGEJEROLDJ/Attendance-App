//
//  AppConstants.swift
//  Attendance App
//
//  Created by Paranjothi iOS MacBook Pro on 29/05/25.
//

import SwiftUI

struct AppConstants {
    static let roles: [String] = [
        "Manager",
        "Team leader",
        "Employee",
        "Solution Architect",
        "Developer",
        "Tester",
        "Designer"
    ]
    
    static let roleIcons: [String: String] = [
        "Manager": "person.crop.circle",
        "Team leader": "person.2.circle",
        "Employee": "person",
        "Solution Architect": "brain.head.profile",
        "Developer": "laptopcomputer",
        "Tester": "checkmark.seal",
        "Designer": "pencil.and.outline"
    ]
}
