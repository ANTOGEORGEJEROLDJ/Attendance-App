//
//  AttendanceView.swift
//  Attendance App
//
//  Created by Paranjothi iOS MacBook Pro on 30/05/25.
//

import SwiftUI

struct AttendanceView: View {
    let entries: [InOutEntry]
    
//    var pickere = ["manager","teamleader","hr","developer"]
//    @State private var selectedRole: String = "manager"

    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)],
        animation: .default
    )
    private var users: FetchedResults<User>
//    let roles = AppConstants.roles
//    @Binding var role: String = "manager"

    var attendanceRecords: [Attendances] {
        entries.compactMap { entry in
            guard let inTime = entry.inTime, let outTime = entry.outTime else { return nil }

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium

            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short

            let dateString = dateFormatter.string(from: inTime)
            let timingString = "In: \(timeFormatter.string(from: inTime)) - Out: \(timeFormatter.string(from: outTime))"
            return Attendances(date: dateString, timing: timingString)
        }
    }

    var body: some View {
        ZStack {
            // Background Image
            Image("backgroundImage")
                .resizable()
                .padding(.all, -150)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Attendance List")
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
                    .padding(.top, 60)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(attendanceRecords) { record in
                            VStack(alignment: .leading) {
                                Text("Date: \(record.date)")
                                    .font(.headline)
                                Text(record.timing)
                                    .font(.subheadline)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.purple.opacity(0.7))
                            .cornerRadius(12)
                            .shadow(radius: 3)
                        }
                    }
                    .padding(.horizontal)
                }
//
                
//                Text("Select Role")
//                        .font(.headline)
//                        .foregroundColor(.black)
//
//                Picker("Select Role", selection: $rolesZ) {
//                        ForEach(users, id: \.self) {
//                            Text($0).tag($0)
//
//                        }
//                    }
//
//                .pickerStyle(MenuPickerStyle()) // or MenuPickerStyle(), WheelPickerStyle(), etc.
//                    .padding(.horizontal)
//                    .background(Color.orange.opacity(0.8))
//                    .cornerRadius(10)
                    


                Spacer()
            }
        }
        .padding()
    }
}

// MARK: - Preview
struct AttendanceView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var role: String = "Worker"
        
        var body: some View {
            AttendanceView(
                entries: [
                    InOutEntry(
                        inTime: Date(),
                        outTime: Calendar.current.date(byAdding: .hour, value: 8, to: Date())
                    )
                ],
//                role: $role
            )
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
