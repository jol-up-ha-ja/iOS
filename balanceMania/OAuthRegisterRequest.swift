// OAuthRegisterRequest.swift

import Foundation

struct OAuthRegisterRequest: Encodable {
    let name: String
    let gender: String
    let birth: Int
}
