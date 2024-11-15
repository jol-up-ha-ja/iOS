// TokenResponse.swift
// 토큰 갱신 응답 모델

import Foundation

struct TokenResponse: Codable {
    let accessToken: String?
    let refreshToken: String?
    let idToken: String?
    let expiresIn: Int?
    let refreshTokenExpiresIn: Int?
    let errorCode: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
        case expiresIn = "expires_in"
        case refreshTokenExpiresIn = "refresh_token_expires_in"
        case errorCode = "error_code"
    }
}
