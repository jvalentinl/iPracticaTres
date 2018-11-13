//
//  NewsApi.swift
//  iPracticaTres
//
//  Created by ALEXIS-PC on 10/29/18.
//  Copyright © 2018 upc.edu.pe. All rights reserved.
//

import Foundation

class NewsApi {
    private static let baseUrl = "https://newsapi.org"
    
    public static var topHeadlinesUrl: String {
        return "\(baseUrl)/v2/top-headlines"
    }
    public static var everithingUrl: String {
        return "\(baseUrl)/v2/everything"
    }
    public static var sourcesUrl: String {
        return "\(baseUrl)/v2/sources"
    }
    public static var key: String {
        return Bundle.main.object(forInfoDictionaryKey: "NewsApiKey") as! String
    }
}
