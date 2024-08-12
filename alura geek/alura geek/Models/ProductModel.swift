//
//  ProductModel.swift
//  alura geek
//
//  Created by Evolua Tech on 10/08/24.
//

import Foundation

struct ProductModel: Codable {
    let produtos: [Produto]
}


struct Produto: Codable {
    let id, categoriaID: Int
    let nome: String
    let preço: Double
    let imagem: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoriaID = "categoriaId"
        case nome, preço, imagem
    }
}
