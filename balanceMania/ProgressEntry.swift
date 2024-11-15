//
//  ProgressEntry.swift
//  balanceMania
//
//  Created by 반성준 on 11/13/24.
//
import Foundation

struct ProgressEntry: Identifiable, Decodable {
    let id = UUID()
    let progressPercentage: Int
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case progressPercentage = "progressPercentage"
        case date = "date"
    }
}
