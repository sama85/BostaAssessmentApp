//
//  ProfileView.swift
//  Bosta
//
//  Created by Sama on 28/12/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationView{
           VStack(alignment: .leading, spacing: 0) {
               if let user = viewModel.user {
                   Text("Profile")
                       .font(.title)
                       .padding([.top, .bottom, .leading])
                  
                    Text(user.name)
                        .font(.headline)
                        .padding(.leading)
                   
                    Text("\(user.address.street), \(user.address.suite), \(user.address.city), \(user.address.zipcode)")
                        .font(.subheadline)
                        .padding(.leading)
                }

               Text("My Albums")
                   .font(.title)
                   .padding([.top, .bottom, .leading])
               
               List(viewModel.albums, id: \.id) { album in
                   NavigationLink(destination: AlbumDetailsView(album: album)) {
                   Text(album.title)
                   }
                   
               }
               .listStyle(PlainListStyle())
           }
           .navigationBarHidden(true)
           .onAppear {
               if viewModel.user == nil {
                    viewModel.fetchRandomUser()
                }
           }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
