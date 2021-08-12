//
//  ContentView.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            if appState.reservationData.reservation == nil {
                TimeSelectionView()
            } else {
                ReservationInfoView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alertModal(
            isActive: $appState.system.error,
            content: appState.system.errorMessage ?? "알 수 없는 에러가 발생했습니다.",
            onAck: {
                appState.system.error = false
                appState.system.errorMessage = nil
            }
        )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
