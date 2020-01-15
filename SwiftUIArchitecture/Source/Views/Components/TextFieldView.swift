//
//  TextFieldView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 15.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - TextFieldView

struct TextFieldView: UIViewRepresentable {
    // MARK: - Constants

    let done: ((String) -> Void)?
    let contentType: UITextContentType
    let returnVal: UIReturnKeyType
    let font: UIFont?
    let fontColor: UIColor?
    let placeholder: String
    let characterSet: CharacterSet?
    let minCharacters: Int?
    let tag: Int

    // MARK: - Variables

    @Binding var text: String
    @Binding var isFocusable: [Bool]

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.font = font
        textField.textColor = fontColor
        textField.tintColor = fontColor
        textField.textContentType = contentType
        textField.returnKeyType = returnVal
        textField.tag = tag
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.clearButtonMode = .never
        textField.autocapitalizationType = .none

        if textField.textContentType == .password || textField.textContentType == .newPassword {
            textField.isSecureTextEntry = true
        }
        return textField
    }

    func updateUIView(_ uiView: UITextField, context _: Context) {
        uiView.text = text

        if isFocusable[tag] {
            if !uiView.isFirstResponder {
                uiView.becomeFirstResponder()
            }
        } else {
            uiView.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldView

        init(_ textField: TextFieldView) {
            parent = textField
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            // Without async this will modify the state during view update.
            DispatchQueue.main.async {
                self.parent.text = textField.text ?? ""
            }
        }

        func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
            guard let hexSet = self.parent.characterSet else {
                return true
            }
            return hexSet.isSuperset(of: CharacterSet(charactersIn: string))
        }

        func textFieldShouldBeginEditing(_: UITextField) -> Bool {
            setFocus(tag: parent.tag)
            return true
        }

        func setFocus(tag: Int) {
            let reset = tag >= parent.isFocusable.count || tag < 0

            if reset || !parent.isFocusable[tag] {
                var newFocus = [Bool](repeatElement(false, count: parent.isFocusable.count))
                if !reset {
                    newFocus[tag] = true
                }
                // Without async this will modify the state during view update.
                DispatchQueue.main.async {
                    self.parent.isFocusable = newFocus
                }
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard let text = textField.text else {
                return false
            }
            if let count = parent.minCharacters {
                let isValidCount = text.count >= count
                if !isValidCount {
                    return false
                }
            }
            setFocus(tag: parent.tag + 1)
            parent.done?(text)

            return true
        }
    }
}

// MARK: - TextFieldView_Previews

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView(
            done: nil,
            contentType: .emailAddress,
            returnVal: .next,
            font: nil,
            fontColor: nil,
            placeholder: "Placeholder",
            characterSet: nil,
            minCharacters: 10,
            tag: 0,
            text: .constant(""),
            isFocusable: .constant([false])
        )
    }
}
