//
//  AddUserView.swift
//  DummyJsonApp
//
//  Created by Masi Soranummi on 23.5.2023.
//

import SwiftUI

/// A view for adding users.
struct AddUserView: View {
    
    /// The first name of the user.
    @State var firstName = ""
    
    /// The last name of the user.
    @State var lastName = ""
    
    /// The email address of the user.
    @State var email = ""
    
    /// The phone number of the user.
    @State var phone = ""
    
    /// Indicates whether the add window is currently active.
    @Binding var isAdding: Bool
    
    /// Closure to be called when pressing the "add user" button.
    var onAdd: (String, String, String, String) -> Void
    
    var body: some View { 
        VStack {
            Group {
                Spacer()
                Text("First name: ")
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Group {
                Spacer()
                Text("Last name: ")
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Group {
                Spacer()
                Text("Email: ")
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Group {
                Spacer()
                Text("Phone number: ")
                TextField("Phone", text: $phone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer()
            HStack {
                Spacer()
                Button("Cancel", role: .destructive){
                    isAdding = false
                }
                Spacer()
                Button("Add user"){
                    if(!firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !phone.isEmpty){
                        onAdd(firstName, lastName, email, phone)
                    }
                    isAdding = false
                }
                Spacer()
            }.padding()
        }.padding()
    }
}

