//
//  CustomTextField.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/24.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var secure: Bool = false
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.count == 0 { placeholder }
            if !secure {
                TextField(
                    "",
                    text: $text,
                    onEditingChanged: editingChanged,
                    onCommit: commit
                )
                .frame(maxHeight: .infinity)
                .autocapitalization(.none)
            } else {
                SecureField(
                    "",
                    text: $text,
                    onCommit: commit
                )
                .frame(maxHeight: .infinity)
                .autocapitalization(.none)
            }
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(placeholder: Text(""), text: .constant(""))
    }
}
