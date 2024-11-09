//
//  BalanceInfo.swift
//  balanceMania
//
//  Created by 반성준 on 10/26/24.
//

import Foundation

struct BalanceInfo: Decodable {
    let id: Int
    let frontShoulderAngle: Int
    let frontPelvisAngle: Int
    let frontKneeAngle: Int
    let frontAnkleAngle: Int
    let sideNeckAngle: Int
    let sideBodyAngle: Int
    let leftWeight: Int
    let rightWeight: Int
    let createdAt: String
    let modifiedAt: String
}
