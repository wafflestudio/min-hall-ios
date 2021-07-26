//
//  SeatSelectionView.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/19.
//

import SwiftUI

extension SeatSelectionView {
    var mainMap: some View {
        LegacyScrollView(isMoving: $isMoving, offset: $offset, reload: $viewModel.reloadScrollView) {
            ZStack {
                Image("Frame")
                
                ForEach(viewModel.seatInfos, id: \.id) { seat in
                    Button(action: {
                        if viewModel.selectedSeat == seat.id {
                            viewModel.selectedSeat = -1
                        } else {
                            viewModel.selectedSeat = seat.id
                        }
                    }) {
                        Image(seat.id == viewModel.selectedSeat ? "SeatSelected" : seat.status.rawValue)
                            .resizable()
                            .rotationEffect(seat.angle)
                    }
                    .disabled(seat.status != .available)
                    .frame(width: 42, height: 42)
                    .position(x: seat.x, y: seat.y)
                }
            }
        }
    }
    
    var miniMap: some View {
        ZStack {
            Rectangle()
                .fill()
                .foregroundColor(Color("Text"))
                .frame(width: 184, height: 80)
            Image("MiniMap")
                .resizable()
                .frame(width: 184, height: 80)
            
            ForEach(viewModel.seatInfos, id: \.id) { seat in
                Image("MiniMap"+seat.status.rawValue)
                    .resizable()
                    .rotationEffect(seat.angle)
                    .frame(width: 4.5, height: 4.5)
                    .position(MapUtil.transformCoordinate(seat.x, seat.y))
            }
            
            Rectangle()
                .stroke(lineWidth: 3)
                .foregroundColor(Color("Primary"))
                .frame(
                    width: MapUtil.getBoxWidth(zoom: offset.zoom),
                    height: MapUtil.getBoxHeight(zoom: offset.zoom)
                )
                .position(
                    x: MapUtil.getBoxWidth(zoom: offset.zoom)/2,
                    y: MapUtil.getBoxHeight(zoom: offset.zoom)/2
                )
                .offset(
                    x: MapUtil.transformXOffset(offset.x, zoom: offset.zoom),
                    y: MapUtil.transformYOffset(offset.y, zoom: offset.zoom)
                )
                .clipped()
        }
        .transition(.opacity.animation(.easeInOut))
        .zIndex(1)
        .frame(width: 184, height: 80)
        .position(x: 107, y: 55)
    }
    
    var doneButton: some View {
        Button(action: {
            viewModel.makeReservation()
        }) {
            Text("좌석 선택하기")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(.bottom, safeAreaInsets.bottom*2/3)
                .frame(width: UIScreen.main.bounds.width, height: 50 + safeAreaInsets.bottom)
        }
        .buttonStyle(MHButtonStyle(available: $viewModel.selected))
        .disabled(!viewModel.selected)
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

struct SeatSelectionView: View {
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.viewController) var viewController
    
    @StateObject var viewModel = SeatSelectionViewModel()
    
    @State var isMoving: Bool = true
    @State var offset = ScrollOffset(x: 0, y: 0, zoom: 1)

    @State var lastScaleValue: CGFloat = 1
    @State var scaledBy: CGFloat = 1
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    mainMap
                    
                    if isMoving {
                        miniMap
                    }
                    
                    ZStack {
                        Rectangle()
                            .fill()
                            .foregroundColor(.white)
                            .shadow(color: .init(white: 0, opacity: 0.15), radius: 1, x: 0, y: -2)
                        
                        Image("SeatInfo")
                            .resizable()
                            .frame(width: 240, height: 18)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                }
                
                doneButton
            }
        }
        .navigationBar(leadingItem: backButton)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            viewModel.onReserved = presentReservationInfo
        }
    }
    
    func presentReservationInfo() {
        viewController?.present(style: .fullScreen) {
            NavigationView {
                ReservationInfoView()
            }
        }
    }
}

struct SeatSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SeatSelectionView()
    }
}
