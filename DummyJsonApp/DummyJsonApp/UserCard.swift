//
//  UserCard.swift
//  DummyJsonApp
//
//  Created by Masi Soranummi on 29.5.2023.
//

import SwiftUI

/// A view representing a user card, which includes the user information.
struct UserCard : View {
    
    /// The user associated with the card.
    var user: User
    
    /// Closure to be called when the delete button is pressed.
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.image)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            VStack {
                Text(user.firstName)
                Text(user.lastName)
            }
            VStack {
                Text("email: \(user.email)")
                    .font(.subheadline)
                Text("phone: \(user.phone)")
                    .font(.subheadline)
            }
        }.padding().frame(height: 90, alignment: .center)
            .frame(maxWidth: .infinity)
            .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.black, lineWidth: 4)
                .frame(maxWidth: .infinity)
            ).padding([.leading, .trailing], 10)
            .padding([.vertical], 5)
            .overlay(
                HStack {
                    Spacer()
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .padding(15),
                alignment: .topTrailing
            )
    }
}
