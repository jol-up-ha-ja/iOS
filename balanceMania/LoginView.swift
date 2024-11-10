import SwiftUI

struct LoginView: View {
    @ObservedObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("BalanceMania")
                        .font(.system(size: 42, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 5)
                        .padding(.top, 60)
                        .scaleEffect(1.05)
                        
                    
                    Text("균형 잡힌 체형을 위한 전문가 분석")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 50)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                Text(authManager.loginStatus)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 10)
                    .opacity(authManager.loginStatus == "로그인 필요" ? 0.6 : 1.0)
                    .transition(.opacity.combined(with: .scale))
                  
                
                Button(action: {
                    authManager.loginWithKakao { success in
                        if success {
                            print("로그인 성공")
                        } else {
                            print("로그인 실패")
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        Text("카카오로 로그인")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange.opacity(0.8)]),
                                       startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 30)
                }
                .padding(.top, 30)
                
                VStack(spacing: 10) {
                    Text("BalanceMania와 함께, 건강한 삶을 시작하세요")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 20)
                    
                    Text("빠르고 정확한 체형 분석과 건강 가이드 제공")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
            }
            .padding(.bottom, 40)
        }
    }
}

// Preview 설정
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authManager: AuthManager())
            .previewDevice("iPhone 12")
            .environment(\.colorScheme, .dark)
    }
}
