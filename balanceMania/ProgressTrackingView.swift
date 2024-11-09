import SwiftUI

struct ProgressTrackingView: View {
    @State private var progressData: ProgressTrackingResponse?

    var body: some View {
        VStack {
            Text("진행 상황 추적")
                .font(.largeTitle)
                .padding()

            if let data = progressData {
                VStack(alignment: .leading) {
                    Text("진행률: \(data.progressPercentage)%")
                    Text("최근 업데이트: \(data.lastUpdated)")
                }
                .padding()
            } else {
                Text("진행 상황을 불러오는 중...")
                    .foregroundColor(.gray)
            }

            Button(action: fetchProgressData) {
                Text("진행 상황 갱신")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    func fetchProgressData() {
        let endpoint = "http://13.125.96.48/api/v1/progress"
        
        APIClient.request(endpoint: endpoint, method: .GET, body: nil as String?) { (result: Result<ProgressTrackingResponse, Error>) in
            switch result {
            case .success(let data):
                self.progressData = data
                print("진행 상황 데이터: \(data)")
            case .failure(let error):
                print("진행 상황 데이터 로드 실패: \(error)")
            }
        }
    }
}
