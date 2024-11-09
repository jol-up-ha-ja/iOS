import SwiftUI

struct BodyAnalysisView: View {
    @State private var frontImg: UIImage?
    @State private var sideImg: UIImage?
    @State private var analysisResult: AnalysisResult?
    @State private var showImagePicker = false
    @State private var currentCameraPosition: CameraPosition = .front
    
    var body: some View {
        VStack(spacing: 30) {
            // 타이틀 영역
            Text("체형 분석")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color("AccentColor"))
                .padding(.top, 40)
            
            // 사진 촬영 버튼 섹션
            VStack(spacing: 15) {
                CaptureButton(title: "정면 사진 촬영", color: .blue) {
                    currentCameraPosition = .front
                    showImagePicker = true
                }
                
                CaptureButton(title: "측면 사진 촬영", color: .green) {
                    currentCameraPosition = .side
                    showImagePicker = true
                }
            }
            .padding(.horizontal)
            
            // 분석 시작 버튼
            Button(action: analyzeBody) {
                Text("분석 시작")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.orange.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // 분석 결과 표시 영역
            if let result = analysisResult {
                AnalysisResultView(result: result)
                    .padding()
            }
            
            Spacer()
        }
        .padding(.bottom, 40)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: currentCameraPosition == .front ? $frontImg : $sideImg, sourceType: .camera)
        }
    }

    func analyzeBody() {
        guard let frontImageData = frontImg?.jpegData(compressionQuality: 0.8),
              let sideImageData = sideImg?.jpegData(compressionQuality: 0.8) else {
            print("이미지가 없습니다.")
            return
        }

        let frontImageKey = uploadImageToServer(imageData: frontImageData)
        let sideImageKey = uploadImageToServer(imageData: sideImageData)

        let endpoint = "http://13.125.96.48/api/v1/balances"
        let body = AnalysisRequest(frontImgKey: frontImageKey, sideImgKey: sideImageKey, leftWeight: 0, rightWeight: 0)

        APIClient.request(endpoint: endpoint, method: .POST, body: body) { (result: Result<AnalysisResult, Error>) in
            switch result {
            case .success(let analysis):
                self.analysisResult = analysis
                print("체형 분석 결과: \(analysis)")
            case .failure(let error):
                print("체형 분석 실패: \(error)")
            }
        }
    }
    
    func uploadImageToServer(imageData: Data) -> String {
        // 서버에 이미지를 업로드하고 이미지 키를 반환
        return "이미지_키_예시"
    }
}

// 버튼 컴포넌트
struct CaptureButton: View {
    var title: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: color.opacity(0.3), radius: 5, x: 0, y: 3)
        }
    }
}

// 분석 결과 뷰 컴포넌트
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

// 분석 결과 행
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

// 데이터 모델
enum CameraPosition {
    case front, side
}

struct AnalysisRequest: Encodable {
    let frontImgKey: String
    let sideImgKey: String
    let leftWeight: Int
    let rightWeight: Int
}

struct AnalysisResult: Decodable {
    let frontShoulderAngle: Int
    let frontPelvisAngle: Int
    let frontKneeAngle: Int
    let sideNeckAngle: Int
    let sideBodyAngle: Int
}
