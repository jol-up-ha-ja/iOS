//
//  UserInfoView.swift
//  balanceMania
//
//  Created by 반성준 on 11/13/24.
//

import SwiftUI

struct UserInfoView: View {
    @ObservedObject var viewModel = UserInfoViewModel()

    var body: some View {
        VStack(spacing: 20) {
            if let userInfo = viewModel.userInfo {
                Text("환영합니다, \(userInfo.name)님!")
                    .font(.title)
                    .padding()

                Text("성별: \(userInfo.gender)")
                Text("생년월일: \(userInfo.birth)")

                Button("정보 수정") {
                    viewModel.isEditing.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .sheet(isPresented: $viewModel.isEditing) {
                    UserEditView(userInfo: userInfo, viewModel: viewModel)
                }
            } else {
                ProgressView("유저 정보를 불러오는 중입니다...")
            }
        }
        .onAppear {
            viewModel.fetchUserInfo()
        }
    }
}
