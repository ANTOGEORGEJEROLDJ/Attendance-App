//
//  Attendance_AppApp.swift
//  Attendance App
//
//  Created by Paranjothi iOS MacBook Pro on 28/05/25.
//

import SwiftUI

@main

struct AttendanceApp: App {
    var body: some Scene {
        WindowGroup {
            RegisterView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
