//
//  Loader.swift
//  MinHall
//
//  Created by 박종석 on 2021/08/15.
//

import Foundation
import SwiftUI

extension View {
    func loader(loading: Binding<Bool>) -> some View {
        return self.modifier(LoaderModifier(loading: loading))
    }
}

struct LoaderModifier: ViewModifier {
    @Binding var loading: Bool
    
    init(loading: Binding<Bool>) {
        self._loading = loading
    }
    
    func body(content: Content) -> some View {
        content
            .disabled(loading)
            .overlay(
                VStack {
                    if loading {
                        Spacer()
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
            )
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
