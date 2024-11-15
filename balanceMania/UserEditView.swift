//
//  UserEditView.swift
//  balanceMania
//
//  Created by 반성준 on 11/13/24.
//

import SwiftUI

struct UserEditView: View {
    @State var userInfo: UserInfo
    @ObservedObject var viewModel: UserInfoViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("정보 수정")
                .font(.system(size: 28, weight: .bold))
                .padding()

            VStack(alignment: .leading, spacing: 10) {
                Text("이름")
                TextField("이름을 입력하세요", text: $userInfo.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 10) {
                Text("성별")
                Picker("성별", selection: $userInfo.gender) {
                    Text("남성").tag("M")
                    Text("여성").tag("F")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 10) {
                Text("생년월일")
                TextField("YYYYMMDD 형식으로 입력하세요", text: $userInfo.birth)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
            .padding(.horizontal)

            Button("저장") {
                viewModel.updateUserInfo(userInfo)
                viewModel.isEditing = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.top, 20)

            Spacer()
        }
        .padding()
    }
}
