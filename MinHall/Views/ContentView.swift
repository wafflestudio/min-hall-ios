//
//  ContentView.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TimeSelectionView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}