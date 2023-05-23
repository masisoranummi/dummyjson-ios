//
//  ContentView.swift
//  DummyJsonApp
//
//  Created by Masi Soranummi on 10.5.2023.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    
    @State var done = false
    @State var users : Array<User> = []
    @State var addedUsers : Array<User> = []
    @State var deletedUsers : Array<Int> = []
    @State var isExpanded = false
    @State var loaded = false
    @State var isAddingUser = false
    
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack {
                    if done {
                        SearchButton(onSearch: searchUsers, expanded: $isExpanded)
                        VStack {
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
                            if !loaded {
                                fetchAll(users: $users, done: $done, deletedUsers: $deletedUsers, addedUsers: $addedUsers)
                                self.loaded = true
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
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
                    self.done = false
                    fetchAll(users: $users, done: $done, deletedUsers: $deletedUsers, addedUsers: $addedUsers)
                }) {
                    Image(systemName: "list.bullet")
                    Text("Get All")
                }
                Spacer()
            }
        } .sheet(isPresented: $isAddingUser) {
            AddUserView(isAdding: $isAddingUser){ firstname, lastname, email, phone in
                self.done = false
                addUser(firstName: firstname, lastName: lastname, email: email, phone: phone, addedUsers: $addedUsers) {
                    fetchAll(users: $users, done: $done, deletedUsers: $deletedUsers, addedUsers: $addedUsers)
                }
            }.frame(height: 200).presentationDetents([.fraction(0.5)])
        }
    }
    
    func searchUsers(searchTerm: String){
        done = false
        AF.request("https://dummyjson.com/users/search?q=\(searchTerm)", method: .get).response { response in
            let jsonDecoder = JSONDecoder()
            do {
                let data : String = String(data: response.data!, encoding: .utf8)!
                print(data)
                let results = try jsonDecoder.decode(Data.self, from: response.data!)
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

func fetchAll(users: Binding<[User]>, done: Binding<Bool>, deletedUsers: Binding<[Int]>, addedUsers: Binding<[User]>) {
    AF.request("https://dummyjson.com/users", method: .get).response { response in
        let jsonDecoder = JSONDecoder()
        do {
            // let data : String = String(data: response.data!, encoding: .utf8)!
            // print(data)
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

func addUser(firstName: String, lastName: String, email: String, phone: String,
             addedUsers: Binding<[User]>, callback: @escaping () -> Void) {
    
    let parameters: [String: Any] = [
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "image": "https://robohash.org/\(firstName+lastName)"
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

func deleteUser(user: User, deletedUsers: Binding<[Int]>, addedUsers: Binding<[User]>, callback: @escaping () -> Void){
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

struct SearchButton : View {
    var onSearch: (String) -> Void
    @Binding var expanded: Bool
    @State var searchTerm = ""
    var body: some View {
        VStack{
            Button("Search users", action: { expanded = !expanded })
            if expanded {
                HStack {
                    TextField("Search Users", text: $searchTerm)
                    Button("Start search"){
                        onSearch(searchTerm)
                    }
                }.padding()
            }
        }
    }
}

struct UserCard : View {
    
    var user: User
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

struct Data: Decodable {
    var users : Array<User>
}

struct User: Decodable {
    var id : Int
    var firstName : String
    var lastName : String
    var email : String
    var phone : String
    var image : String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
