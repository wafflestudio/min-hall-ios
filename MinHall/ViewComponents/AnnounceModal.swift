//
//  AnnounceModal.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/25.
//

import Foundation
import SwiftUI

extension View {
    func announceModal(isActive: Binding<Bool>, title: String, content: String, critical: Bool = false) -> some View {
        self
            .overlay(
                Group {
                    if isActive.wrappedValue {
                        ZStack {
                            Color.init(white: 0, opacity: 0.5)
                                .edgesIgnoringSafeArea(.all)
                            
                            AnnounceModal(isActive: isActive, title: title, content: content, critical: critical)
                        }
                        .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                    }
                }
            )
    }
}

struct AnnounceModal: View {
    @Binding var isActive: Bool
    var title: String
    var content: String
    var critical: Bool
    
    init(isActive: Binding<Bool>, title: String, content: String, critical: Bool = false) {
        self._isActive = isActive
        self.title = title
        self.content = content
        self.critical = critical
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                Text(title)
                    .foregroundColor(Color("Text"))
                    .font(.system(size: 20, weight: .bold))
                
                Text(content)
                    .foregroundColor(Color("Text"))
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(EdgeInsets(top: 25, leading: 30, bottom: 35, trailing: 30))
            
            
            Button(action: {
                self.isActive = false
            }) {
                Text("위 내용을 숙지했습니다.")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .frame(height: 58)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(MHButtonStyle(critical: critical))
        }
        .background(Color.white)
        .padding([.leading, .trailing], 20)
    }
}
