//
//  ApiClient.swift
//  Simpsonsviewer
//
//  Created by Jagruti Patel CW on 6/14/23.
//

import Foundation
class APIClient: NSObject {
    let cache = URLCache.shared
    
    func getCharacters(completion: @escaping(Result<CharacterListModel, Error>) -> Void) {
        
        
        guard let dataApi = Bundle.main.infoDictionary?["DATA_API"] as? String,
              let url = URL(string: dataApi) else {
            return
        }
        let request = URLRequest(url: url)
        
        if let cachedResponse = cache.cachedResponse(for: request) {
            self.processData(cachedResponse.data, completion: completion)
        }
        
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse, (200...209).contains(response.statusCode) {
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1)))
                    return
                }
                self.processData(data, completion: completion)
                let cachedResponse = CachedURLResponse(response: response, data: data)
                self.cache.storeCachedResponse(cachedResponse, for: request)
                
            } else {
                completion(.failure(NSError(domain: "", code: -1)))
            }
        }
        task.resume()
        
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
    
    func fetchCharacterImage(from url: URL, completion: @escaping (Data?) -> Void) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: .main)
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("Invalid image data")
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }
    
    func clearCache() {
        self.cache.removeAllCachedResponses()
    }
    
}

extension APIClient: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
