//
//  ContentView.swift
//  DummyJsonApp
//
//  Created by Masi Soranummi on 10.5.2023.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    
    @State var temperature : String = "testi"
    @State var done = false
    @State var users : Array<User> = []
    
    var body: some View {
        ScrollView{
            VStack {
                if done {
                    VStack {
                        ForEach(users, id: \.id) { user in
                            HStack {
                                AsyncImage(url: URL(string: user.image)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                Text("\(user.firstName) \(user.lastName)")
                                    .padding()
                                    .cornerRadius(20)
                            }

                        }
                    }
                } else {
                    ProgressView().onAppear {
                        AF.request("https://dummyjson.com/users", method: .get).response { response in
                            let jsonDecoder = JSONDecoder()
                            do {
                                let data : String = String(data: response.data!, encoding: .utf8)!
                                print(data)
                                let results = try jsonDecoder.decode(Data.self, from: response.data!)
                                DispatchQueue.main.async {
                                    users = results.users
                                }
                                done = true
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            .padding()
        }
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
    var gender : String
    var image : String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
