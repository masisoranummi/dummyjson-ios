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
    @State var isExpanded = false
    @State var loaded = false
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack {
                    if done {
                        SearchButton(onSearch: searchUsers, expanded: $isExpanded)
                        VStack {
                            ForEach(users, id: \.id) { user in
                                UserCard(firstName: user.firstName, lastName: user.lastName, email: user.email, phone: user.phone, image: user.image)
                            }
                        }
                    } else {
                        ProgressView().onAppear {
                            if !loaded {
                                fetchAll(users: $users, done: $done)
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
                }) {
                    Image(systemName: "plus")
                    Text("Add")
                }
                Spacer()
                Button(action: {
                    print("Delete button pressed")
                }) {
                    Image(systemName: "trash")
                    Text("Delete")
                }
                Spacer()
                Button(action: {
                    print("Get All button pressed")
                }) {
                    Image(systemName: "list.bullet")
                    Text("Get All")
                }
                Spacer()
            }
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

func fetchAll(users: Binding<[User]>, done: Binding<Bool>) {
    AF.request("https://dummyjson.com/users", method: .get).response { response in
        let jsonDecoder = JSONDecoder()
        do {
            let data : String = String(data: response.data!, encoding: .utf8)!
            print(data)
            let results = try jsonDecoder.decode(Data.self, from: response.data!)
            DispatchQueue.main.async {
                users.wrappedValue = results.users
                done.wrappedValue = true
            }
        } catch {
            print(error)
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
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var image: String
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: image)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            VStack {
                Text(firstName)
                Text(lastName)
            }
            VStack {
                Text("email: \(email)")
                    .font(.subheadline)
                Text("phone: \(phone)")
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
    }
}

struct Data: Decodable {
    var users : Array<User>
}

struct User: Decodable {
    var id : Int
    var firstName : String
    var lastName : String
    var age : Int
    var email : String
    var phone : String
    var image : String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
