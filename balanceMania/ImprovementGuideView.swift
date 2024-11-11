// ImprovementGuideView.swift

import SwiftUI

struct ImprovementGuideView: View {
    @State private var guideList: [ExerciseGuide] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            Text("개선 가이드")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(Color("AccentColor"))
                .padding(.top, 20)
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
            
            if isLoading {
                ProgressView("맞춤형 운동 가이드를 불러오는 중...")
                    .padding()
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(guideList) { guide in
                            GuideCardView(guide: guide)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.bottom, 20)
        .onAppear(perform: fetchImprovementGuides)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
    
    func fetchImprovementGuides() {
        let endpoint = "http://13.125.96.48/api/v1/guides/improvements"
        
        APIClient.request(endpoint: endpoint, method: .GET, body: nil as String?) { (result: Result<[ExerciseGuide], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let guides):
                    self.guideList = guides
                    self.isLoading = false
                case .failure(let error):
                    print("개선 가이드 불러오기 실패: \(error)")
                    self.isLoading = false
                }
            }
        }
    }
}

struct GuideCardView: View {
    var guide: ExerciseGuide
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(guide.name)
                .font(.headline)
                .foregroundColor(Color("AccentColor"))
            
            Text(guide.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text("반복 횟수: \(guide.repetitions)")
                Spacer()
                Text("추천 시간: \(guide.duration)분")
            }
            .font(.footnote)
            .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        )
    }
}
