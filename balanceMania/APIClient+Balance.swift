// APIClient+Balance.swift
import Foundation

extension APIClient {
    
    // 균형 정보 목록 조회
    static func getBalanceList(page: Int = 0, size: Int = 10, sort: String = "createdAt,desc", completion: @escaping (Result<BalanceListResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/balances?page=\(page)&size=\(size)&sort=\(sort)"
        request(endpoint: endpoint, method: .GET, completion: completion)
    }

    // 균형 정보 단일 조회
    static func getBalanceDetail(balanceId: Int, completion: @escaping (Result<BalanceInfo, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/balances/\(balanceId)"
        request(endpoint: endpoint, method: .GET, completion: completion)
    }

    // 균형 정보 생성
    static func createBalance(requestBody: CreateBalanceRequest, completion: @escaping (Result<BalanceInfo, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/balances"
        request(endpoint: endpoint, method: .POST, body: requestBody, completion: completion)
    }

    // 균형 정보 삭제 (빈 응답 처리)
    static func deleteBalance(balanceId: Int, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/balances/\(balanceId)"
        request(endpoint: endpoint, method: .DELETE, completion: completion)
    }

    // 무게 정보 임시 등록 (빈 응답 처리)
    static func registerWeight(requestBody: WeightRequest, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/balances/weight"
        request(endpoint: endpoint, method: .POST, body: requestBody, completion: completion)
    }
}
