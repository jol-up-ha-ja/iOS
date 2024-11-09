import Foundation
import KakaoSDKAuth
import KakaoSDKUser

class AuthManager: ObservableObject {
    @Published var loginStatus: String = "로그인 필요"
    @Published var accessToken: String?
    
    func loginWithKakao(completion: @escaping (Bool) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                self.handleLoginResult(oauthToken: oauthToken, error: error, completion: completion)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                self.handleLoginResult(oauthToken: oauthToken, error: error, completion: completion)
            }
        }
    }
    
    private func handleLoginResult(oauthToken: OAuthToken?, error: Error?, completion: @escaping (Bool) -> Void) {
        if let error = error {
            print("카카오 로그인 실패: \(error.localizedDescription)")
            self.loginStatus = "로그인 실패"
            completion(false)
        } else if let oauthToken = oauthToken {
            print("카카오 로그인 성공")
            self.accessToken = oauthToken.accessToken
            self.checkUserRegistration(accessToken: oauthToken.accessToken, completion: completion)
        }
    }
    
    private func checkUserRegistration(accessToken: String, completion: @escaping (Bool) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/oauth/KAKAO/sign-up/valid?accessToken=\(accessToken)"
        
        APIClient.request(endpoint: endpoint, method: .GET, body: nil as String?) { (result: Result<RegisterCheckResponse, Error>) in
            switch result {
            case .success(let response):
                if response.canRegister {
                    print("회원가입 필요: 회원가입을 진행합니다.")
                    self.registerUser(accessToken: accessToken, completion: completion)
                } else {
                    self.loginStatus = "이미 가입된 유저"
                    print("이미 가입된 유저입니다.")
                    completion(true)
                }
            case .failure(let error):
                print("회원가입 체크 실패: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func registerUser(accessToken: String, completion: @escaping (Bool) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/oauth/KAKAO/sign-up"
        let body = RegisterRequest(name: "홍길동", gender: "M", birth: 19900101)
        
        APIClient.request(endpoint: endpoint, method: .POST, body: body) { (result: Result<OAuthTokenResponse, Error>) in
            switch result {
            case .success(let response):
                print("서버 응답 성공: \(response)")
                if let token = response.accessToken {
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    self.loginStatus = "회원가입 성공"
                    completion(true)
                } else {
                    print("accessToken이 응답에 없음.")
                    completion(false)
                }
            case .failure(let error):
                print("회원가입 실패: \(error)")
                completion(false)
            }
        }
    }
}
