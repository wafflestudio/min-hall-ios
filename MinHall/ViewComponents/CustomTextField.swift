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
    var commit: ()->() = { }
    
    @State private var showPlaceholder: Bool = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            if showPlaceholder { placeholder }
            TextField(
                "",
                text: $text,
                onEditingChanged: { editing in
                    editingChanged(editing)
                    if editing {
                        showPlaceholder = false
                    } else {
                        showPlaceholder = text.isEmpty
                    }
                },
                onCommit: commit
            )
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(placeholder: Text(""), text: .constant(""))
    }
}
