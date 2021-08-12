//
//  SettingsView.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/27.
//

import SwiftUI

extension SettingsView {
    func listItem(title: String, content: String = "") -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .foregroundColor(Color("Text"))
                    .font(.system(size: 16, weight: .semibold))
                if content.count > 0 {
                    Text(content)
                        .foregroundColor(Color("SubText"))
                        .font(.system(size: 14))
                }
            }
            Spacer()
        }
        .padding([.leading, .trailing], 20)
        .frame(height: 64)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
    
    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image("ArrowBack")
                .resizable()
                .frame(width: 10, height: 17)
                .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 6))
        }
    }
}

struct SettingsView: View {
    @Environment(\.viewController) var viewController
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                viewModel.showLogoutAlert = true
            }) {
                listItem(title: "로그아웃")
            }
            .padding(.bottom, 10)
            
            listItem(title: "제작자", content: "WAFFLE STUDIO, JOO")
            listItem(title: "문제 발생시 연락처", content: "010-0000-0000")
            
            Spacer()
        }
        .navigationBar(leadingItem: backButton)
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.bottom)
        .alertModal(
            isActive: $viewModel.showLogoutAlert,
            content: "정말 로그아웃 하시겠습니까?",
            onAck: {
                viewModel.logout()
            }, onCancel: {
                viewModel.showLogoutAlert = false
            }
        )
        .onAppear {
            viewModel.onLoggedOut = presentLogin
        }
    }
    
    func presentLogin() {
        viewController?.present(style: .fullScreen) {
            LoginView().environmentObject(AppState.shared)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
