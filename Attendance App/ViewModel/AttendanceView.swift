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
    let roles = AppConstants.roles

    @State private var selectedRole = ""

    @FetchRequest var attendanceRecords: FetchedResults<Attendance>

    init(username: String) {
        self.username = username
        _attendanceRecords = FetchRequest<Attendance>(
            entity: Attendance.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Attendance.inTime, ascending: false)],
            predicate: NSPredicate(format: "user.username == %@", username),
            animation: .easeInOut
        )
    }

    var totalWorkedDuration: TimeInterval {
        attendanceRecords.reduce(0) { total, record in
            if let inTime = record.inTime, let outTime = record.outTime {
                return total + outTime.timeIntervalSince(inTime)
            }
            return total
        }
    }

    func formattedDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return String(format: "%02dh %02dm", hours, minutes)
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple.opacity(0.3), .purple.opacity(0.3)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                VStack {
                    Text(" \(username)")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black.opacity(6))
                        .padding()

                    Text("🕒 Total Worked Time")
                        .font(.headline)
                        .foregroundColor(.black.opacity(4))
                        .padding()

                    Text(formattedDuration(totalWorkedDuration))
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.pink.opacity(8))
                        .padding()
                }
                .padding()
                .frame(width: 300, height: 300)
                .background(.ultraThickMaterial)
                .cornerRadius(20)
                .shadow(radius: 10)
                
                Spacer()
                
                Picker("Change Role", selection: $selectedRole) {
                    ForEach(roles, id: \.self) { role in
                        Text(role).tag(role)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.black) // Changes selection tint to black

                .frame(maxWidth: .infinity)
                .padding()
                .background(.white)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 5)
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(attendanceRecords) { record in
                            AttendanceCard(record: record, roles: roles, saveAction: saveContext)
                        }
                    }
                    .padding()
                }

                Spacer()
            }
            .padding()
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
            print("Context saved")
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}

struct AttendanceCard: View {
    var record: Attendance
    var roles: [String]
    var saveAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "calendar")
                Text("Date: \(record.inTime ?? Date(), formatter: dateFormatter)")
            }

            HStack {
                Image(systemName: "clock")
                Text("In: \(record.inTime ?? Date(), formatter: timeFormatter)")
                Text("-")
                Text("Out: \(record.outTime ?? Date(), formatter: timeFormatter)")
            }

            if let user = record.user {
                Picker("Change Role", selection: Binding<String>(
                    get: { user.role ?? "" },
                    set: { newRole in
                        user.role = newRole
                        saveAction()
                    }
                )) {
                    ForEach(roles, id: \.self) { role in
                        Text(role).tag(role)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            } else {
                Text("Role info missing").foregroundColor(.red)
            }
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.white, .gray.opacity(0.1)]),
                                   startPoint: .top, endPoint: .bottom))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5)
    }
}

// Formatters
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


















