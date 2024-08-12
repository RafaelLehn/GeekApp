//
//  HomeViewModel.swift
//  alura geek
//
//  Created by Evolua Tech on 10/08/24.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func returnCategories()
    func returnProducts()
    func returnError()
}

class HomeViewModel {
    
    var categoryList: [Categoria] = []
    
    var searchcategoryList: [Categoria] = []
    
    var productList: [Produto] = []
    
    var searchproductList: [Produto] = []
    
    var delegate: HomeViewModelProtocol?
    
    var isSearching = false
    
    var errorValue = false
    
    private let networkService = Network()
    
    func fetchCategories() {
        networkService.verifyInternet(completion: { internetStatus in
            if internetStatus == .satisfied {
                self.networkService.fetchCategories(completion: { categories, category, error in
                    
                    guard let categorias = categories else {
                        return
                    }
                    
                    guard var category = category else {
                        return
                    }
                    
                    if error != nil {
                        self.errorValue = true
                        self.delegate?.returnError()
                        return
                    }
                    
                    self.categoryList.append(contentsOf: category)
                    self.delegate?.returnCategories()
                })
            } else {
                
                self.errorValue = true
                self.delegate?.returnError()
            }
        })
        
        
    }
    
    func fetchProducts() {
        self.networkService.fetchProducts(completion: { products, product, error in
            
            guard let products = products else {
                return
            }
            
            guard var product = product else {
                return
            }
            
            if error != nil {
                self.errorValue = true
                self.delegate?.returnError()
                return
            }
            
            self.productList.append(contentsOf: product)
            self.delegate?.returnProducts()
        })
    }
    
    
    
}
