//
//  Network.swift
//  Countries
//
//  Created by Buse Topuz on 9.11.2022.
//

import Foundation

struct NetworkConstant {
    static let apiHeader = "X-RapidAPI-Key"
    static let apiKey = "b21781bc60mshf7dac5699e8ac68p18267bjsn09cbfd1d64c0"
    static let apiURL = "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/?limit=10"
}

class ServiceLayer {
    
    static let shared = ServiceLayer()
    private init() {}
    
    public func request<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> Void ) {
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(NetworkConstant.apiKey, forHTTPHeaderField: NetworkConstant.apiHeader)
        urlRequest.httpMethod = router.method
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            if let err = error {
                completion(.failure(err))
                print(err.localizedDescription)
                return
            }
            guard response != nil, let data = data else {
                return
            }
            let responseObject = try! JSONDecoder().decode(T.self, from: data)
            DispatchQueue.main.async {
                completion(.success(responseObject))
            }
        }
        dataTask.resume()
    }
}
