import Foundation

extension APIClient {
    // 로그아웃
    static func logout(completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/auth/logout"
        request(endpoint: endpoint, method: .POST, completion: completion)
    }
    
    // 토큰 재발급
    static func tokenRefresh(accessToken: String, refreshToken: String, completion: @escaping (Result<TokenDto, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/auth/token/refresh"
        let requestBody = TokenRefreshRequest(accessToken: accessToken, refreshToken: refreshToken)
        request(endpoint: endpoint, method: .POST, body: requestBody, completion: completion)
    }
    
    // 회원 탈퇴
    static func withdraw(completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/auth/withdraw"
        request(endpoint: endpoint, method: .POST, completion: completion)
    }
}
