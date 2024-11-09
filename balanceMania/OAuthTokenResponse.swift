import Foundation

struct OAuthTokenResponse: Decodable {
    let accessToken: String?
    let refreshToken: String?
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
