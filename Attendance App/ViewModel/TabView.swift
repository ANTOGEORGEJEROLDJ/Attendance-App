//
//  TapeView.swift
//  Attendance App
//
//  Created by Paranjothi iOS MacBook Pro on 28/05/25.
//

import SwiftUI

struct TabViewPage: View {
    var userName: String
    @Binding var role: String
    var email: String
    var phoneNumber: String
    @Binding var profileImage: Data

    @State private var entries: [InOutEntry] = [] // Shared state

    var body: some View {
        TabView {
            InOutPage(
                role: $role,
                profileImage: $profileImage,
                userName: userName,
                email: email,
                phoneNumber: phoneNumber,
                entries: $entries
            )
            .tabItem {
                Label("Home", systemImage: "house")
            }

            ListView(entries: entries)
                .tabItem {
                    Label("Attendance", systemImage: "list.bullet.rectangle")
                }

            profilePage(
                userName: userName,
                email: email,
                phoneNumber: phoneNumber,
                role: $role,
                profileImage: $profileImage
            )
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
        }
    }
}
