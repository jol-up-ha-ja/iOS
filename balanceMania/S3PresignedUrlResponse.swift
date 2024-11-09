//
//  S3PresignedUrlResponse.swift
//  balanceMania
//
//  Created by 반성준 on 11/8/24.
//

import Foundation

struct S3PresignedUrlResponse: Decodable {
    let url: String
    let exp: String
    let key: String
}
