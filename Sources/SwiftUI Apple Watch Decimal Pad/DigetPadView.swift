//
//  ContentView.swift
//  TestDecimilKeyboard WatchKit Extension
//
//  Created by Ian Applebaum on 2/2/21.
//

import SwiftUI

@available(watchOS 6.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct DigiTextView: View {
    private var locale: Locale
    var style: KeyboardStyle
    var placeholder: String
    @Binding public var text: String
    @State public var presentingModal: Bool
    
    var align: TextViewAlignment
    public init(placeholder: String, text: Binding<String>, presentingModal:Bool, alignment: TextViewAlignment = .center,style: KeyboardStyle = .numbers, locale: Locale = .current){
        _text = text
        _presentingModal = State(initialValue: presentingModal)
        self.align = alignment
        self.placeholder = placeholder
        self.style = style
        self.locale = locale
    }
    
    public var body: some View {
        Button(action: {
            presentingModal.toggle()
        }) {
            if text != ""{
                Text(text)
            }
            else{
                Text(placeholder)
                    .lineLimit(1)
                    .opacity(0.5)
            }
        }.buttonStyle(TextViewStyle(alignment: align))
            .sheet(isPresented: $presentingModal, content: {
                EnteredText(text: $text, presentedAsModal: $presentingModal, style: self.style, locale: locale)
            })
    }
}

@available(watchOS 6.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct DigiNumberView: View {
    private var locale: Locale
    var style: KeyboardStyle
    var placeholder: String
    @Binding public var number: Int
    @State public var presentingModal: Bool
    
    var align: TextViewAlignment
    public init(placeholder: String, number: Binding<Int>, presentingModal:Bool, alignment: TextViewAlignment = .center,style: KeyboardStyle = .numbers, locale: Locale = .current){
        _number = number
        _presentingModal = State(initialValue: presentingModal)
        self.align = alignment
        self.placeholder = placeholder
        self.style = style
        self.locale = locale
    }
    
    var text: Binding<String> {
        Binding {
            number.description
        } set: { newValue in
            number = Int(newValue) ?? 0
        }
    }
    
    public var body: some View {
        Button(action: {
            presentingModal.toggle()
        }) {
            Text(number.description)
        }.buttonStyle(TextViewStyle(alignment: align))
            .sheet(isPresented: $presentingModal, content: {
                EnteredText(text: text, presentedAsModal: $presentingModal, style: self.style, locale: locale)
            })
    }
}

@available(watchOS 6.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct EnteredText: View {
    @Binding var text: String
    @Binding var presentedAsModal: Bool
    var style: KeyboardStyle
    var watchOSDimensions: CGRect?
    private var locale: Locale
    
    public init(text: Binding<String>, presentedAsModal:
                Binding<Bool>, style: KeyboardStyle, locale: Locale = .current) {
        _text = text
        _presentedAsModal = presentedAsModal
        self.style = style
        self.locale = locale
        let device = WKInterfaceDevice.current()
        watchOSDimensions = device.screenBounds
    }
    
    var number: Binding<Int> {
        Binding {
            Int(text) ?? 0
        } set: { new in
            text = String(new)
        }
    }
    
    public var body: some View{
        VStack(alignment: .trailing) {
            if #available(watchOS 9, *), style == .numbers {
                Stepper(value: number, in: 0...Int.max) {
                    HStack {
                        Spacer(minLength: 0)
                        Text(text)
                            .font(.title2)
                    }
                    .padding(.horizontal)
                    .frame(height: watchOSDimensions!.height * 0.15, alignment: .trailing)
                }
                .focusable()
            } else {
                Button(action:{
                    presentedAsModal.toggle()
                }){
                    ZStack(content: {
                        Text("1")
                            .font(.title2)
                            .foregroundColor(.clear
                            )
                    })
                    
                    Text(text)
                        .font(.title2)
                        .frame(height: watchOSDimensions!.height * 0.15, alignment: .trailing)
                }
                .buttonStyle(PlainButtonStyle())
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
            }
            
            DigetPadView(text: $text, style: style, locale: locale)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
        .toolbar(content: {
            ToolbarItem(placement: .cancellationAction){
                Button {
                    presentedAsModal.toggle()
                } label: {
                    Label("Done", systemImage: "xmark")
                }
            }
        })
        
    }
}

@available(watchOS 6.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct DigetPadView: View {
    public var widthSpace: CGFloat = 1.0
    @Binding var text:String
    var style: KeyboardStyle
    private var decimalSeparator: String
    public init(text: Binding<String>, style: KeyboardStyle, locale: Locale = .current) {
        _text = text
        self.style = style
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        decimalSeparator = numberFormatter.decimalSeparator
    }
    public var body: some View {
        Group {
            if #available(watchOS 26, *) {
                Grid(horizontalSpacing: widthSpace, verticalSpacing: 1) {
                    GridRow {
                        topRow
                    }
                    GridRow {
                        upMidRow
                    }
                    GridRow {
                        lowMidRow
                    }
                    GridRow {
                        bottomRow
                    }
                }
                .font(.title3.bold())
            } else {
                VStack(spacing: 1) {
                    HStack(spacing: widthSpace){
                        topRow
                    }
                    HStack(spacing:widthSpace){
                        upMidRow
                    }
                    
                    HStack(spacing:widthSpace){
                        lowMidRow
                    }
                    HStack(spacing:widthSpace) {
                        bottomRow
                    }
                }
                .font(.title2)
            }
        }
    }
    
    var topRow: some View {
        Group {
            Button(action: {
                text.append("1")
            }) {
                Text("1")
                    .padding(0)
            }
            .digitKeyFrame()
            Button(action: {
                text.append("2")
            }) {
                Text("2")
            }
            .digitKeyFrame()
            
            Button(action: {
                text.append("3")
            }) {
                Text("3")
            }
            .digitKeyFrame()
        }
    }
    
    var upMidRow: some View {
        Group {
            Button(action: {
                text.append("4")
            }) {
                Text("4")
            }
            .digitKeyFrame()
            Button(action: {
                text.append("5")
            }) {
                Text("5")
            }
            .digitKeyFrame()
            
            Button(action: {
                text.append("6")
            }) {
                Text("6")
            }
            .digitKeyFrame()
        }
    }
    
    var lowMidRow: some View {
        Group {
            Button(action: {
                text.append("7")
            }) {
                Text("7")
            }
            .digitKeyFrame()
            Button(action: {
                text.append("8")
            }) {
                Text("8")
            }
            .digitKeyFrame()
            
            Button(action: {
                text.append("9")
            }) {
                Text("9")
            }
            .digitKeyFrame()
        }
    }
    
    var bottomRow: some View {
        Group {
            if style == .decimal {
                Button(action: {
                    if !(text.contains(decimalSeparator)){
                        if text == ""{
                            text.append("0\(decimalSeparator)")
                        }else{
                            text.append(decimalSeparator)
                        }
                    }
                }) {
                    Text(decimalSeparator)
                }
                .digitKeyFrame()
            } else {
                Spacer()
                    .padding(1)
            }
            Button(action: {
                text.append("0")
            }) {
                Text("0")
            }
            .digitKeyFrame()
            
            Button(action: {
                if let last = text.indices.last{
                    text.remove(at: last)
                }
            }) {
                Image(systemName: "delete.left")
            }
            .digitKeyFrame()
        }
    }
}

@available(iOS 13.0, watchOS 6.0, *)
struct TextViewStyle: ButtonStyle {
    init(alignment: TextViewAlignment = .center) {
        self.align = alignment
    }
    
    var align: TextViewAlignment
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if align == .center || align == .trailing{
                Spacer()
            }
            configuration.label
                .font(/*@START_MENU_TOKEN@*/.body/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 11.0)
                .padding(.horizontal)
            if align == .center || align == .leading{
                Spacer()
            }
        }
        .background(
            GeometryReader { geometry in
                ZStack{
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .fill(configuration.isPressed ? Color.gray.opacity(0.1): Color.gray.opacity(0.2))
                }
            })
        
    }
    
}

@available(watchOS 10, *)
#Preview("Number Only") {
    @Previewable @State var text: String = "0"
    return DigiTextView(placeholder: "Placeholder", text: $text, presentingModal: false, alignment: .leading)
}

