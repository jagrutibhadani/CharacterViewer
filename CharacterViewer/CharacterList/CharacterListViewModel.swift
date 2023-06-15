//
//  SimpsonsViewModel.swift
//  Simpsonsviewer
//
//  Created by Jagruti Patel CW on 6/13/23.
//

import Foundation

class CharacterListViewModel {
    private(set) var characterListModel: CharacterListModel? = nil {
        didSet {
            bindModelToListViewController()
        }
    }
    
    var error: String = ""
    
    var bindModelToListViewController : (() -> ()) = {}
    
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        getCharacters()
    }
    
    func getCharacters() {
        apiClient.getCharacters(completion: { result in
            DispatchQueue.main.async { [weak self] in
                switch(result) {
                case .success(let charactersList):
                    self?.characterListModel = charactersList
                case .failure(_):
                    self?.characterListModel = nil
                    self?.error = "Error getting characters"
                }
            }
        })        
    }
  
    var charactorNames: [String] {
        return characterListModel?.characters.map{ $0.text.components(separatedBy: "-").first ?? "Not Found" } ?? []
    }
    
    var heading: String {
        return characterListModel?.heading ?? "Not Found"
    }
    
   
}
