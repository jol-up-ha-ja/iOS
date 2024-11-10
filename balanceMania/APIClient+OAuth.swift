// APIClient+OAuth.swift

import Foundation

extension APIClient {
    // 로그인
    static func login(provider: String, accessToken: String, completion: @escaping (Result<OAuthTokenResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/oauth/\(provider)/login"
        let requestBody = OAuthLoginRequest(accessToken: accessToken)
        request(endpoint: endpoint, method: .POST, body: requestBody, completion: completion)
    }
    
    // 회원가입
    static func register(provider: String, accessToken: String, requestBody: OAuthRegisterRequest, completion: @escaping (Result<OAuthTokenResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/oauth/\(provider)/sign-up?accessToken=\(accessToken)"
        request(endpoint: endpoint, method: .POST, body: requestBody, completion: completion)
    }
    
    // 회원가입 유효성 체크
    static func checkRegistration(provider: String, accessToken: String, completion: @escaping (Result<AbleRegisterResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/oauth/\(provider)/sign-up/valid?accessToken=\(accessToken)"
        request(endpoint: endpoint, method: .GET, completion: completion)
    }
}
