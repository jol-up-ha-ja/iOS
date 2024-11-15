//AuthManager
import Foundation
import KakaoSDKAuth
import KakaoSDKUser

class AuthManager: ObservableObject {
    static let shared = AuthManager()  // 싱글톤 인스턴스

    @Published var loginStatus: String = "로그인 필요"
    @Published var accessToken: String?

    private init() {
        self.accessToken = UserDefaults.standard.string(forKey: "accessToken")
        self.loginStatus = accessToken != nil ? "로그인 완료" : "로그인 필요"
    }

    func loginWithKakao(completion: @escaping (Bool) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                guard let self = self else { return }
                if let error = error {
                    print("카카오톡 앱을 통한 로그인 실패: \(error.localizedDescription)")
                    self.loginWithKakaoAccount(completion: completion)
                } else if let oauthToken = oauthToken {
                    self.handleLoginResult(oauthToken: oauthToken, completion: completion)
                }
            }
        } else {
            loginWithKakaoAccount(completion: completion)
        }
    }

    private func loginWithKakaoAccount(completion: @escaping (Bool) -> Void) {
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            if let error = error {
                print("웹 브라우저를 통한 로그인 실패: \(error.localizedDescription)")
                completion(false)
            } else if let oauthToken = oauthToken {
                self.handleLoginResult(oauthToken: oauthToken, completion: completion)
            }
        }
    }

    private func handleLoginResult(oauthToken: OAuthToken?, completion: @escaping (Bool) -> Void) {
        guard let oauthToken = oauthToken else {
            print("카카오 로그인 실패: 토큰이 존재하지 않습니다.")
            self.loginStatus = "로그인 실패"
            completion(false)
            return
        }
        print("카카오 로그인 성공: 토큰 발급됨")
        self.accessToken = oauthToken.accessToken
        UserDefaults.standard.set(oauthToken.accessToken, forKey: "accessToken")
        UserDefaults.standard.set(oauthToken.refreshToken, forKey: "refreshToken")
        UserDefaults.standard.synchronize()
        completion(true)
    }

    func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let storedRefreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            print("갱신할 refreshToken이 없습니다. 로그아웃 처리 중...")
            logout()
            completion(false)
            return
        }

        AuthApi.shared.refreshToken { (oauthToken, error) in
            if let error = error {
                print("토큰 갱신 실패: \(error.localizedDescription). 로그아웃 필요.")
                self.logout()
                completion(false)
            } else if let oauthToken = oauthToken {
                print("✅ 토큰 갱신 성공")
                UserDefaults.standard.set(oauthToken.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(oauthToken.refreshToken, forKey: "refreshToken")
                UserDefaults.standard.synchronize()
                self.accessToken = oauthToken.accessToken
                completion(true)
            }
        }
    }

    private func logout() {
        print("사용자 로그아웃 처리")
        self.accessToken = nil
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        self.loginStatus = "로그인 필요"
    }
}
