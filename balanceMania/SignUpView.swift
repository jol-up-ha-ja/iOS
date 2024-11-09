import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var gender: String = "M"
    @State private var birth: String = ""
    
    var body: some View {
        VStack {
            Text("회원가입 정보 입력")
                .font(.title)
                .padding()
            
            TextField("이름", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Picker("성별", selection: $gender) {
                Text("남성").tag("M")
                Text("여성").tag("F")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TextField("생년월일 (YYYYMMDD)", text: $birth)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            Button(action: registerUser) {
                Text("회원가입 완료")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
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
