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

    // CodingKeys로 JSON 키와 구조체 필드를 명시적으로 매핑
    enum CodingKeys: String, CodingKey {
        case id
        case frontShoulderAngle = "frontShoulderAngle"
        case frontPelvisAngle = "frontPelvisAngle"
        case frontKneeAngle = "frontKneeAngle"
        case frontAnkleAngle = "frontAnkleAngle"
        case sideNeckAngle = "sideNeckAngle"
        case sideBodyAngle = "sideBodyAngle"
        case leftWeight = "leftWeight"
        case rightWeight = "rightWeight"
        case createdAt = "createdAt"
        case modifiedAt = "modifiedAt"
    }

    // 기본값 설정을 위한 초기화 메서드
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

// 빈 응답을 위한 모델
struct EmptyResponse: Decodable {}

// 균형 정보 생성 요청 모델
struct CreateBalanceRequest: Encodable {
    let frontImgKey: String
    let sideImgKey: String
}

// 무게 정보 요청 모델
struct WeightRequest: Encodable {
    let leftWeight: Int
    let rightWeight: Int
}
