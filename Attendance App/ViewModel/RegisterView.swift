//
//  ContentView.swift
//  Attendance App
//
//  Created by Paranjothi iOS MacBook Pro on 28/05/25.
//



    
    import SwiftUI

    struct RegisterView: View {
        @State private var userName = ""
        @State private var email = ""
        @State private var password = ""
        @State private var phoneNumber = ""
        @State private var selectedRole: String = ""
        
        let roles = AppConstants.roles
        let roleIcons = AppConstants.roleIcons
        
        
        @State private var profileUIImage: UIImage? = nil
        @State private var profileImageData: Data = Data()
        @State private var showImagePicker = false
        

        var isPhoneValid: Bool {
            let phoneRegex = "^[0-9]{10}$"
            return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneNumber)
        }
        
        var isEmailValid: Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        }
        
        var body: some View {
            NavigationView {
                ZStack {
                    Image("backgroundImage")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            Group {
                                
                                
                              
                                TextField("User Name", text: $userName)
                                    .padding()
                                    .frame(width: 350, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                                    .background(Color(.white).cornerRadius(10))
                                
                                    .padding(.top, 60)
                                
                                
                                
                                TextField("Email", text: $email)
                                
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.none)
                                    .padding()
                                    .frame(width: 350, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                                    .background(Color(.white).cornerRadius(10))
                                
                                
                                SecureField("Password", text: $password)
                                    .padding()
                                    .frame(width: 350, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                                    .background(Color(.white).cornerRadius(10))
                                
                                
                                TextField("Enter Phone Number", text: $phoneNumber)
                                    .keyboardType(.numberPad)
                                    .textInputAutocapitalization(.none)
                                    .padding()
                                    .frame(width: 350, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                                
                                    .background(Color(.white).cornerRadius(10))
                                
                            
                            }
                            
                            // Role Selector
                            Text("Select Role")
                                .font(.headline)
                                .padding(.top)
                                .foregroundColor(.black.opacity(5))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(roles, id: \.self) { role in
                                        Button(action: {
                                            selectedRole = role
                                        }) {
                                            VStack {
                                                Image(systemName: roleIcons[role] ?? "questionmark")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 40, height: 40)
                                                    .foregroundColor(.black)
                                                
                                                Text(role)
                                                    .font(.caption)
                                                    .padding(6)
                                                    .foregroundColor(.white)
                                                    .background(selectedRole == role ? Color.blue : Color.gray)
                                                    .cornerRadius(8)
                                            }
                                            .padding()
         
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }

                            // Register Button
                            NavigationLink(destination: TabViewPage(
                                userName: userName,
                                role: $selectedRole,
                                email: email,
                                phoneNumber: phoneNumber,
                                profileImage: $profileImageData
                            )) {
                                Text("Register")
                                    .frame(width: 150, height: 50)
                                    .foregroundColor(.white)
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                            //.disabled(userName.isEmpty || password.isEmpty || !isEmailValid || !isPhoneValid || selectedRole.isEmpty)
                            
                        }
                        .padding(.bottom)
                        .padding(.horizontal, 20)
                    }
                    .padding()
                    .navigationTitle("Register Page")
                    .padding(.top)
                    .navigationBarBackButtonHidden(true)
                }
                
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $profileUIImage)
                    .onDisappear {
                        if let selected = profileUIImage {
                            profileImageData = selected.jpegData(compressionQuality: 0.8) ?? Data()
                        }
                    }
            }
        }
        
        private func customTextField(title: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
            TextField(title, text: text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.none)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
        }
    }

    #Preview {
        RegisterView()
    }
