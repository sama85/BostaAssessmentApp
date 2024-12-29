//
//  AlbumDetailsViewModel.swift
//  Bosta
//
//  Created by Sama on 28/12/2024.
//

import Foundation
import Moya

class AlbumDetailsViewModel: ObservableObject {
    private let provider = MoyaProvider<APIService>()
    @Published var photos: [Photo] = []

    func fetchPhotos(for albumId: Int) {
        provider.request(.getPhotos(albumId: albumId)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let photos = try JSONDecoder().decode([Photo].self, from: response.data)
                    DispatchQueue.main.async {
                        // filter any invalid photos that don't have url or a thumbnail url
                        let validPhotos = photos.filter { !$0.thumbnailUrl.isEmpty && !$0.url.isEmpty }
                        self?.photos = validPhotos
                    }
                } catch {
                    print("Failed to decode photos: \(error)")
                }
            case .failure(let error):
                print("Request failed: \(error)")
            }
        }
    }
}
