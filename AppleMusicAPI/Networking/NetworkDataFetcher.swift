//
//  NetworkDataFetcher.swift
//  AppleMusicAPI
//
//  Created by Leysan Latypova on 26.08.2022.
//

import Foundation

class NetworkDataFetcher {
    static let shared = NetworkDataFetcher()
    
    func fetchData(urlString: String, response: @escaping (SearchResponse?) -> Void) {
        NetworkManager.shared.request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(SearchResponse.self, from: data)
                    response(tracks)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
}
