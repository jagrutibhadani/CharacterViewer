//
//  CharacterDetailViewModel.swift
//  Simpsonsviewer
//
//  Created by Jagruti Patel CW on 6/14/23.
//

import Foundation
class CharacterDetailViewModel {
    var characterImageData: Data? = nil {
        didSet {
            if characterListModel != nil {
                // we dont want to send if data is not loaded from server
                bindModelToDetailViewController()
            }
           
        }
    }
    var characterTitle: String {
        return characterListModel?.characters[selectedIndex].text.components(separatedBy: "-").first ?? "Not found"
    }
    var characterDescription: String {
        return characterListModel?.characters[selectedIndex].text ?? "Not Found"
    }
    var error: String = ""
    var selectedIndex: Int = 0
    
    var isImageExists: Bool {
        let url = characterListModel?.characters[selectedIndex].icon.url
        return !(url?.isEmpty ?? true)
    }
    
    
    private var apiClient: APIClient
    private(set) var characterListModel: CharacterListModel? = nil
    var bindModelToDetailViewController : (() -> ()) = {}
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        if characterListModel == nil {
            loadCharacters()
        }       
        getCharacterImage()
    }

    func getCharacterImage() {
        if  let baseUrl = Bundle.main.infoDictionary?["BASE_URL"] as? String,
            let url = characterListModel?.characters[selectedIndex].icon.url,
           !url.isEmpty,
           let characterImageUrl = URL(string: "\(baseUrl)\(url)") {
            apiClient.fetchCharacterImage(from: characterImageUrl) { data in
                DispatchQueue.main.async { [weak self] in
                    self?.characterImageData = data
                }
            }
        } else {
            self.characterImageData = nil
        }
    }
    
    func loadCharacters() {
        guard let dataApi = Bundle.main.infoDictionary?["DATA_API"] as? String,
              let url = URL(string: dataApi) else {
            return
        }
        
        apiClient.fetchCharacters(from: url, completion: { result in
            DispatchQueue.main.async { [weak self] in
                switch(result) {
                case .success(let charactersList):
                    self?.characterListModel = charactersList
                    self?.bindModelToDetailViewController()
                case .failure(_):
                    self?.error = "Error getting characters"
                }
            }
        })        
    }
    
    
    
    
}
