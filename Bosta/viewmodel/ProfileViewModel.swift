//
//  ProfileViewModel.swift
//  Bosta
//
//  Created by Sama on 28/12/2024.
//

import Foundation
import Moya

class ProfileViewModel: ObservableObject {
    private let provider = MoyaProvider<APIService>()
        @Published var user: User?
        @Published var albums: [Album] = []

        func fetchRandomUser() {
            provider.request(.getUsers) { [weak self] result in
                switch result {
                case .success(let response):
                    do {
                        let users = try JSONDecoder().decode([User].self, from: response.data)
                        if let randomUser = users.randomElement() {
                            DispatchQueue.main.async {
                                self?.user = randomUser
                                self?.fetchAlbums(for: randomUser.id)
                            }
                        }
                    } catch {
                        print("Failed to decode users: \(error)")
                    }
                case .failure(let error):
                    print("Request failed: \(error)")
                }
            }
        }

        func fetchAlbums(for userId: Int) {
            provider.request(.getAlbums(userId: userId)) { [weak self] result in
                switch result {
                case .success(let response):
                    do {
                        let albums = try JSONDecoder().decode([Album].self, from: response.data)
                        DispatchQueue.main.async {
                            self?.albums = albums
                        }
                    } catch {
                        print("Failed to decode albums: \(error)")
                    }
                case .failure(let error):
                    print("Request failed: \(error)")
                }
            }
        }
    }
