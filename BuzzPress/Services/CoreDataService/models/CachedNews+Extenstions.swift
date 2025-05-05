//
//  CachedNews+Extenstions.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-06.
//

import Foundation

extension CachedNews{
    
    func toNewsResponse() -> NewsResponse? {
        
        guard let data = self.data else { return nil }
        
        return try? JSONDecoder().decode(NewsResponse.self, from: data)
    }
    
}
