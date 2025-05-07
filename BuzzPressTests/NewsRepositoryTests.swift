////
////  NewsRepositoryTests.swift
////  BuzzPress
////
////  Created by Spemai on 2025-05-07.
////
//
//import XCTest
//@testable import BuzzPress
//
//class NewsRepositoryTests: XCTestCase {
//    
//    var repository: NewsRepository!
//    var mockNetworkService: MockNetworkService!
//    var mockCacheService: MockCoreDataService!
//    
//    let testNewsResponse = NewsResponse(
//        status: "ok",
//        totalResults: 3,
//        articles: [
//
//        ]
//    )
//    
//    override func setUp() {
//        super.setUp()
//        mockNetworkService = MockNetworkService()
//        mockCacheService = MockCoreDataService()
//        repository = NewsRepository(
//            networkService: mockNetworkService,
//            cacheService: mockCacheService
//        )
//    }
//    
//    override func tearDown() {
//        repository = nil
//        mockNetworkService = nil
//        mockCacheService = nil
//        super.tearDown()
//    }
//    
//    // MARK: - Top News Tests
//    
//    func testGetTopNewsFromCache() async throws {
//        // Given
//        mockCacheService.fetchNewsResult = CachedNews(
//            query: "test_cache_key",
//            data: testNewsResponse,
//            expireTime: Date().addingTimeInterval(3600)
//        
//        // When
//        let response = try await repository.getTopNews(
//            language: "en",
//            category: "technology",
//            pageSize: 10,
//            page: 1
//        )
//        
//        // Then
//        XCTAssertEqual(response.articles.count, 3)
//        XCTAssertTrue(mockNetworkService.requestCalled == false)
//    }
//    
//    func testGetTopNewsFromNetworkWhenCacheExpired() async throws {
//        // Given
//        mockCacheService.fetchNewsResult = CachedNews(
//            query: "test_cache_key",
//            data: testNewsResponse,
//            expireTime: Date().addingTimeInterval(-3600)) // Expired
//        mockNetworkService.requestResult = .success(testNewsResponse)
//        
//        // When
//        let response = try await repository.getTopNews(
//            language: "en",
//            category: "technology",
//            pageSize: 10,
//            page: 1
//        )
//        
//        // Then
//        XCTAssertEqual(response.articles.count, 3)
//        XCTAssertTrue(mockNetworkService.requestCalled)
//        XCTAssertTrue(mockCacheService.cacheNewsCalled)
//    }
//    
//    func testGetTopNewsFromNetworkWhenNoCache() async throws {
//        // Given
//        mockCacheService.fetchNewsResult = nil
//        mockNetworkService.requestResult = .success(testNewsResponse)
//        
//        // When
//        let response = try await repository.getTopNews(
//            language: "en",
//            category: "technology",
//            pageSize: 10,
//            page: 1
//        )
//        
//        // Then
//        XCTAssertEqual(response.articles.count, 3)
//        XCTAssertTrue(mockNetworkService.requestCalled)
//        XCTAssertTrue(mockCacheService.cacheNewsCalled)
//    }
//    
//    func testGetTopNewsNetworkFailure() async {
//        // Given
//        mockCacheService.fetchNewsResult = nil
//        mockNetworkService.requestResult = .failure(NetworkServiceError.invalidResponse)
//        
//        // When/Then
//        do {
//            _ = try await repository.getTopNews(
//                language: "en",
//                category: "technology",
//                pageSize: 10,
//                page: 1
//            )
//            XCTFail("Should have thrown an error")
//        } catch {
//            XCTAssertTrue(error is NetworkServiceError)
//        }
//    }
//    
//    // MARK: - Search News Tests
//    
//    func testGetSearchNews() async throws {
//        // Given
//        mockNetworkService.requestResult = .success(testNewsResponse)
//        
//        // When
//        let response = try await repository.getSearchNews(
//            language: "en",
//            searchText: "test",
//            pageSize: 10,
//            page: 1
//        )
//        
//        // Then
//        XCTAssertEqual(response.articles.count, 3)
//        XCTAssertTrue(mockNetworkService.requestCalled)
//        XCTAssertFalse(mockCacheService.cacheNewsCalled) // Search shouldn't be cached
//    }
//    
//    func testInvalidateCache() {
//        // Given
//        let expectation = XCTestExpectation(description: "Cache invalidation")
//        mockCacheService.invalidateCacheCalled = {
//            expectation.fulfill()
//        }
//        
//        // When
//        repository.invalidateCache(for: "en", category: "technology")
//        
//        // Then
//        wait(for: [expectation], timeout: 1.0)
//    }
//    
//    // MARK: - Cache Key Generation Tests
//    
//    func testCacheKeyGeneration() {
//        // Given
//        let language = "en"
//        let category = "technology"
//        let pageSize = 10
//        let page = 1
//        
//        // When
//        let key = repository.generateCacheKey(
//            language: language,
//            category: category,
//            pageSize: pageSize,
//            page: page
//        )
//        
//        // Then
//        XCTAssertFalse(key.isEmpty)
//        XCTAssertNotEqual(key, "en_technology_10_1") // Should be hashed
//    }
//}
//
//// MARK: - Mock Services
//
//class MockNetworkService: NetworkServiceProtocol {
//    var requestCalled = false
//    var requestResult: Result<NewsResponse, Error> = .success(NewsResponse(status: "ok", totalResults: 0, articles: []))
//    
//    func request<T>(endpoint: Endpoint) async throws -> T where T : Decodable {
//        requestCalled = true
//        switch requestResult {
//        case .success(let response):
//            guard let typedResponse = response as? T else {
//                throw NetworkServiceError.decodingFailed
//            }
//            return typedResponse
//        case .failure(let error):
//            throw error
//        }
//    }
//}
//
//class MockCoreDataService: CoreDataServiceProtocol {
//    var fetchNewsResult: CachedNews?
//    var cacheNewsCalled = false
//    var invalidateCacheCalled: (() -> Void)?
//    
//    func fetchNews(query: String) async -> CachedNews? {
//        return fetchNewsResult
//    }
//    
//    func cacheNews(query: String, page: Int, pageSize: Int, data: NewsResponse) async {
//        cacheNewsCalled = true
//    }
//    
//    func invalidateCache(withPrefix prefix: String) async {
//        invalidateCacheCalled?()
//    }
//}
