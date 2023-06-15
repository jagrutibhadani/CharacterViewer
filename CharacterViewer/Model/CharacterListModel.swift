//
//  Simpsons.swift
//  Simpsonsviewer
//
//  Created by Jagruti Patel CW on 6/13/23.
//

import Foundation
struct CharacterListModel: Codable {
    
    let heading: String
    let characters: [Character]
    
    enum CodingKeys: String, CodingKey {
        case heading = "Heading"
        case characters = "RelatedTopics"
    }
    struct Character: Codable {
        let text: String
        let icon: Icon
        
        struct Icon: Codable {
            let url: String
            enum CodingKeys: String, CodingKey {
                case url = "URL"
            }
        }
        enum CodingKeys: String, CodingKey {
            case text = "Text"
            case icon = "Icon"
            
        }
    }
}
