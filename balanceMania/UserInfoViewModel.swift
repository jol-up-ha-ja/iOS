//
//  UserInfoViewModel.swift
//  balanceMania
//
//  Created by 반성준 on 11/13/24.
//
import Foundation
import Combine

class UserInfoViewModel: ObservableObject {
    @Published var userInfo: UserInfo?
    @Published var isEditing = false

    func fetchUserInfo() {
        APIClient.request(endpoint: "http://13.125.96.48/api/v1/users/my-info", method: .GET) { (result: Result<UserInfo, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userInfo):
                    self.userInfo = userInfo
                case .failure(let error):
                    print("유저 정보 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    func updateUserInfo(_ userInfo: UserInfo) {
        let endpoint = "http://13.125.96.48/api/v1/users/\(userInfo.id)"
        guard let encodableUserInfo = userInfo as? Encodable else {
            print("유저 정보는 Encodable이어야 합니다.")
            return
        }
        
        APIClient.request(endpoint: endpoint, method: .PATCH, body: encodableUserInfo) { (result: Result<EmptyResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.userInfo = userInfo
                case .failure(let error):
                    print("유저 정보 수정 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
