//
//  Modifiers.swift
//  TestDecimilKeyboard WatchKit Extension
//
//  Created by Ian Applebaum on 2/2/21.
//

import Foundation
import SwiftUI

@available(watchOS 6.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct DigitButtonModifier: ViewModifier {
	@ViewBuilder public func body(content: Content) -> some View {
        if #available(watchOS 26, *) {
            content
                .buttonStyle(LiquidGlassDigitPadStyle())
        } else {
            content
                .buttonStyle(DigitPadStyle())
        }
	}
}

@available(watchOS 6.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public extension Button {
	@ViewBuilder func digitKeyFrame() -> some View {
        self.modifier(DigitButtonModifier())
	}
}

@available(watchOS 26.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct LiquidGlassDigitPadStyle: ButtonStyle {
    @State private var displayedPressed = false
    @State private var revertTask: Task<Void, Error>?
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .glassEffect(.regular.interactive(), in: .capsule)
            .contentShape(.capsule)
            .onChange(of: configuration.isPressed) { pressed in
                if pressed {
                    revertTask?.cancel()
                    displayedPressed = true
                } else {
                    revertTask = Task {
                        try? await Task.sleep(for: .seconds(0.08))
                        if !Task.isCancelled {
                            await MainActor.run {
                                displayedPressed = false
                            }
                        }
                    }
                }
            }
            .onChange(of: displayedPressed) { pressed in
                if pressed {
                    playClick()
                }
            }
            .zIndex(displayedPressed ? 1 : 0)
    }
}

@available(watchOS 6.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct DigitPadStyle: ButtonStyle {
	public func makeBody(configuration: Configuration) -> some View {
        GeometryReader(content: { geometry in
            configuration.isPressed ?
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.gray.opacity(0.7))
                .frame(width: geometry.size.width, height: geometry.size.height)
                .scaleEffect(1.5)
            :
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.gray.opacity(0.5))
                .frame(width:  geometry.size.width, height:  geometry.size.height)
                .scaleEffect(1)
            
            configuration.label
                .background(
                    ZStack {
                        GeometryReader(content: { geometry in
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.clear)
                                .frame(width: configuration.isPressed ? geometry.size.width/0.75 : geometry.size.width, height: configuration.isPressed ? geometry.size.height/0.8 : geometry.size.height)
                        })
                    }
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
        })
        .onChange(of: configuration.isPressed, perform: { value in
            if configuration.isPressed{
                playClick()
            }
        })
    }
}

fileprivate func playClick() {
    DispatchQueue.main.async {
        #if os(watchOS)
        WKInterfaceDevice().play(.click)
        #endif
    }
}

public enum TextViewAlignment {
	case trailing
	case leading
	case center
}

public enum KeyboardStyle {
    case decimal
    case numbers
}

#if DEBUG && os(watchOS)
struct EnteredTextKeys_Previews: PreviewProvider {
    static var previews: some View {
        EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .numbers)
        Group {
            EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .decimal)
            EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .decimal)
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        }
        EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .decimal).previewDevice("Apple Watch Series 6 - 40mm")
        EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .numbers).previewDevice("Apple Watch Series 3 - 38mm")
        EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .decimal).previewDevice("Apple Watch Series 3 - 42mm")
    }
}
#endif
