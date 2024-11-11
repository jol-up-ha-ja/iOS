//
//  AnalysisResultView.swift
//  balanceMania
//
//  Created by 반성준 on 11/11/24.
//

import SwiftUI

struct AnalysisResultView: View {
    var result: AnalysisResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("분석 결과")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            ResultRow(label: "어깨 각도", value: "\(result.frontShoulderAngle)도")
            ResultRow(label: "골반 각도", value: "\(result.frontPelvisAngle)도")
            ResultRow(label: "무릎 각도", value: "\(result.frontKneeAngle)도")
            ResultRow(label: "목 각도", value: "\(result.sideNeckAngle)도")
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}

struct ResultRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
                .bold()
                .foregroundColor(Color("AccentColor"))
        }
    }
}
