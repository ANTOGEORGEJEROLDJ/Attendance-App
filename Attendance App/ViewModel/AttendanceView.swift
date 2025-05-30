//
//  AttendanceView.swift
//  Attendance App
//
//  Created by Paranjothi iOS MacBook Pro on 30/05/25.
//

import SwiftUI
import CoreData

struct AttendanceView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let username: String

    // Roles list
    let roles = AppConstants.roles

    // Selected role for filtering (optional)
    @State private var selectedRole = ""

    // Fetch only attendance records for logged-in user
    @FetchRequest var attendanceRecords: FetchedResults<Attendance>

    init(username: String) {
        self.username = username

        // FetchRequest predicate to filter by username of user relationship
        _attendanceRecords = FetchRequest<Attendance>(
            entity: Attendance.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Attendance.inTime, ascending: true)],
            predicate: NSPredicate(format: "user.username == %@", username),
            animation: .default
        )
    }

    var totalWorkedDuration: TimeInterval {
        attendanceRecords.reduce(0) { partialResult, record in
            if let inTime = record.inTime, let outTime = record.outTime {
                return partialResult + outTime.timeIntervalSince(inTime)
            }
            return partialResult
        }
    }

    func formattedDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return String(format: "%02dh %02dm", hours, minutes)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Attendance for \(username)")
                .font(.largeTitle)
                .bold()

            

            Text("Total Worked Time:")
                .font(.title2)
                .bold()

            Text(formattedDuration(totalWorkedDuration))
                .font(.title)
                .foregroundColor(.blue)

            Divider().padding()

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(attendanceRecords.filter {
                        selectedRole.isEmpty || $0.user?.role == selectedRole
                    }) { record in
                        VStack(alignment: .leading) {
                            Text("Date: \(record.inTime ?? Date(), formatter: dateFormatter)")
                            Text("In: \(record.inTime ?? Date(), formatter: timeFormatter) - Out: \(record.outTime ?? Date(), formatter: timeFormatter)")
                            Text("Role: \(record.user?.role ?? "Unknown")")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            // Role Picker
            Picker("Select Role", selection: $selectedRole) {
                Text("All Roles").tag("")
                ForEach(roles, id: \.self) { role in
                    Text(role).tag(role)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.purple.opacity(0.6))
            .cornerRadius(13)
            .padding(.horizontal)
            

            Spacer()
        }
        .padding()
    }
}


// Date and time formatter helpers
private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .medium
    return df
}()

private let timeFormatter: DateFormatter = {
    let tf = DateFormatter()
    tf.timeStyle = .short
    return tf
}()












