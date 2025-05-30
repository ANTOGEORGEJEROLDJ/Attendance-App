//
//  NameSelectPage.swift
//  Attendance App
//
//  Created by Paranjothi iOS MacBook Pro on 29/05/25.
//



import SwiftUI

struct NameSelectPage: View {
    var userNames: [String]
    @Binding var role: String
    @State private var selectedEntries: [InOutEntry] = []

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(userNames, id: \.self) { name in
                        NavigationLink(destination: AttendanceView(entries: fetchEntries(for: name))) {
                            HStack {
                                Text(name)
                                    .font(.headline)
                                Spacer()
                                Text(role)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }

            Button("Change Role") {
                print("Change role tapped")
            }
            .frame(width: 200, height: 50)
            .foregroundColor(.black)
            .background(Color.blue.opacity(0.4))
            .cornerRadius(20)
            .padding(.vertical, 50)
        }
        .navigationTitle("Select Name")
    }

    func fetchEntries(for user: String) -> [InOutEntry] {
        // Dummy data — replace this with actual Core Data fetch logic
        return [
            InOutEntry(inTime: Date(), outTime: Calendar.current.date(byAdding: .hour, value: 8, to: Date())),
            InOutEntry(inTime: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
                       outTime: Calendar.current.date(byAdding: .hour, value: 8, to: Calendar.current.date(byAdding: .day, value: -1, to: Date())!))
        ]
    }
}

struct NameSelectPage_Previews: PreviewProvider {
    static var previews: some View {
        NameSelectPagePreviewWrapper()
    }

    struct NameSelectPagePreviewWrapper: View {
        @State private var role = "Manager"
        let sampleNames = ["Alice", "Bob", "Charlie"]

        var body: some View {
            NavigationView {
                NameSelectPage(userNames: sampleNames, role: $role)
            }
        }
    }
}


