//
//  LogoApi.swift
//  iPracticaTres
//
//  Created by ALEXIS-PC on 10/30/18.
//  Copyright © 2018 upc.edu.pe. All rights reserved.
//

import Foundation

class LogoApi {
    private static let baseUrl = "https://logo.clearbit.com/"
    
    public static func urlToLogo (for string: String, withSize size: Int = 128) -> String {
        if let url = URL(string: string){
            return  "\(baseUrl)\(url.host!)?size=\(size)"
        }
        return "\(baseUrl)\(string)"
    }
}
