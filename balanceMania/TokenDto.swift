//
//  TokenDto.swift
//  balanceMania
//
//  Created by 반성준 on 11/10/24.
//

import Foundation

struct TokenDto: Decodable {
    let accessToken: String
    let accessTokenExp: String
    let refreshToken: String
    let refreshTokenExp: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accessTokenExp = "access_token_exp"
        case refreshToken = "refresh_token"
        case refreshTokenExp = "refresh_token_exp"
    }
}
