//
//  AlbumDetailsView.swift
//  Bosta
//
//  Created by Sama on 28/12/2024.
//

import SwiftUI

struct AlbumDetailsView: View {
    let album: Album
    @StateObject private var viewModel = AlbumDetailsViewModel()
    @State private var searchString: String = ""
    
    var searchedPhotos: [Photo] {
        if searchString.isEmpty {
            return viewModel.photos
        } else {
            return viewModel.photos.filter { $0.title.lowercased().contains(searchString.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            Text(album.title)
                .font(.title)
                .padding()
                .lineLimit(1)
                .truncationMode(.tail)
            
            SearchBar(text: $searchString)
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())], spacing: 0) {
                        ForEach(searchedPhotos, id: \ .id) { photo in
                            // load photo from its url
                            AsyncImage(url: URL(string: photo.url)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                case .failure:
                                    // if photo fails to load from url, try loading from thumbnail url
                                    AsyncImage(url: URL(string: photo.thumbnailUrl)) { thumbnailPhase in
                                        switch thumbnailPhase {
                                        case .empty:
                                            ProgressView()
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        case .success(let thumbnail):
                                            thumbnail
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        case .failure:
                                            // default image if photo fails to load from thumbnail url
                                            Image(systemName: "photo.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(height: 100)
                        }
                    }
                    .padding(0)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchPhotos(for: album.id)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            TextField("Search in images", text: $text)
                .padding(6)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.vertical, 6)
        }
    }
}


struct AlbumDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailsView(album: Album(userId: 1, id: 1, title: "quidem molestiae enim"))
    }
}
