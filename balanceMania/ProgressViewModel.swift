//
//  ProgressViewModel.swift
//  balanceMania
//
//  Created by 반성준 on 11/13/24.
//

import Foundation
import Combine

class ProgressViewModel: ObservableObject {
    @Published var historyData: [ProgressEntry] = []

    func fetchProgressHistory() {
        let endpoint = "http://13.125.96.48/api/v1/progress/history"
        
        APIClient.request(endpoint: endpoint, method: .GET, body: nil as String?) { (result: Result<[ProgressEntry], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let entries):
                    self.historyData = entries
                case .failure(let error):
                    print("진행 상황 히스토리 로드 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
