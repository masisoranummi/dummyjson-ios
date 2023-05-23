//
//  AddUserView.swift
//  DummyJsonApp
//
//  Created by Masi Soranummi on 23.5.2023.
//

import SwiftUI

struct AddUserView: View {
    
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var phone = ""
    
    @Binding var isAdding: Bool
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

