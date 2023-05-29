//
//  ContentView.swift
//  DummyJsonApp
//
//  Created by Masi Soranummi on 10.5.2023.
//

import SwiftUI
import Alamofire

/// The main content view of the application.
struct ContentView: View {
    
    @State var done = false // Indicates whether the app is fetching data, used to show loading icon
    @State var users : Array<User> = []
    @State var addedUsers : Array<User> = []
    @State var deletedUsers : Array<Int> = []
    @State var 🔄 = false // Indicates whether the first loading is done
    @State var isAddingUser = false
    @State var isSearchingUser = false

    
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack {
                    if done {
                        VStack {
                            // Make a list of UserCards
                            ForEach(users, id: \.id) { user in
                                UserCard(user: user) {
                                    self.done = false
                                    deleteUser(user: user, deletedUsers: $deletedUsers, addedUsers: $addedUsers) {
                                        fetchAll(users: $users, done: $done, deletedUsers: $deletedUsers, addedUsers: $addedUsers)
                                    }
                                }
                            }
                        }
                    } else {
                        ProgressView().onAppear {
                            // Fetches all users when first opening the application
                            if !🔄 {
                                fetchAll(users: $users, done: $done, deletedUsers: $deletedUsers, addedUsers: $addedUsers)
                                self.🔄 = true
                            }
                        }.padding(.vertical, 300)
                    }
                }
            }
        }
        .toolbar {
            // Bottom bar buttons for adding, searching and getting all users
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button(action: {
                    print("Add button pressed")
                    self.isAddingUser = true
                }) {
                    Image(systemName: "plus")
                    Text("Add")
                }
                Spacer()
                Button(action: {
                    print("Search button pressed")
                    self.isSearchingUser = true
                }) {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                Spacer()
                Button(action: {
                    self.done = false
                    fetchAll(users: $users, done: $done, deletedUsers: $deletedUsers, addedUsers: $addedUsers)
                }) {
                    Image(systemName: "list.bullet")
                    Text("Get All")
                }
                Spacer()
            }
            // A "popup" for adding users
        } .sheet(isPresented: $isAddingUser) {
            AddUserView(isAdding: $isAddingUser){ firstname, lastname, email, phone in
                self.done = false
                addUser(firstName: firstname, lastName: lastname, email: email, phone: phone, addedUsers: $addedUsers) {
                    fetchAll(users: $users, done: $done, deletedUsers: $deletedUsers, addedUsers: $addedUsers)
                }
            }.frame(height: 200).presentationDetents([.fraction(0.5)])
            // A "popup" for searching users
        } .sheet(isPresented: $isSearchingUser) {
            SearchUserView(isSearching: $isSearchingUser) { searchTerm in
                self.done = false
                searchUsers(searchTerm: searchTerm)
            }.frame(height: 200).presentationDetents([.fraction(0.2)])
        }
    }
    
    /// Searches users based on the provided search term.
    ///
    /// - Parameter searchTerm: The search term.
    func searchUsers(searchTerm: String){
        done = false
        AF.request("https://dummyjson.com/users/search?q=\(searchTerm)", method: .get).response { response in
            let jsonDecoder = JSONDecoder()
            do {
                let data : String = String(data: response.data!, encoding: .utf8)!
                print(data)
                var results = try jsonDecoder.decode(Data.self, from: response.data!)
                
                // Add added users into the search results if name or email match with the search term
                addedUsers.forEach { user in
                    if user.firstName.lowercased().contains(searchTerm.lowercased())
                    || user.lastName.lowercased().contains(searchTerm.lowercased())
                    || user.email.lowercased().contains(searchTerm.lowercased()){
                        results.users.append(user)
                    }
                }
                
                // Delete deleted users from search results
                results.users = results.users.filter { user in
                                !deletedUsers.contains(user.id)
                }
                
                DispatchQueue.main.async {
                    users = results.users
                    done = true
                }
            } catch {
                print(error)
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
