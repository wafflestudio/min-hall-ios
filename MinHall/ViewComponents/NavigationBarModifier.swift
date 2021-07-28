//
//  NavigationBarModifier.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/24.
//

import Foundation
import SwiftUI

extension View {
    func navigationBar<L: View, T: View>(
        title: String = "SNU 민상렬홀",
        leadingItem: L,
        trailingItem: T) -> some View {
        self.modifier(NavigationBarModifier(title: title, leadingItem: leadingItem, trailingItem: trailingItem))
    }
    
    func navigationBar<L: View>(
        title: String = "SNU 민상렬홀",
        leadingItem: L) -> some View {
        self.modifier(NavigationBarModifier(title: title, leadingItem: leadingItem, trailingItem: EmptyView()))
    }
    
    func navigationBar<T: View>(
        title: String = "SNU 민상렬홀",
        trailingItem: T) -> some View {
        self.modifier(NavigationBarModifier(title: title, leadingItem: EmptyView(), trailingItem: trailingItem))
    }
    
    func navigationBar(title: String = "SNU 민상렬홀") -> some View {
        self.modifier(NavigationBarModifier(title: title, leadingItem: EmptyView(), trailingItem: EmptyView()))
    }
}

struct NavigationBar<L: View, T: View>: View {
    var title: String
    var leading: L
    var trailing: T
    
    init(title: String, leadingItem: L, trailingItem: T) {
        self.title = title
        self.leading = leadingItem
        self.trailing = trailingItem
    }
    
    var body: some View {
        HStack {
            HStack {
                leading
            }
            .frame(width: 40, alignment: .leading)
            
            Spacer()
            
            Text(title)
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .bold))
            
            Spacer()
            
            HStack {
                trailing
            }
            .frame(width: 40, alignment: .trailing)
        }
        .padding([.leading, .trailing], 20)
        .frame(width: UIScreen.main.bounds.width, height: 45)
        .background(
            Color.white
                .shadow(color: .init(white: 0, opacity: 0.15), radius: 1, x: 0, y: 2)
        )
        .zIndex(10000)
    }
}

struct NavigationBarModifier<L: View, T: View>: ViewModifier {
    var navigationBar: NavigationBar<L, T>
    
    init(title: String, leadingItem: L, trailingItem: T) {
        self.navigationBar = NavigationBar(title: title, leadingItem: leadingItem, trailingItem: trailingItem)
    }
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            navigationBar
            content
        }
        .navigationBarHidden(true)
    }
}

