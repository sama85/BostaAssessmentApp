//
//  photo.swift
//  Bosta
//
//  Created by Sama on 28/12/2024.
//

import Foundation

struct Photo: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
