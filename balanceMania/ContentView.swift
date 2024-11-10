import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser

struct ContentView: View {
    @State private var userInfo: UserInfo?
    @State private var loginStatus = "로그인 필요"
    @State private var isSignedUp = false
    @State private var showMainView = false
    
    var body: some View {
        if showMainView {
            MainView(userInfo: userInfo) // 메인 화면으로 이동
        } else {
            VStack(spacing: 30) {
                // 앱 타이틀과 소개 문구
                VStack(spacing: 8) {
                    Text("BalanceMania")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Color("AccentColor"))
                    
                    Text("빠르고 정확한 체형 분석으로 건강을 지키세요!")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 50)
                
                // 로그인 상태 표시
                Text(loginStatus)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(loginStatus == "로그인 실패" ? .red : .gray)
                
                // 카카오 로그인 버튼
                Button(action: loginWithKakao) {
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                        Text("카카오로 로그인")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(12)
                    .shadow(color: Color.yellow.opacity(0.3), radius: 6, x: 0, y: 4)
                }
                .padding(.horizontal, 30)
                
                // 로그인 후 사용자 정보 표시
                if let userInfo = userInfo {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("환영합니다, \(userInfo.name)님!")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color("AccentColor"))
                        Text("성별: \(userInfo.gender)")
                        Text("생일: \(userInfo.birth)")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.vertical, 40)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(.systemGroupedBackground), Color(.systemBackground)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
    
    func loginWithKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                handleLoginResult(oauthToken: oauthToken, error: error)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                handleLoginResult(oauthToken: oauthToken, error: error)
            }
        }
    }
    
    func handleLoginResult(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            print("카카오 로그인 실패: \(error.localizedDescription)")
            loginStatus = "로그인 실패"
        } else if oauthToken != nil {
            print("카카오 로그인 성공")
            loginStatus = "로그인 성공"
            self.showMainView = true // 로그인 성공 시 메인 화면으로 전환
        }
    }
}
