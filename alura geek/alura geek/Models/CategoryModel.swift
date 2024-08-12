//
//  CategoryModel.swift
//  alura geek
//
//  Created by Evolua Tech on 10/08/24.
//

import Foundation

struct CategoryModel: Codable {
    let categorias: [Categoria]
}


struct Categoria: Codable {
    let id: Int
    let nome: String
    let imagem: String
}
