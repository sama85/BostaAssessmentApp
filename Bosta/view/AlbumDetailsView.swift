//
//  AlbumDetailsView.swift
//  Bosta
//
//  Created by Sama on 28/12/2024.
//

import SwiftUI
import Combine

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
                        ForEach(searchedPhotos, id: \.id) { photo in
                            if let url = URL(string: photo.url) {
                                AsyncImageView(url: url)
                                    .frame(height: 100)
                            } else {
                                if let thumbnailUrl = URL(string: photo.thumbnailUrl) {
                                    AsyncImageView(url: thumbnailUrl)
                                        .frame(height: 100)
                                } else {
                                    // handle invalid URL
                                    Image(systemName: "photo.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                }
                            }
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

struct AsyncImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let url: URL
    
    var body: some View {
        if let uiImage = imageLoader.image {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ProgressView()
                .onAppear { imageLoader.loadImage(from: url) }
        }
    }
}

struct AlbumDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailsView(album: Album(userId: 1, id: 1, title: "quidem molestiae enim"))
    }
}
