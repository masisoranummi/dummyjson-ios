//
//  SearchUserView.swift
//  DummyJsonApp
//
//  Created by Masi Soranummi on 29.5.2023.
//

import SwiftUI

/// A view for searching users by name or email.
struct SearchUserView: View {
    
    /// String used for searching users.
    @State var searchTerm = ""
    
    /// Indicates whether the search-window is currently active.
    @Binding var isSearching: Bool
    
    /// Closure to be called when starting the search.
    var onSearch: (String) -> Void
    
    var body: some View {
        VStack {
            Group {
                Spacer()
                Text("Search by name or email")
                TextField("Search term", text: $searchTerm)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer()
            HStack {
                Spacer()
                Button("Cancel", role: .destructive){
                    isSearching = false
                }
                Spacer()
                Button("Search for user"){
                    if(!searchTerm.isEmpty){
                        onSearch(searchTerm)
                    }
                    isSearching = false
                }
                Spacer()
            }.padding()
        }.padding()
    }
}
