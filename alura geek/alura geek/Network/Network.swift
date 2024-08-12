//
//  Network.swift
//  alura geek
//
//  Created by Evolua Tech on 10/08/24.
//

import Foundation
import Network


protocol NetworkService: AnyObject {
    func fetchCategories(completion: @escaping (CategoryModel?, [Categoria]?, String?) -> Void)
    func fetchProducts(completion: @escaping (ProductModel?, [Produto]?, String?) -> Void)
}

class Network {
    
    let monitor = NWPathMonitor()

    func verifyInternet(completion: @escaping (NWPath.Status) -> Void) {
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Internet connection is available.")
                // Perform actions when internet is available
            } else {
                print("Internet connection is not available.")
                // Perform actions when internet is not available
            }
            completion(path.status)
        }
        
    }
    
    func fetchCategories(completion: @escaping (CategoryModel?, [Categoria]?, String?) -> Void) {
        
        let defaultSession = URLSession(configuration: .default)
        
        
        
        if let url = URL(string: "https://gist.githubusercontent.com/viniciosneves/68bc50d055acb4ecc7356180131df477/raw/14369c7e25fca54941f5359299b3f4f118a573d6/usedev-categorias.json") {
            
            let request = URLRequest(url:url)
            let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                guard error == nil else {
                    print ("error: ", error!)
                    completion(nil, nil, error?.localizedDescription)
                    return
                }
                
                guard data != nil else {
                    print("No data object")
                    completion(nil, nil, error?.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("response is: ", response!)
                    completion(nil, nil, error?.localizedDescription)
                    return
                }
                
                
                DispatchQueue.main.async {
                    
                    guard let result = try? JSONDecoder().decode(CategoryModel.self, from: data!) else {
                        print("Error Parsing JSON")
                        completion(nil, nil, "Error Parsing JSON")
                        return
                    }
                    
                    print(result)
                    print(result.categorias)
                    let categorias: [Categoria]?
                    categorias = result.categorias
                    
                    DispatchQueue.main.async {
                        completion(result, categorias, nil)
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    func fetchProducts(completion: @escaping (ProductModel?, [Produto]?, String?) -> Void) {
        
        let defaultSession = URLSession(configuration: .default)
        
        
        
        if let url = URL(string: "https://gist.githubusercontent.com/viniciosneves/946cbbc91d0bc0e167eb6fd895a6b12a/raw/0f6661903360535587ebe583b959e84192cdb771/usedev-produtos.json") {
            
            let request = URLRequest(url:url)
            let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                guard error == nil else {
                    print ("error: ", error!)
                    completion(nil, nil, error?.localizedDescription)
                    return
                }
                
                guard data != nil else {
                    print("No data object")
                    completion(nil, nil, error?.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("response is: ", response!)
                    completion(nil, nil, error?.localizedDescription)
                    return
                }
                
                
                DispatchQueue.main.async {
                    
                    guard let result = try? JSONDecoder().decode(ProductModel.self, from: data!) else {
                        print("Error Parsing JSON")
                        completion(nil, nil, "Error Parsing JSON")
                        return
                    }
                    
                    print(result)
                    print(result.produtos)
                    let produtos: [Produto]?
                    produtos = result.produtos
                    
                    DispatchQueue.main.async {
                        completion(result, produtos, nil)
                    }
                }
            })
            dataTask.resume()
        }
    }
}


