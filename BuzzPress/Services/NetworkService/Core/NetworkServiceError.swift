//
//  NetworkServiceError.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-02.
//

import Foundation

enum NetworkServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case clientError(Int)
    case serverError(Int)
    case unexpectedError(Int)
}
