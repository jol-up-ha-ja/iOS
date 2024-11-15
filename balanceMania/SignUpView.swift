//SignUpView.swift
import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var gender: String = "M"
    @State private var birth: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // 타이틀
            Text("회원가입 정보 입력")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(Color("AccentColor"))
                .padding(.top, 30)
            
            // 이름 입력 필드
            VStack(alignment: .leading, spacing: 5) {
                Text("이름")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                TextField("이름을 입력하세요", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            
            // 성별 선택
            VStack(alignment: .leading, spacing: 5) {
                Text("성별")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Picker("성별", selection: $gender) {
                    Text("남성").tag("M")
                    Text("여성").tag("F")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            }
            
            // 생년월일 입력 필드
            VStack(alignment: .leading, spacing: 5) {
                Text("생년월일")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                TextField("YYYYMMDD 형식으로 입력하세요", text: $birth)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(.horizontal)
            }
            
            // 회원가입 완료 버튼
            Button(action: registerUser) {
                Text("회원가입 완료")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
    
    func registerUser() {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let endpoint = "http://13.125.96.48/api/v1/oauth/KAKAO/sign-up?accessToken=\(accessToken)"
        let requestBody = RegisterRequest(name: name, gender: gender, birth: Int(birth) ?? 0)
        
        APIClient.request(endpoint: endpoint, method: .POST, body: requestBody) { (result: Result<OAuthTokenResponse, Error>) in
            switch result {
            case .success(let response):
                UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
                print("회원가입 성공")
            case .failure(let error):
                print("회원가입 실패: \(error)")
            }
        }
    }
}

