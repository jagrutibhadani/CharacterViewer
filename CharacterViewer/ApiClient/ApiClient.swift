//
//  ApiClient.swift
//  Simpsonsviewer
//
//  Created by Jagruti Patel CW on 6/14/23.
//

import Foundation
class APIClient: NSObject {
    let cache = URLCache.shared
    
    func fetchCharacters(from url: URL, completion: @escaping(Result<CharacterListModel, Error>) -> Void) {
        self.fetchData(from: url, completion: { result in
            switch(result) {
            case .success(let data):
                self.processData(data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
                
            }
        })
    }
    
    func fetchCharacterImage(from url: URL, completion: @escaping (Data?) -> Void) {
        self.fetchData(from: url, completion: { result in
            switch(result) {
            case .success(let data):
                completion(data)
            case .failure(_):
                completion(nil)
            }
        })
    }
        
    private func processData(_ data: Data, completion: @escaping(Result<CharacterListModel, Error>) -> Void) {
        do {
            let charactersList = try JSONDecoder().decode(CharacterListModel.self, from: data)
            completion(.success(charactersList))
        } catch {
            completion(.failure(NSError(domain: "", code: -1)))
            clearCache()
        }
    }
    
    private func fetchData(from url: URL, completion: @escaping(Result<Data, Error>) -> Void) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: .main)
        let request = URLRequest(url: url)
        
        if let cachedResponse = cache.cachedResponse(for: request) {
            completion(.success(cachedResponse.data))
            return
        }
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse, (200...209).contains(response.statusCode) {
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1)))
                    return
                }
                let cachedResponse = CachedURLResponse(response: response, data: data)
                self.cache.storeCachedResponse(cachedResponse, for: request)
                completion(.success(data))
                
            } else {
                completion(.failure(NSError(domain: "", code: -1)))
            }
        }.resume()
        
    }
    private func clearCache() {
        self.cache.removeAllCachedResponses()
    }
    
}

extension APIClient: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
