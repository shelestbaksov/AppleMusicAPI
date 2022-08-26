//
//  NetworkManager.swift
//  AppleMusicAPI
//
//  Created by Leysan Latypova on 26.08.2022.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func request(urlString: String, completion: @escaping (Result<Data,Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
                
            }
        }.resume()
    }
}
