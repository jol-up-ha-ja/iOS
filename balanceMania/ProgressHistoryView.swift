//
//  ProgressHistoryView.swift
//  balanceMania
//
//  Created by 반성준 on 11/13/24.
//

import SwiftUI

struct ProgressHistoryView: View {
    @ObservedObject var viewModel = ProgressViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("진행 상황 히스토리")
                .font(.title)
                .padding()

            List(viewModel.historyData) { entry in
                VStack(alignment: .leading, spacing: 8) {
                    Text("진행률: \(entry.progressPercentage)%")
                        .font(.headline)
                    Text("날짜: \(entry.date)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .onAppear {
                viewModel.fetchProgressHistory()
            }
        }
    }
}
