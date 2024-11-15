// BodyAnalysisView.swift

import SwiftUI
import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import AVFoundation

struct BodyAnalysisView: View {
    @State private var frontImg: UIImage?
    @State private var sideImg: UIImage?
    @State private var analysisResult: AnalysisResult?
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var currentCameraPosition: CameraPosition = .front
    @State private var accessToken: String?

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
                        handleCameraPermission {
                            showImagePicker = true
                        }
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
                        handleCameraPermission {
                            showImagePicker = true
                        }
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
            validateTokenAndRefreshIfNeeded()
        }
    }

    // MARK: - Camera Permission Handler
    func handleCameraPermission(completion: @escaping () -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            completion()
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        completion()
                    } else {
                        print("카메라 접근이 거부되었습니다.")
                    }
                }
            }
        } else {
            print("카메라 접근이 거부되었습니다. 설정에서 권한을 활성화하세요.")
        }
    }

    // MARK: - Access Token Validation
    func validateTokenAndRefreshIfNeeded() {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("Access Token이 없습니다. 로그인 필요.")
            initiateKakaoLogin()
            return
        }

        UserApi.shared.accessTokenInfo { _, error in
            if let error = error as? SdkError, error.isInvalidTokenError() {
                print("유효하지 않은 Access Token, 갱신 시도 중...")
                refreshToken()
            } else if let error = error {
                print("Access Token 확인 실패: \(error.localizedDescription)")
                initiateKakaoLogin()  // 검사 실패 시 로그인 시도
            } else {
                print("✅ 유효한 Access Token이 확인되었습니다.")
                accessToken = token
            }
        }
    }

    func refreshToken() {
        AuthApi.shared.refreshToken { oauthToken, error in
            if let error = error {
                print("토큰 갱신 실패: \(error.localizedDescription). 로그인을 다시 시도합니다.")
                initiateKakaoLogin()
            } else if let oauthToken = oauthToken {
                accessToken = oauthToken.accessToken
                UserDefaults.standard.set(oauthToken.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(oauthToken.refreshToken, forKey: "refreshToken")
                print("✅ 토큰 갱신 성공. 새로운 Access Token: \(oauthToken.accessToken)")
            }
        }
    }

    func initiateKakaoLogin() {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                print("카카오 로그인 실패: \(error.localizedDescription)")
            } else if let oauthToken = oauthToken {
                accessToken = oauthToken.accessToken
                UserDefaults.standard.set(oauthToken.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(oauthToken.refreshToken, forKey: "refreshToken")
                print("✅ 카카오 로그인 성공. Access Token: \(oauthToken.accessToken)")
            }
        }
    }

    // MARK: - Body Analysis Request
    func analyzeBody() {
        guard let frontImageData = frontImg?.jpegData(compressionQuality: 0.8),
              let sideImageData = sideImg?.jpegData(compressionQuality: 0.8),
              let _ = accessToken else {
            print("이미지 또는 Access Token이 없습니다.")
            return
        }

        let imgType = "JPG"

        APIClient.getPresignedURL(imgType: imgType) { frontResult in
            switch frontResult {
            case .success(let frontPresignedResponse):
                APIClient.uploadImage(data: frontImageData, to: frontPresignedResponse.url) { frontUploadResult in
                    switch frontUploadResult {
                    case .success:
                        APIClient.getPresignedURL(imgType: imgType) { sideResult in
                            switch sideResult {
                            case .success(let sidePresignedResponse):
                                APIClient.uploadImage(data: sideImageData, to: sidePresignedResponse.url) { sideUploadResult in
                                    switch sideUploadResult {
                                    case .success:
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
                                                print("✅ 체형 분석 결과: \(analysis)")
                                            case .failure(let error):
                                                print("❌ 체형 분석 실패: \(error)")
                                            }
                                        }
                                    case .failure(let error):
                                        print("❌ 측면 이미지 업로드 실패: \(error)")
                                    }
                                }
                            case .failure(let error):
                                print("❌ 측면 Presigned URL 발급 실패: \(error)")
                            }
                        }
                    case .failure(let error):
                        print("❌ 정면 이미지 업로드 실패: \(error)")
                    }
                }
            case .failure(let error):
                print("❌ 정면 Presigned URL 발급 실패: \(error)")
            }
        }
    }
}
