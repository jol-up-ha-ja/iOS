//
//  balanceManiaApp.swift
//  balanceMania
//
//  Created by 반성준 on 10/26/24.
//

import SwiftUI
import KakaoSDKCommon

@main
struct balanceManiaApp: App {
    init() {
        let kakaoAppKey = "051711b84a3fedf77ef33eea7934dd9b" // Environment 설정 권장
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }

    var body: some Scene {
        WindowGroup {	
            ContentView()
        }
    }
}


	
