//
//  profilePage.swift
//  Attendance App
//
//  Created by Paranjothi iOS MacBook Pro on 28/05/25.
//


import SwiftUI

struct profilePage: View {
    var userName: String
    var email: String
    var phoneNumber: String
    let roles = AppConstants.roles

    @Binding var role: String
    @Binding var profileImage: Data

//    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var profileUIImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var selectedUIImage: UIImage? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack{
                
                // Profile Image Section
                ZStack(alignment: .bottomTrailing) {
                    if let uiImage = profileUIImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    } else {
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Image(systemName: "camera")
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Circle().fill(Color.black.opacity(1)))
                    }
                    .padding(8)
                }
                
                // User Info Section
                Text(userName)
                    .font(.largeTitle)
                    .bold()
                
                Text(role)
                    .font(.title2)
                    .foregroundColor(.gray)
                
                // Profile Detail Card
                VStack(alignment: .leading, spacing: 30) {
                    
                    // Role Picker
                    Text("Update Role")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading,-50)
                        .padding(.bottom,-20)
                    
                    Picker("Select Role", selection: $role) {
                        ForEach(roles, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(.red)
                    .padding()
                    .frame(height: 40)
                    .frame(width: 250)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.leading,-50)
                    
                    // Email
                    VStack(alignment: .leading) {
                        Text("Email")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        Text(email)
                            .font(.title3)
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding(.leading,-50)
                    
                    // Phone
                    VStack(alignment: .leading) {
                        Text("Phone Number")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        Text(phoneNumber)
                            .font(.title3)
                            .foregroundColor(.white)
                            .bold()
                    }
                    
                    .padding(.leading,-50)
                    
                }
                
                .padding()
                .frame(width: 380, height: 280)
                .background(Color.purple.opacity(0.85))
                .cornerRadius(30)
                .padding(.horizontal)
                .padding(.top, 10)
               
                
            
            }
             
            if role == "Manager" {
                NavigationLink(destination: NameSelectPage()) {
                    Text("Select Employee")
                        .padding()
                        .frame(width: 370 )
                        .background(Color.purple.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .bold()
                }
            }
                
            }
            .padding(.top)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Load existing image from binding
            if let img = UIImage(data: profileImage) {
                profileUIImage = img
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $profileUIImage)
                .onDisappear {
                    if let newImage = profileUIImage {
                        profileImage = newImage.jpegData(compressionQuality: 0.8) ?? profileImage
                    }
                }
        }
    }
}

struct profile_preview: PreviewProvider {
    static var previews: some View {
        ProfilePagePreviewWrapper()
    }

    struct ProfilePagePreviewWrapper: View {
        @State private var role = "Employee"
        @State private var profileImage = Data()

        var body: some View {
            NavigationView {
                profilePage(
                    userName: "John Doe",
                    email: "john.doe@example.com",
                    phoneNumber: "+1234567890",
                    role: $role,
                    profileImage: $profileImage
                )
            }
        }
    }
}

