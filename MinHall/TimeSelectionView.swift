//
//  TimeSelectionView.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/24.
//

import SwiftUI

extension TimeSelectionView {
    func timeView(type: TimeSelectionViewModel.TimeType) -> some View {
        VStack {
            HStack {
                Text("사용 \(type.rawValue) 시간")
                    .foregroundColor(Color("SubText"))
                    .font(.system(size: 14))
                
                Spacer()
            }
            
            Spacer()
            
            HStack(alignment: .top, spacing: 33) {
                Spacer()
                VStack(spacing: 0) {
                    Button(action: {
                        viewModel.modifyHour(type: type, modify: .increase)
                    }) {
                        Image("Up")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .opacity((viewModel.isExtend && type == .start) ? 0 : 1)
                    .disabled(viewModel.isExtend && type == .start)
                    .padding(.bottom, 12)
                    
                    Text(String(format: "%02d", viewModel.getHour(type: type)))
                        .foregroundColor(Color("Text"))
                        .font(.system(size: 28))
                        .frame(width: 40, height: 40)
                    Text("시")
                        .foregroundColor(Color("Text"))
                        .font(.system(size: 12))
                        .padding(.bottom, 11)
                    
                    Button(action: {
                        viewModel.modifyHour(type: type, modify: .decrease)
                    }) {
                        Image("Down")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .opacity((viewModel.isExtend && type == .start) ? 0 : 1)
                    .disabled(viewModel.isExtend && type == .start)
                }
                
                Text(":")
                    .foregroundColor(Color("Text"))
                    .font(.system(size: 28))
                    .padding(.top, 37)
                
                VStack(spacing: 0) {
                    Button(action: {
                        viewModel.modifyMinute(type: type, modify: .increase)
                    }) {
                        Image("Up")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .opacity((viewModel.isExtend && type == .start) ? 0 : 1)
                    .disabled(viewModel.isExtend && type == .start)
                    .padding(.bottom, 12)
                    
                    Text(String(format: "%02d", viewModel.getMinute(type: type)))
                        .foregroundColor(Color("Text"))
                        .font(.system(size: 28))
                        .frame(width: 40, height: 40)
                    Text("분")
                        .foregroundColor(Color("Text"))
                        .font(.system(size: 12))
                        .padding(.bottom, 11)
                    
                    Button(action: {
                        viewModel.modifyMinute(type: type, modify: .decrease)
                    }) {
                        Image("Down")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .opacity((viewModel.isExtend && type == .start) ? 0 : 1)
                    .disabled(viewModel.isExtend && type == .start)
                }
                Spacer()
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
    }
    
    var backButton: some View {
        Group {
            if viewModel.isExtend {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image("ArrowBack")
                        .resizable()
                        .frame(width: 10, height: 17)
                        .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 6))
                }
            } else {
                EmptyView()
            }
        }
    }
    
    var doneButton: some View {
        Group {
            NavigationLink(destination: SeatSelectionView(), isActive: $viewModel.toSeatSelect) { EmptyView() }
            
            Button(action: {
                if viewModel.isExtend {
                    viewModel.makeReservation()
                } else {
                    viewModel.toSeatSelect = true
                }
            }) {
                Text(viewModel.isExtend ? "예약시간 연장하기" : "예약하기")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .padding(.bottom, safeAreaInsets.bottom*2/3)
                    .frame(width: UIScreen.main.bounds.width, height: 50 + safeAreaInsets.bottom)
            }
            .buttonStyle(MHButtonStyle())
        }
    }
}

struct TimeSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    @StateObject var viewModel = TimeSelectionViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text(viewModel.today)
                    .foregroundColor(Color("Text"))
                    .font(.system(size: 18))
                Spacer()
            }
            .frame(height: 60)
            .roundedBackground()
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
            
            VStack(spacing: 0) {
                timeView(type: .start)
                Divider()
                    .foregroundColor(.init(red: 181/255, green: 181/255, blue: 191/255))
                    .padding([.leading, .trailing], 25)
                timeView(type: .end)
                
                HStack {
                    Text("*30분 단위로 예약할 수 있습니다.")
                        .foregroundColor(Color("SubText"))
                        .font(.system(size: 14))
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 25, bottom: 20, trailing: 25))
            }
            .roundedBackground()
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20))
            
            doneButton
        }
        .navigationBar(leadingItem: backButton)
        .announceModal(isActive: $viewModel.showAnnounce, title: "공간 사용 시 주의사항", content: viewModel.announce)
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            viewModel.onReserved = {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct TimeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSelectionView()
    }
}
