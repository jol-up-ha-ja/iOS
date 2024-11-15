// APIClient+Balance.swift
import Foundation

// CommonModels.swift 파일을 import합니다.
extension APIClient {
    
    static func getBalanceList(page: Int = 0, size: Int = 10, sort: String = "createdAt,desc", completion: @escaping (Result<BalanceListResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/balances?page=\(page)&size=\(size)&sort=\(sort)"
        request(endpoint: endpoint, method: .GET, completion: completion)
    }

    static func getBalanceDetail(balanceId: Int, completion: @escaping (Result<BalanceInfo, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/balances/\(balanceId)"
        request(endpoint: endpoint, method: .GET, completion: completion)
    }

    static func createBalance(requestBody: CreateBalanceRequest, completion: @escaping (Result<BalanceInfo, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/balances"
        request(endpoint: endpoint, method: .POST, body: requestBody, completion: completion)
    }

    static func deleteBalance(balanceId: Int, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/balances/\(balanceId)"
        request(endpoint: endpoint, method: .DELETE, completion: completion)
    }

    static func registerWeight(requestBody: WeightRequest, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/balances/weight"
        request(endpoint: endpoint, method: .POST, body: requestBody, completion: completion)
    }
}
