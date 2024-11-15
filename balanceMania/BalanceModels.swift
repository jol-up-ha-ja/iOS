// BalanceModels.swift
import Foundation

// 균형 정보 모델
struct BalanceInfo: Decodable {
    let id: Int?
    let frontShoulderAngle: Int?
    let frontPelvisAngle: Int?
    let frontKneeAngle: Int?
    let frontAnkleAngle: Int?
    let sideNeckAngle: Int?
    let sideBodyAngle: Int?
    let leftWeight: Int?
    let rightWeight: Int?
    let createdAt: String?
    let modifiedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case frontShoulderAngle
        case frontPelvisAngle
        case frontKneeAngle
        case frontAnkleAngle
        case sideNeckAngle
        case sideBodyAngle
        case leftWeight
        case rightWeight
        case createdAt
        case modifiedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        frontShoulderAngle = try container.decodeIfPresent(Int.self, forKey: .frontShoulderAngle) ?? 0
        frontPelvisAngle = try container.decodeIfPresent(Int.self, forKey: .frontPelvisAngle) ?? 0
        frontKneeAngle = try container.decodeIfPresent(Int.self, forKey: .frontKneeAngle) ?? 0
        frontAnkleAngle = try container.decodeIfPresent(Int.self, forKey: .frontAnkleAngle) ?? 0
        sideNeckAngle = try container.decodeIfPresent(Int.self, forKey: .sideNeckAngle) ?? 0
        sideBodyAngle = try container.decodeIfPresent(Int.self, forKey: .sideBodyAngle) ?? 0
        leftWeight = try container.decodeIfPresent(Int.self, forKey: .leftWeight) ?? 0
        rightWeight = try container.decodeIfPresent(Int.self, forKey: .rightWeight) ?? 0
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        modifiedAt = try container.decodeIfPresent(String.self, forKey: .modifiedAt)
    }
}

// 균형 정보 목록 응답 모델
struct BalanceListResponse: Decodable {
    let data: [BalanceInfo]
    let page: Int
    let size: Int
    let sort: SortObject
    let hasNext: Bool
}

// 정렬 객체 모델
struct SortObject: Decodable {
    let sorted: Bool
    let empty: Bool
    let unsorted: Bool
}

// CreateBalanceRequest 및 WeightRequest 모델
struct CreateBalanceRequest: Encodable {
    let frontImgKey: String
    let sideImgKey: String
}

struct WeightRequest: Encodable {
    let leftWeight: Int
    let rightWeight: Int
}
