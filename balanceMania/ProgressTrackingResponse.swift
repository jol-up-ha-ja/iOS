// ProgressTrackingResponse.swift

import Foundation

struct ProgressTrackingResponse: Decodable {
    let progressPercentage: Int
    let lastUpdated: String
}
