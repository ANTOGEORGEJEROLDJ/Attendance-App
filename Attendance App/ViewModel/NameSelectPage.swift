//
//  NameSelectPage.swift
//  Attendance App
//
//  Created by Paranjothi iOS MacBook Pro on 29/05/25.
//


import SwiftUI
import CoreData

struct NameSelectPage: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)]
    ) private var users: FetchedResults<User>

    @State private var highlightedUsername: String? = nil

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(users, id: \.self) { user in
                        let username = user.username ?? ""
                        let role = user.role ?? "No Role"

                        NavigationLink(destination: AttendanceView(username: username)
                                        .onDisappear {
                                            // Refresh UI when coming back
                                            highlightedUsername = username
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                highlightedUsername = nil
                                            }
                                        }
                        ) {
                            HStack {
                                Text(username)
                                    .font(.headline)
                                Spacer()
                                Text(role)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                highlightedUsername == username
                                ? Color.green.opacity(0.3)
                                : Color.blue.opacity(0.2)
                            )
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }

//            Button("Change Role") {
//                // Add logic or navigation here
//            }
//            .frame(width: 200, height: 50)
//            .foregroundColor(.black)
//            .background(Color.blue.opacity(0.4))
//            .cornerRadius(20)
//            .padding(.vertical, 50)
        }
        .navigationTitle("Select Name")
    }
}

struct NameSelect_preview: PreviewProvider {
    static var previews: some View {
        ProfilePagePreviewWrapper()
    }

    struct ProfilePagePreviewWrapper: View {
        var body: some View {
            NavigationView {
                NameSelectPage()
            }
        }
    }
}