@available(watchOS 10, *)
#Preview("Number Only") {
    @Previewable @State var number: Int = 0
    return DigiNumberView(placeholder: "Placeholder", number: $number, presentingModal: false, alignment: .leading)
}

@available(watchOS 10, *)
#Preview("Decimals") {
    @Previewable @State var text: String = "0"
    DigiTextView(placeholder: "Placeholder", text: $text, presentingModal: true, alignment: .leading, style: .decimal)
}

@available(watchOS 10, *)
#Preview("Decimal XXXL") {
    @Previewable @State var text: String = "0"
    DigiTextView(placeholder: "Placeholder", text: $text, presentingModal: true, alignment: .leading, style: .decimal)
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
}

@available(watchOS 10, *)
#Preview("Decimal XXXL Accessibility Element") {
    @Previewable @State var text: String = "0"
    DigiTextView(placeholder: "Placeholder", text: $text, presentingModal: true, alignment: .leading, style: .decimal)
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        .accessibilityElement(children: /*@START_MENU_TOKEN@*/.contain/*@END_MENU_TOKEN@*/)
}

@available(watchOS 10, *)
#Preview("Scroll") {
    @Previewable @State var text: String = ""
    
    ScrollView {
        ForEach(0 ..< 4) { item in
            DigiTextView(placeholder: "Placeholder", text: $text, presentingModal: false, alignment: .leading)
        }
        Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Button")/*@END_MENU_TOKEN@*/
        }
    }
}

@available(watchOS 10, *)
#Preview("Baseline") {
    ScrollView{
        ForEach(0 ..< 4){ item in
            TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
        }
        Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Button")/*@END_MENU_TOKEN@*/
        }
    }
}
