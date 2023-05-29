//
//  User.swift
//  DummyJsonApp
//
//  Created by Masi Soranummi on 29.5.2023.
//

/// A model representing a user.
struct User: Decodable {
    /// The unique identifier of the user.
    var id: Int
    
    /// The first name of the user.
    var firstName: String
    
    /// The last name of the user.
    var lastName: String
    
    /// The email address of the user.
    var email: String
    
    /// The phone number of the user.
    var phone: String
    
    /// The image URL associated with the user.
    var image: String
}
