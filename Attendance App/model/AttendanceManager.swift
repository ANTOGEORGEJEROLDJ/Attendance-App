//
//  AttendanceManager.swift
//  Attendance App
//
//  Created by Paranjothi iOS MacBook Pro on 28/05/25.
//

import SwiftUI


class AttendanceViewModel: ObservableObject {
    @Published var entries: [InOutEntry] = []

    var totalWorkedDuration: TimeInterval {
        entries.compactMap { entry -> TimeInterval? in
            if let inTime = entry.inTime, let outTime = entry.outTime {
                return outTime.timeIntervalSince(inTime)
            }
            return nil
        }.reduce(0, +)
    }
}

