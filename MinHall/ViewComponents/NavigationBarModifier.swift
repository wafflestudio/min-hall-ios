//
//  NavigationBarModifier.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/24.
//

import Foundation
import SwiftUI

extension View {
    func navigationBar(title: String = "SNU 민상렬홀") -> some View {
        self.modifier(NavigationBarModifier(title: title))
    }
}

struct NavigationBarModifier: ViewModifier {
    var title: String
    
    init(title: String = "SNU 민상렬홀") {
        self.title = title
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.backgroundColor = UIColor.white
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .bold))
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

