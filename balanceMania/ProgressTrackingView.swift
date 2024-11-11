// ProgressTrackingView.swift

import SwiftUI

struct ProgressTrackingView: View {
    @State private var progressData: ProgressTrackingResponse?
    @State private var isLoading = true

    var body: some View {
        VStack(spacing: 30) {
            Text("진행 상황 추적")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color("AccentColor"))
                .padding(.top, 40)
            
            if isLoading {
                ProgressView("진행 상황을 불러오는 중...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .foregroundColor(.gray)
                    .padding()
            } else if let data = progressData {
                VStack(spacing: 20) {
                    Text("진행률")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    ProgressCircleView(progress: data.progressPercentage)
                    
                    Text("최근 업데이트: \(data.lastUpdated)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
            } else {
                Text("진행 상황을 불러오는 중 오류가 발생했습니다.")
                    .foregroundColor(.red)
            }

            Button(action: fetchProgressData) {
                Text("진행 상황 갱신")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal)
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .onAppear(perform: fetchProgressData)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }

    func fetchProgressData() {
        isLoading = true
        let endpoint = "http://13.125.96.48/api/v1/progress"
        
        APIClient.request(endpoint: endpoint, method: .GET, body: nil as String?) { (result: Result<ProgressTrackingResponse, Error>) in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let data):
                    self.progressData = data
                case .failure(let error):
                    print("진행 상황 데이터 로드 실패: \(error)")
                }
            }
        }
    }
}

struct ProgressCircleView: View {
    var progress: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 12)
                .foregroundColor(Color.blue.opacity(0.2))
                .frame(width: 150, height: 150)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress) / 100)
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(.degrees(-90))
                .frame(width: 150, height: 150)
                .animation(.easeOut(duration: 0.8), value: progress)
            
            Text("\(progress)%")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
        }
    }
}
