//
//  NetworkService.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-02.
//
import Foundation

protocol NetworkServiceProtocol {
    
    func request<T: Codable>(endpoint: NetworkRequest) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    func request<T: Codable>(endpoint: any NetworkRequest) async throws -> T {
        
        let components =  endpoint.buildURLComponents()
        guard let url = components.url else {
            throw NetworkServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.methods.rawValue
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkServiceError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        
        switch statusCode {
        case 200..<300:
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            }catch{
                print(error)
                throw NetworkServiceError.decodingFailed
            }
        case 400..<500:
            throw NetworkServiceError.clientError(statusCode)
        case 500..<600:
            throw NetworkServiceError.serverError(statusCode)
        default:
            throw NetworkServiceError.unexpectedError(statusCode)
        }
    }
    
    
}
