//
//  inOutpage.swift
//  Attendance App
//
//  Created by Paranjothi iOS MacBook Pro on 28/05/25.
//

import SwiftUI
import Foundation

struct InOutEntry: Identifiable {
    let id = UUID()
    var inTime: Date?
    var outTime: Date?
}

struct InOutPage: View {

    @Binding var role: String
    @Binding var profileImage: Data

    var userName: String
    var email: String
    var phoneNumber: String

    @Binding var entries: [InOutEntry]

    @State private var profileImageData: Data = Data()
    @State private var showImagePicker = false

    @State private var isCheckInDisabled = false
    @State private var isCheckOutDisabled = true

    // Total worked time calculator
    var totalWorkedDuration: TimeInterval {
        entries.compactMap { entry in
            if let inTime = entry.inTime, let outTime = entry.outTime {
                return outTime.timeIntervalSince(inTime)
            }
            return nil
        }.reduce(0, +)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top Section
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Role")
                            .font(.caption)
                        Text(role)
                            .foregroundColor(.secondary)
                            .font(.headline)
                    }

                    Spacer()

                    HStack {
                        Text(userName)
                            .font(.title2)
                            .bold()
                            .lineLimit(1)
                            .padding(.leading, 50)
                    

                    Spacer()

                        NavigationLink(destination: profilePage(
                            userName: userName,
                            email: email,
                            phoneNumber: phoneNumber,
                            role: $role,
                            profileImage: $profileImage
                        )) {
                            if let uiImage = UIImage(data: profileImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            } else {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()

                Divider()

                // Current time & total worked
                HStack {
                    Text(Date(), style: .time)
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    VStack(alignment: .leading) {
                        if totalWorkedDuration > 0 {
                            Text("Total Worked:")
                                .bold()
                            Text(formattedDuration(totalWorkedDuration))
                                .foregroundColor(.blue)
                        }
                    }
                }

                // Entries
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(entries) { entry in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("In Time:")
                                        .bold()
                                    Spacer()
                                    Text(entry.inTime != nil ? formattedDate(entry.inTime!) : "-- : --  ")
                                        .foregroundColor(.green)
                                }

                                HStack {
                                    Text("Out Time:")
                                        .bold()
                                    Spacer()
                                    Text(entry.outTime != nil ? formattedDate(entry.outTime!) : "-- : --  ")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()

            // Bottom buttons
            HStack(spacing: 20) {
                Button(action: {
                    entries.append(InOutEntry(inTime: Date(), outTime: nil))
                    isCheckInDisabled = true
                    isCheckOutDisabled = false
                }) {
                    Text("Check In")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isCheckInDisabled ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(isCheckInDisabled)

                Button(action: {
                    if let lastIndex = entries.indices.last,
                       entries[lastIndex].outTime == nil {
                        entries[lastIndex].outTime = Date()
                        isCheckInDisabled = false
                        isCheckOutDisabled = true
                    }
                }) {
                    Text("Check Out")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isCheckOutDisabled ? Color.gray : Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(isCheckOutDisabled)
            }
            .padding()
            .background(Color(.systemBackground).shadow(radius: 5))
        }
        .onAppear {
            profileImageData = profileImage
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }

    // Formatters
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    func formattedDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return String(format: "%02dh %02dm", hours, minutes)
    }
}
