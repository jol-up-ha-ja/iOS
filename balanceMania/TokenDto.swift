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
}
