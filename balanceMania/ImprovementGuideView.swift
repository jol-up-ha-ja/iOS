import SwiftUI

struct ImprovementGuideView: View {
    @State private var guideList: [ExerciseGuide] = []

    var body: some View {
        VStack {
            Text("개선 가이드")
                .font(.title)
                .padding()
            
            if guideList.isEmpty {
                Text("맞춤형 운동 가이드를 불러오는 중...")
                    .foregroundColor(.gray)
            } else {
                List(guideList) { guide in
                    VStack(alignment: .leading) {
                        Text(guide.name)
                            .font(.headline)
                        Text("설명: \(guide.description)")
                        Text("반복 횟수: \(guide.repetitions)")
                        Text("추천 시간: \(guide.duration)분")
                    }
                }
            }
        }
        .onAppear(perform: fetchImprovementGuides)
    }
    
    func fetchImprovementGuides() {
        let endpoint = "http://13.125.96.48/api/v1/guides/improvements"
        
        APIClient.request(endpoint: endpoint, method: .GET, body: nil as String?) { (result: Result<[ExerciseGuide], Error>) in
            switch result {
            case .success(let guides):
                self.guideList = guides
                print("개선 가이드 불러오기 성공: \(guides)")
            case .failure(let error):
                print("개선 가이드 불러오기 실패: \(error)")
            }
        }
    }
}

struct ExerciseGuide: Identifiable, Decodable {
    let id: Int
    let name: String
    let description: String
    let repetitions: Int
    let duration: Int
}
