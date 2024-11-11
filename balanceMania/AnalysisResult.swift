//
//  AnalysisResult.swift
//  balanceMania
//
//  Created by 반성준 on 11/11/24.
//

import Foundation

struct AnalysisResult: Decodable {
    let frontShoulderAngle: Int
    let frontPelvisAngle: Int
    let frontKneeAngle: Int
    let sideNeckAngle: Int
    let sideBodyAngle: Int
}

struct AnalysisRequest: Encodable {
    let frontImgKey: String
    let sideImgKey: String
    let leftWeight: Int
    let rightWeight: Int
}
