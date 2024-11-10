import SwiftUI

struct MainView: View {
    var userInfo: UserInfo?
    
    var body: some View {
        NavigationView {
            ZStack {
                // 블러 효과가 적용된 다크 그라디언트 배경
                LinearGradient(gradient: Gradient(colors: [Color("BackgroundDark"), Color("BackgroundLight")]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 10)
                
                VStack(spacing: 30) {
                    // 상단 소개 섹션
                    VStack(spacing: 8) {
                        Text("BalanceMania")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                            .padding(.top, 40)
                            .scaleEffect(1.05)
                           
                        
                        Text("건강한 삶을 위한 체형 분석 서비스")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 30)
                            .multilineTextAlignment(.center)
                    }
                    
                    // 기능 버튼 섹션
                    VStack(spacing: 20) {
                        MainFeatureButton(
                            title: "체형 분석 시작",
                            backgroundColor: Color.teal,
                            iconName: "figure.walk",
                            destination: BodyAnalysisView()
                        )
                        MainFeatureButton(
                            title: "개선 가이드",
                            backgroundColor: Color.blue,
                            iconName: "list.bullet",
                            destination: ImprovementGuideView()
                        )
                        MainFeatureButton(
                            title: "진행 상황 추적",
                            backgroundColor: Color.orange,
                            iconName: "chart.line.uptrend.xyaxis",
                            destination: ProgressTrackingView()
                        )
                    }
                    
                    // 사용자 환영 메시지 섹션
                    if let userInfo = userInfo {
                        VStack(spacing: 5) {
                            Text("환영합니다, \(userInfo.name)님!")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Text("오늘도 건강한 하루 되세요!")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// 메인 기능 버튼 뷰 컴포넌트
struct MainFeatureButton<Destination: View>: View {
    let title: String
    let backgroundColor: Color
    let iconName: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(backgroundColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: iconName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                
                Spacer()
            }
            .padding(.horizontal, 15)
            .background(backgroundColor)
            .cornerRadius(12)
            .shadow(color: backgroundColor.opacity(0.6), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal)
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userInfo: UserInfo(name: "홍길동"))
            .previewDevice("iPhone 12")
    }
}
