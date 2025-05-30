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

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(users, id: \.self) { user in
                        let username = user.username ?? ""
                        let role = user.role ?? "No Role"

                        NavigationLink(destination: AttendanceView(username: username) ){
                            HStack {
                                Text(username)
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
                // Add your logic or navigation here
            }
            .frame(width: 200, height: 50)
            .foregroundColor(.black)
            .background(Color.blue.opacity(0.4))
            .cornerRadius(20)
            .padding(.vertical, 50)
        }
        .navigationTitle("Select Name")
    }

    func fetchEntries(for username: String) -> [InOutEntry] {
        let request: NSFetchRequest<Attendance> = Attendance.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username) // Use the correct Core Data key

        do {
            let results = try viewContext.fetch(request)
            return results.map {
                InOutEntry(inTime: $0.inTime ?? Date(), outTime: $0.outTime)
            }
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }
}



struct NameSelect_preview: PreviewProvider {
    static var previews: some View {
        ProfilePagePreviewWrapper()
    }

    struct ProfilePagePreviewWrapper: View {
        @State private var role = "Employee"
        @State private var profileImage = Data()

        var body: some View {
            NavigationView {
                NameSelectPage()
            }
        }
    }
}
