//
//  ImageLoader.swift
//  Bosta
//
//  Created by Sama on 29/12/2024.
//

import Foundation
import Combine
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil

    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }.resume()
    }
}
