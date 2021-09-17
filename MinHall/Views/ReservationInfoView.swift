//
//  ReservationInfoView.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/24.
//

import SwiftUI

extension ReservationInfoView {
    var dotsButton: some View {
        NavigationLink(destination: SettingsView()) {
            Image("Dots")
                .resizable()
                .frame(width: 17, height: 3)
                .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 0))
        }
    }
    
    var ctaButton: some View {
        NavigationLink(
            destination: TimeSelectionView()
        ) {
            Text("예약시간 연장하기")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(.bottom, safeAreaInsets.bottom*2/3)
                .frame(width: UIScreen.main.bounds.width, height: 50 + safeAreaInsets.bottom)
        }
        .buttonStyle(MHButtonStyle())
    }
}

struct ReservationInfoView: View {
    @Environment(\.viewController) var viewController
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @StateObject var viewModel = ReservationInfoViewModel()
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Text("나의 예약")
                        .foregroundColor(Color("Text"))
                        .font(.system(size: 14))
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 20, leading: 25, bottom: 0, trailing: 25))
                
                Spacer()
                
                ZStack {
                    Image("ReservationInfoMap")
                        .resizable()
                        .frame(width: 269, height: 118)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill()
                                .foregroundColor(Color("Text"))
                        )
                        .padding(.bottom, 45)
                    
                    Image("MiniMapSeatSelected")
                        .resizable()
                        .scaleEffect(1.1)
                        .rotationEffect(viewModel.seatAngle)
                        .frame(width: 7, height: 7)
                        .position(
                            MapUtil.transformCoordinate(
                                viewModel.seatCoord.x,
                                viewModel.seatCoord.y,
                                frameWidth: 269,
                                frameHeight: 118
                            )
                        )
                }
                .frame(width: 269, height: 118)
                
                
                HStack(spacing: 15) {
                    Text("\(viewModel.startTime) ~ \(viewModel.endTime)")
                        .foregroundColor(Color("Text"))
                        .font(.system(size: 28, weight: .bold))
                    
                    Button(action: {
                        viewModel.showCancelAlert = true
                    }) {
                        RoundedRectangle(cornerRadius: 25)
                            .fill()
                            .foregroundColor(.init(red: 181/255, green: 181/255, blue: 191/255))
                            .frame(width: 81, height: 28)
                            .overlay(
                                Text("취소하기")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            )
                    }
                }
                
                Spacer()
            }
            .roundedBackground()
            .padding(20)
            
            ctaButton
        }
        .navigationBar(trailingItem: dotsButton)
        .alertModal(
            isActive: $viewModel.showCancelAlert,
            content: "정말 예약을 취소하시겠습니까?",
            onAck: {
                viewModel.cancelReservation()
            },
            onCancel: {
                viewModel.showCancelAlert = false
            }
        )
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.bottom)
        .animation(nil)
        .onAppear {
            viewModel.loadReservationInfo()
            viewModel.scheduleNotification()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewModel.scheduleNotification()
        }
    }
}

struct ReservationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationInfoView()
    }
}
