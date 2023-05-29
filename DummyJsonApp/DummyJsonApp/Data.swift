//
//  Data.swift
//  DummyJsonApp
//
//  Created by Masi Soranummi on 29.5.2023.
//

/// A data structure used for decoding JSON into an array of User objects.
struct Data: Decodable {
    /// An array of user objects.
    var users : Array<User>
}
