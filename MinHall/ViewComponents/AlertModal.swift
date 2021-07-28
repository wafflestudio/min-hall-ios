//
//  AlertModal.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/27.
//

import Foundation
import SwiftUI

extension View {
    func alertModal(
        isActive: Binding<Bool>,
        content: String,
        onAck: (() -> ())? = nil,
        onCancel: (() -> ())? = nil) -> some View {
        self
            .overlay(
                Group {
                    if isActive.wrappedValue {
                        ZStack {
                            Color.init(white: 0, opacity: 0.5)
                                .edgesIgnoringSafeArea(.all)
                            
                            AlertModal(isActive: isActive, content: content, onAck: onAck, onCancel: onCancel)
                        }
                        .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                    }
                }
            )
    }
}

struct AlertModal: View {
    @Binding var isActive: Bool
    var content: String
    var onAck: (() -> ())? = nil
    var onCancel: (() -> ())? = nil
    
    init(isActive: Binding<Bool>, content: String, onAck: (() -> ())?, onCancel: (() -> ())?) {
        self._isActive = isActive
        self.content = content
        self.onAck = onAck
        self.onCancel = onCancel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 50) {
                Text(content)
                    .foregroundColor(Color("Text"))
                    .font(.system(size: 14))
                
                HStack(spacing: 45) {
                    Spacer()
                    
                    if onCancel != nil {
                        Button(action: {
                            (onCancel ?? { })()

                        }) {
                            Text("취소")
                                .foregroundColor(Color("Disabled"))
                                .font(.system(size: 17, weight: .bold))
                        }
                    }
                    
                    Button(action: {
                        (onAck ?? { self.isActive = false })()
                    }) {
                        Text("확인")
                            .foregroundColor(Color("Primary"))
                            .font(.system(size: 17, weight: .bold))
                    }
                    
                }
                
            }
            .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
        }
        .background(Color.white)
        .padding([.leading, .trailing], 20)
    }
}
