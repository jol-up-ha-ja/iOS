//
//  TokenRefreshRequest.swift
//  balanceMania
//
//  Created by 반성준 on 11/10/24.
//

import Foundation

struct TokenRefreshRequest: Encodable {
    let accessToken: String
    let refreshToken: String
}