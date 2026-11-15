//
//  EmojiKeyboard.swift
//  eunomia
//
//  Minimal version of EmojiPickerKit (MIT), https://github.com/spencer0124/EmojiPickerKit
//  Opens the system emoji keyboard and reports the emoji the user picks.
//

import SwiftUI
import UIKit

final class EmojiKeyboardTextField: UITextField, UITextFieldDelegate {
    var onEmojiSelected: ((String) -> Void)?
    var onDismiss: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        keyboardType = UIKeyboardType(rawValue: 124) ?? .default
        delegate = self
        alpha = 0
        tintColor = .clear
        autocorrectionType = .no
        isAccessibilityElement = false
        inputAccessoryView = accessoryHost.view
    }

    private lazy var accessoryHost: UIHostingController<EmojiKeyboardAccessory> = {
        let host = UIHostingController(
            rootView: EmojiKeyboardAccessory { [weak self] in
                self?.resignFirstResponder()
            }
        )
        host.view.backgroundColor = .clear
        host.safeAreaRegions = []
        host.view.frame = CGRect(x: 0, y: 0, width: 0, height: 60)
        host.view.autoresizingMask = .flexibleWidth
        return host
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if let emoji = string.last {
            onEmojiSelected?(String(emoji))
            resignFirstResponder()
        }
        return false
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        let wasFirstResponder = isFirstResponder
        let resigned = super.resignFirstResponder()
        if wasFirstResponder && resigned {
            onDismiss?()
        }
        return resigned
    }
}

private struct EmojiKeyboardAccessory: View {
    let onClose: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.body.weight(.semibold))
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .controlSize(.large)
            .accessibilityLabel("Close")
        }
        .padding(.horizontal, 8)
        .frame(maxHeight: .infinity)
    }
}

struct EmojiKeyboard: UIViewRepresentable {
    @Binding var isPresented: Bool
    let onSelect: (String) -> Void

    func makeUIView(context: Context) -> EmojiKeyboardTextField {
        EmojiKeyboardTextField()
    }

    func updateUIView(_ field: EmojiKeyboardTextField, context: Context) {
        let isPresented = $isPresented
        field.onEmojiSelected = onSelect
        field.onDismiss = {
            DispatchQueue.main.async { isPresented.wrappedValue = false }
        }

        if self.isPresented && !field.isFirstResponder {
            DispatchQueue.main.async { field.becomeFirstResponder() }
        } else if !self.isPresented && field.isFirstResponder {
            DispatchQueue.main.async { field.resignFirstResponder() }
        }
    }
}

extension View {
    func emojiKeyboard(
        isPresented: Binding<Bool>,
        onSelect: @escaping (String) -> Void
    ) -> some View {
        background(
            EmojiKeyboard(isPresented: isPresented, onSelect: onSelect)
                .frame(width: 0, height: 0)
        )
    }
}

#Preview {
    @Previewable @State var emoji = "🙂"
    @Previewable @State var isPicking = false

    Button {
        isPicking = true
    } label: {
        Text(emoji).font(.system(size: 64))
    }
    .emojiKeyboard(isPresented: $isPicking) { emoji = $0 }
}
