//
//  Source.swift
//  iPracticaTres
//
//  Created by ALEXIS-PC on 10/29/18.
//  Copyright © 2018 upc.edu.pe. All rights reserved.
//

import Foundation
import SwiftyJSON

class Source {
    var id: String
    var name: String
    var description: String
    var url: String
    var category: String
    var language: String
    var country: String
    
    init(id: String,
        name: String,
        description: String,
        url: String,
        category: String,
        language: String,
        country: String) {
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.category = category
        self.language = language
        self.country = country
    }
    convenience init(id: String, name: String) {
        self.init(id: id, name: name, description: "", url: "", category: "", language: "", country: "")
    }
    convenience init(from jsonSource: JSON) {
        self.init(id: jsonSource["id"].stringValue,
                  name: jsonSource["name"].stringValue,
                  description: jsonSource["description"].stringValue,
                  url: jsonSource["url"].stringValue,
                  category: jsonSource["category"].stringValue,
                  language: jsonSource["language"].stringValue,
                  country: jsonSource["country"].stringValue)
    }
    
    public func urlToLogo() -> String {
        return LogoApi.urlToLogo(for: "\(self.url)", withSize: 256)
    }
    
    class func buildAll(from jsonSources: [JSON]) ->[Source] {
        let count = jsonSources.count
        var sources: [Source] = []
        for i in 0 ..< count {
        sources.append(Source(from: JSON(jsonSources[i])))
        }
        return sources
    }
    
    /* para favorites >>> solo se usa setFavorite y isFavorite del store.
     */
    func setFavoritesSource(isFavorite: Bool) {
        //primero debemo hacer el iCatchUpStore
        let store = iPracticaTresStore()
        store.setFavorite(isFavorite: isFavorite, for: self)
    }
    
    func isFavoriteSource() -> Bool {
        let store = iPracticaTresStore()
        return store.isFavorite(source: self)
    }
}
