// S3PresignedUrlResponse.swift

import Foundation

// S3 Presigned URL 응답을 위한 데이터 모델
struct S3PresignedUrlResponse: Decodable {
    let url: String
    let key: String
}
