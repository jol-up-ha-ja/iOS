// balanceManiaApp.swift

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct balanceManiaApp: App {
    // Kakao SDK 초기화
    init() {
        let kakaoAppKey = "051711b84a3fedf77ef33eea7934dd9b" // 실제 배포 시에는 Environment 설정 사용 권장
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        // 성공 여부 확인 후 로그 남기기
                        let handled = AuthController.handleOpenUrl(url: url)
                        if handled {
                            print("Kakao login URL handled successfully.")
                        } else {
                            print("Failed to handle Kakao login URL.")
                        }
                    }
                }
        }
    }
}
