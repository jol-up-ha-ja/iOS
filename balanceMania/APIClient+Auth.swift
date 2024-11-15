// APIClient+Auth.swift
import Foundation

extension APIClient {
    static func logout(completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/auth/logout"
        request(endpoint: endpoint, method: .POST, completion: completion)
    }
    
    static func tokenRefresh(accessToken: String, refreshToken: String, completion: @escaping (Result<TokenDto, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/auth/token/refresh"
        let requestBody = TokenRefreshRequest(accessToken: accessToken, refreshToken: refreshToken)
        request(endpoint: endpoint, method: .POST, body: requestBody) { (result: Result<TokenDto, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let tokenDto):
                    // 새로운 토큰 저장
                    UserDefaults.standard.set(tokenDto.accessToken, forKey: "accessToken")
                    UserDefaults.standard.set(tokenDto.refreshToken, forKey: "refreshToken")
                    print("토큰 갱신 성공: \(tokenDto.accessToken)")
                    completion(.success(tokenDto))
                case .failure(let error):
                    print("토큰 갱신 실패: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func withdraw(completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/auth/withdraw"
        request(endpoint: endpoint, method: .POST, completion: completion)
    }
}
