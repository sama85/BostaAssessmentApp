//
//  user.swift
//  Bosta
//
//  Created by Sama on 28/12/2024.
//

import Foundation

// Define User Models
struct User: Codable {
    let id: Int
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}
