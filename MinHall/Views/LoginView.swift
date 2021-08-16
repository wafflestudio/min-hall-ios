//
//  LoginView.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/23.
//

import SwiftUI

extension LoginView {
    var loginSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("SNUCSE 아이디")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.bottom, 6)
            
            CustomTextField(
                placeholder: Text("아이디").foregroundColor(.white),
                text: $viewModel.username
            )
            .foregroundColor(.white)
            .frame(height: 50)
            .padding([.leading, .trailing], 15)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1.5)
                    .foregroundColor(.white)
                    .background(Color.init(white: 1, opacity: 0.3))
            )
            .padding(.bottom, 6)
            
            HStack {
                Spacer()
                
                Link(destination: URL(string: "https://id.snucse.org/verify")!) {
                    Text("가입신청")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            HStack {
                Text("비밀번호")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.bottom, 6)
            
            CustomTextField(
                placeholder: Text("비밀번호").foregroundColor(.white),
                text: $viewModel.password,
                secure: true
            )
            .foregroundColor(.white)
            .frame(height: 50)
            .padding([.leading, .trailing], 15)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1.5)
                    .foregroundColor(.white)
                    .background(Color.init(white: 1, opacity: 0.3))
            )
            .padding(.bottom, 6)
            
            HStack {
                Spacer()
                
                Link(destination: URL(string: "https://id.snucse.org/password-reset")!) {
                    Text("비밀번호 찾기")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct LoginView: View {
    @Environment(\.viewController) var viewController
    @EnvironmentObject var appState: AppState
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                
                Image("SplashLogo")
                    .resizable()
                    .frame(width: 95, height: 66)
                    .padding(.bottom, 6)
                
                Image("SplashTitle")
                    .resizable()
                    .frame(width: 114, height: 24)
                
                Spacer()
                
                loginSection
                    .padding(.bottom, 50)
                
                Spacer()
                
                Button(action: {
                    viewModel.login()
                }) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill()
                        .foregroundColor(.white)
                        .overlay(
                            Text("로그인")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color("Text"))
                        )
                }
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20+geometry.safeAreaInsets.bottom)
            }
            .padding([.leading, .trailing], 20)
            .background(Color("Primary"))
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .edgesIgnoringSafeArea(.all)
            .loader(loading: $viewModel.loading)
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            viewModel.onLoggedIn = presentMain
        }
        .alertModal(
            isActive: $appState.system.error,
            content: appState.system.errorMessage ?? "알 수 없는 에러가 발생했습니다.",
            onAck: {
                appState.system.error = false
                appState.system.errorMessage = nil
            }
        )
    }
    
    func presentMain() {
        viewController?.present(style: .fullScreen) {
            MainView().environmentObject(appState)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
