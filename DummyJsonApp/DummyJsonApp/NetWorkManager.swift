//
//  NetWorkManager.swift
//  DummyJsonApp
//
//  Created by Masi Soranummi on 29.5.2023.
//

import SwiftUI
import Alamofire

/// Fetches all users from the server.
///
/// - Parameters:
///   - users: A binding to the array of users.
///   - done: A binding indicating whether the fetch operation is done.
///   - deletedUsers: A binding to the array of deleted user IDs.
///   - addedUsers: A binding to the array of added users.
func fetchAll(users: Binding<[User]>, done: Binding<Bool>, deletedUsers: Binding<[Int]>, addedUsers: Binding<[User]>) {
    AF.request("https://dummyjson.com/users", method: .get).response { response in
        let jsonDecoder = JSONDecoder()
        do {
            var results = try jsonDecoder.decode(Data.self, from: response.data!)
            results.users.append(contentsOf: addedUsers.wrappedValue)
            let filteredUsers = results.users.filter { !deletedUsers.wrappedValue.contains($0.id) }
            DispatchQueue.main.async {
                users.wrappedValue = filteredUsers
                done.wrappedValue = true
            }
        } catch {
            print(error)
        }
    }
}


/// Adds a new user to the server.
///
/// - Parameters:
///   - firstName: The first name of the user to be added.
///   - lastName: The last name of the user to be added.
///   - email: The email of the user to be added.
///   - phone: The phone number of the user to be added.
///   - addedUsers: A binding to the array of added users.
///   - callback: A callback closure to be executed after the user is added.
func addUser(firstName: String, lastName: String, email: String, phone: String,
             addedUsers: Binding<[User]>, callback: @escaping () -> Void) {
    
    let parameters: [String: Any] = [
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "image": "https://robohash.org/\(firstName+lastName)" // New image is generated based on the users first and last name
    ]
    
    AF.request("https://dummyjson.com/users/add", method: .post, parameters: parameters).response { response in
        let jsonDecoder = JSONDecoder()
        do {
            let addedUser = try jsonDecoder.decode(User.self, from: response.data!)
            print(addedUser)
            DispatchQueue.main.async {
                addedUsers.wrappedValue.append(addedUser)
                callback()
            }
        } catch {
            print(error)
        }
    }
    
}

/// Deletes a user from the server.
///
/// - Parameters:
///   - user: The user to be deleted.
///   - deletedUsers: A binding to the array of deleted user IDs.
///   - addedUsers: A binding to the array of added users.
///   - callback: A callback closure to be executed after the user is deleted.
func deleteUser(user: User, deletedUsers: Binding<[Int]>, addedUsers: Binding<[User]>, callback: @escaping () -> Void){
    
    // If user to be deleted is in the addedUsers array, remove it from there
    // otherwise do a proper delete request
    if(addedUsers.wrappedValue.contains(where: { $0.id == user.id })) {
        addedUsers.wrappedValue.removeAll(where: { $0.id == user.id })
        callback()
    } else {
        AF.request("https://dummyjson.com/users/\(user.id)", method: .delete).response { response in
            let jsonDecoder = JSONDecoder()
            do {
                let deletedUser = try jsonDecoder.decode(User.self, from: response.data!)
                DispatchQueue.main.async {
                    deletedUsers.wrappedValue.append(deletedUser.id)
                    print(deletedUsers.wrappedValue)
                    callback()
                }
            } catch {
                print(error)
            }
        }
    }
}
