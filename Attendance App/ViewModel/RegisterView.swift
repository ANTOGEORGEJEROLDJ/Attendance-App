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
    @State private var shouldNavigate = false

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
                        
                        // Profile Image Preview
                        Button(action: {
                            showImagePicker = true
                        }) {
                            if let image = profileUIImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }
                        }

                        Group {
                            TextField("User Name", text: $userName)
                                .autocapitalization(.none)
                                .padding()
                                .frame(width: 350, height: 50)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                                .background(Color.white.cornerRadius(10))
                                .padding(.top, 20)
                            
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .frame(width: 350, height: 50)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                                .background(Color.white.cornerRadius(10))
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .frame(width: 350, height: 50)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                                .background(Color.white.cornerRadius(10))
                            
                            TextField("Enter Phone Number", text: $phoneNumber)
                                .keyboardType(.numberPad)
                                .autocapitalization(.none)
                                .padding()
                                .frame(width: 350, height: 50)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                                .background(Color.white.cornerRadius(10))
                        }

                        Text("Select Role")
                            .font(.headline)
                            .padding(.top,-10)
                            .foregroundColor(.black)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(roles, id: \.self) { role in
                                    Button(action: {
                                        selectedRole = role
                                    }) {
                                        VStack {
                                            Image(systemName: roleIcons[role] ?? "questionmark")
                                                .resizable()
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
                            .padding(.horizontal,35)
                        }

                        Button(action: {
                            saveUserToCoreData()
                            shouldNavigate = true
                        }) {
                            Text("Register")
                                .frame(width: 150, height: 50)
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding(.top, 0)
//                        .disabled(userName.isEmpty || password.isEmpty || !isEmailValid || !isPhoneValid || selectedRole.isEmpty)

                        NavigationLink(destination: TabViewPage(
                            userName: userName,
                            role: $selectedRole,
                            email: email,
                            phoneNumber: phoneNumber,
                            profileImage: $profileImageData
                        ), isActive: $shouldNavigate) {
                            EmptyView()
                        }
                        
                    }
                    .padding()
                }
                
                .navigationTitle("Register Page")
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

    private func saveUserToCoreData() {
        let context = PersistenceController.shared.container.viewContext
        let newUser = User(context: context)
        newUser.username = userName
        newUser.email = email
        newUser.password = password
        newUser.phoneNumber = phoneNumber
        newUser.role = selectedRole
        newUser.profileImage = profileImageData

        do {
            try context.save()
            print("User saved successfully.")
        } catch {
            print("Error saving user: \(error.localizedDescription)")
        }
    }
}

#Preview {
    RegisterView()
}
