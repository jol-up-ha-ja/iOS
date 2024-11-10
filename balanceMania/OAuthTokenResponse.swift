// OAuthTokenResponse.swift
import Foundation

// 로그인 및 회원가입 응답 모델
struct OAuthTokenResponse: Decodable {
    let accessToken: String? // 옵셔널로 수정
    let refreshToken: String?
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
