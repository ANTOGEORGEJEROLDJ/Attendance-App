//
//  CoreDataManager.swift
//  Attendance App
//
//  Created by Paranjothi iOS MacBook Pro on 29/05/25.
//

import CoreData
import SwiftUI
@MainActor
class CoreDataManager: ObservableObject {
    let context = PersistenceController.shared.container.viewContext

    static let shared = CoreDataManager()  // Singleton for easy access

        let container: NSPersistentContainer
        
        init() {
            container = NSPersistentContainer(name: "UserModel") // Match your model filename
            container.loadPersistentStores { (desc, error) in
                if let error = error {
                    print("Failed to load Core Data store: \(error)")
                }
            }
        }
        
        func addUser(username: String, password: String, phoneNumber: String, email: String, role: String, profileImage: Data) {
            let newUser = User(context: container.viewContext)
            newUser.username = username
            newUser.password = password
            newUser.phoneNumber = phoneNumber
            newUser.email = email
            newUser.role = role
            newUser.profileImage = profileImage
            
            do {
                try container.viewContext.save()
                print("User saved successfully")
            } catch {
                print("Failed to save user: \(error.localizedDescription)")
            }
        }

    // Fetch all users
    func fetchUsers() -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching users: \(error)")
            return []
        }
    }

    // Save a new attendance record
    func addAttendance(for user: User, date: Date, inTime: Date, outTime: Date, timing: String) {
        let attendance = Attendance(context: context)
        attendance.id = UUID()
        attendance.date = date
        attendance.inTime = inTime
        attendance.outTime = outTime
        attendance.timing = timing
        attendance.user = user

        saveContext()
    }

    // Fetch attendance records for a user
    func fetchAttendances(for user: User) -> [Attendance] {
        let request: NSFetchRequest<Attendance> = Attendance.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@", user)
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching attendances: \(error)")
            return []
        }
    }

    // Save context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

