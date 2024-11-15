// S3PresignedUrlResponse.swift

import Foundation

struct S3PresignedUrlResponse: Decodable {
    let url: String
    let exp: String
    let key: String
}
