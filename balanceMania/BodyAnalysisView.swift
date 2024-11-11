import SwiftUI
import UIKit
import KakaoSDKAuth

struct BodyAnalysisView: View {
    @State private var frontImg: UIImage?
    @State private var sideImg: UIImage?
    @State private var analysisResult: AnalysisResult?
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var currentCameraPosition: CameraPosition = .front
    @State private var accessToken: String? // Access Token 상태 관리
    
    var body: some View {
        VStack(spacing: 30) {
            Text("체형 분석")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color("AccentColor"))
                .padding(.top, 40)
                .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
            
            HStack(spacing: 20) {
                ImageSelectionView(title: "정면 사진", image: frontImg)
                ImageSelectionView(title: "측면 사진", image: sideImg)
            }
            .padding(.horizontal)
            
            VStack(spacing: 15) {
                HStack {
                    CaptureButton(title: "정면 사진 촬영", color: .blue) {
                        currentCameraPosition = .front
                        sourceType = .camera
                        showImagePicker = true
                    }
                    CaptureButton(title: "정면 사진 선택", color: .blue) {
                        currentCameraPosition = .front
                        sourceType = .photoLibrary
                        showImagePicker = true
                    }
                }
                
                HStack {
                    CaptureButton(title: "측면 사진 촬영", color: .green) {
                        currentCameraPosition = .side
                        sourceType = .camera
                        showImagePicker = true
                    }
                    CaptureButton(title: "측면 사진 선택", color: .green) {
                        currentCameraPosition = .side
                        sourceType = .photoLibrary
                        showImagePicker = true
                    }
                }
            }
            .padding(.horizontal)
            
            Button(action: analyzeBody) {
                Text("분석 시작")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.orange.opacity(0.4), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            if let result = analysisResult {
                AnalysisResultView(result: result)
                    .padding()
                    .transition(.opacity.combined(with: .slide))
            }
            
            Spacer()
        }
        .padding(.bottom, 40)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: currentCameraPosition == .front ? $frontImg : $sideImg, sourceType: sourceType)
        }
        .onAppear {
            fetchAccessToken()
        }
    }

    // Access Token 가져오기
    func fetchAccessToken() {
        if let token = TokenManager.manager.getToken()?.accessToken {
            accessToken = token
            print("Access Token 가져오기 성공: \(token)")
        } else {
            print("Access Token을 가져오는 데 실패했습니다.")
        }
    }

    func analyzeBody() {
        guard let frontImageData = frontImg?.jpegData(compressionQuality: 0.8),
              let sideImageData = sideImg?.jpegData(compressionQuality: 0.8),
              let token = accessToken else {
            print("이미지 또는 Access Token이 없습니다.")
            return
        }
        
        // 정면 이미지 Presigned URL 요청 및 업로드
        APIClient.getPresignedURL(imgType: "jpg", accessToken: token) { frontResult in
            switch frontResult {
            case .success(let frontPresignedResponse):
                APIClient.uploadImage(data: frontImageData, to: frontPresignedResponse.url) { frontUploadResult in
                    switch frontUploadResult {
                    case .success:
                        // 측면 이미지 Presigned URL 요청 및 업로드
                        APIClient.getPresignedURL(imgType: "jpg", accessToken: token) { sideResult in
                            switch sideResult {
                            case .success(let sidePresignedResponse):
                                APIClient.uploadImage(data: sideImageData, to: sidePresignedResponse.url) { sideUploadResult in
                                    switch sideUploadResult {
                                    case .success:
                                        // 서버에 분석 요청
                                        let endpoint = "http://13.125.96.48/api/v1/balances"
                                        let body = AnalysisRequest(
                                            frontImgKey: frontPresignedResponse.key,
                                            sideImgKey: sidePresignedResponse.key,
                                            leftWeight: 0,
                                            rightWeight: 0
                                        )
                                        APIClient.request(endpoint: endpoint, method: .POST, body: body) { (result: Result<AnalysisResult, Error>) in
                                            switch result {
                                            case .success(let analysis):
                                                self.analysisResult = analysis
                                                print("체형 분석 결과: \(analysis)")
                                            case .failure(let error):
                                                print("체형 분석 실패: \(error)")
                                            }
                                        }
                                    case .failure(let error):
                                        print("측면 이미지 업로드 실패: \(error)")
                                    }
                                }
                            case .failure(let error):
                                print("측면 Presigned URL 발급 실패: \(error)")
                            }
                        }
                    case .failure(let error):
                        print("정면 이미지 업로드 실패: \(error)")
                    }
                }
            case .failure(let error):
                print("정면 Presigned URL 발급 실패: \(error)")
            }
        }
    }
}
