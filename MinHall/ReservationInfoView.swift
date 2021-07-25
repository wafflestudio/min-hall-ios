//
//  ReservationInfoView.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/24.
//

import SwiftUI

extension ReservationInfoView {
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
                    Image("MiniMap")
                        .resizable()
                        .frame(width: 269, height: 118)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill()
                                .foregroundColor(Color("Text"))
                        )
                        .padding(.bottom, 45)
                    
                    ForEach(viewModel.seatInfos, id: \.id) { seat in
                        Image(seat.id == viewModel.seatId ? "MiniMapSeatSelected" : "MiniMap"+seat.status.rawValue)
                            .resizable()
                            .rotationEffect(seat.angle)
                            .frame(width: 6.5, height: 6.5)
                            .position(MapUtil.transformCoordinate(seat.x, seat.y, frameWidth: 269, frameHeight: 118))
                    }
                }
                .frame(width: 269, height: 118)
                
                
                HStack(spacing: 15) {
                    Text("\(viewModel.startTime) ~ \(viewModel.endTime)")
                        .foregroundColor(Color("Text"))
                        .font(.system(size: 28, weight: .bold))
                    
                    Button(action: {
                        
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
        .navigationBar()
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            viewModel.getReservationInfo()
        }
    }
}

struct ReservationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationInfoView()
    }
}
