//
//  balanceManiaApp.swift
//  balanceMania
//
//  Created by 반성준 on 10/26/24.
//

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
                    // URL이 KakaoSDK의 로그인 요청에서 온 경우 처리
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}

