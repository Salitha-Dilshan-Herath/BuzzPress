//
//  NewsRepositories.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-02.
//

import Foundation

protocol NewsRepositoriesProtocol {
    func getTopNews(country: String, category: String, pageSize: Int , page: Int) async throws -> NewsResponse
}

class NewsRepositories
