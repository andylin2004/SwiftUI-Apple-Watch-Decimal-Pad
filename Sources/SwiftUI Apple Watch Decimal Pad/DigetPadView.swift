//
//  ContentView.swift
//  TestDecimilKeyboard WatchKit Extension
//
//  Created by Ian Applebaum on 2/2/21.
//

import SwiftUI
#if os(watchOS)
@available(watchOS 6.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct ScrollableDigiTextView: View {
    private var locale: Locale
    var placeholder: String
    @Binding public var text: Double
    @State public var presentingModal: Bool
    
    var align: TextViewAlignment
    public init( placeholder: String, text: Binding<Double>, presentingModal:Bool, alignment: TextViewAlignment = .center, locale: Locale = .current){
        _text = text
        _presentingModal = State(initialValue: presentingModal)
        self.align = alignment
        self.placeholder = placeholder
        self.locale = locale
    }
    
    public var body: some View {
        Button(action: {
            presentingModal.toggle()
        }) {
            Text(String(format: "%.0f", text))
        }.buttonStyle(TextViewStyle(alignment: align))
        .sheet(isPresented: $presentingModal, content: {
            ScrollableEnteredText(text: $text, presentedAsModal: $presentingModal, locale: locale)
        })
    }
}

@available(watchOS 6.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
private struct ScrollableEnteredText: View {
    @Binding var text: Double
    @Binding var presentedAsModal: Bool
    var watchOSDimensions: CGRect?
    private var locale: Locale
    
    public init(text: Binding<Double>, presentedAsModal:
                Binding<Bool>, locale: Locale = .current){
        _text = text
        _presentedAsModal = presentedAsModal
        self.locale = locale
        let device = WKInterfaceDevice.current()
        watchOSDimensions = device.screenBounds
    }
    public var body: some View{
        VStack(alignment: .trailing) {
                Button(action:{
                    presentedAsModal.toggle()
                }){
                    ZStack(content: {
                        Text("1")
                            .font(.title2)
                            .foregroundColor(.clear
                            )
                    })
                    Text(String(format: "%.0f", text))
                        .font(.title2)
                        .frame(height: watchOSDimensions!.height * 0.15, alignment: .trailing)
                        .focusable(true)
                        .digitalCrownRotation($text, from: 0, through: 99999999, by: 1)
                }
                .buttonStyle(PlainButtonStyle())
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
                
                ScrollableDigetPadView(text: $text, locale: locale)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
        .toolbar(content: {
            ToolbarItem(placement: .cancellationAction){
                Button {
                    presentedAsModal.toggle()
                } label: {
                    Label("Done", systemImage: "xmark")
                        .toolbarButtonNativeLabel()
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
private struct ScrollableDigetPadView: View {
    public var widthSpace: CGFloat = 1.0
    @Binding var text: Double
    private var decimalSeparator: String
    public init(text: Binding<Double>, locale: Locale = .current) {
        _text = text

        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        decimalSeparator = numberFormatter.decimalSeparator
    }
    public var body: some View {
        VStack(spacing: 1) {
            HStack(spacing: widthSpace){
                Button(action: {
                    text = Double(String(format: "%.0f", text).appending("1"))!
                }) {
                    Text("1")
                        .padding(0)
                }
                .digitKeyFrame()
                Button(action: {
                    text = Double(String(format: "%.0f", text).appending("2"))!
                }) {
                    Text("2")
                }.digitKeyFrame()
                
                Button(action: {
                    text = Double(String(format: "%.0f", text).appending("3"))!
                }) {
                    Text("3")
                }.digitKeyFrame()
            }
            HStack(spacing:widthSpace){
                Button(action: {
                    text = Double(String(format: "%.0f", text).appending("4"))!
                }) {
                    Text("4")
                }.digitKeyFrame()
                Button(action: {
                    text = Double(String(format: "%.0f", text).appending("5"))!
                }) {
                    Text("5")
                }.digitKeyFrame()
                
                Button(action: {
                    text = Double(String(format: "%.0f", text).appending("6"))!
                }) {
                    Text("6")
                }.digitKeyFrame()
            }
            
            HStack(spacing:widthSpace){
                Button(action: {
                    text = Double(String(format: "%.0f", text).appending("7"))!
                }) {
                    Text("7")
                }.digitKeyFrame()
                Button(action: {
                    text = Double(String(format: "%.0f", text).appending("8"))!
                }) {
                    Text("8")
                }.digitKeyFrame()
                
                Button(action: {
                    text = Double(String(format: "%.0f", text).appending("9"))!
                }) {
                    Text("9")
                }
                .digitKeyFrame()
            }
            HStack(spacing:widthSpace) {
                Spacer()
                    .padding(1)
                Button(action: {
                    text = Double(String(format: "%.0f", text).appending("0"))!
                }) {
                    Text("0")
                }
                .digitKeyFrame()
                
                Button(action: {
                    text = Double(Int(text) / 10)
                }) {
                    Image(systemName: "delete.left")
                }
                .digitKeyFrame()
            }
        }
        .font(.title2)
    }
}


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
    public init( placeholder: String, text: Binding<String>, presentingModal:Bool, alignment: TextViewAlignment = .center,style: KeyboardStyle = .numbers, locale: Locale = .current){
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
public struct EnteredText: View {
	@Binding var text:String
	@Binding var presentedAsModal: Bool
    @State var crownEditableText: Double = 0
    var style: KeyboardStyle
    var watchOSDimensions: CGRect?
    private var locale: Locale
    
	public init(text: Binding<String>, presentedAsModal:
                Binding<Bool>, style: KeyboardStyle, locale: Locale = .current){
		_text = text
		_presentedAsModal = presentedAsModal
        self.style = style
        self.locale = locale
        let device = WKInterfaceDevice.current()
        watchOSDimensions = device.screenBounds
	}
	public var body: some View{
		VStack(alignment: .trailing) {
                Button(action:{
                    presentedAsModal.toggle()
                }){
                    ZStack(content: {
                        Text("1")
                            .font(.title2)
                            .foregroundColor(.clear
                            )
                    })
                    Text("\(text) \(crownEditableText)")
                        .font(.title2)
                        .frame(height: watchOSDimensions!.height * 0.15, alignment: .trailing)
                        .focusable(true)
                        .digitalCrownRotation($crownEditableText, from: text == "0" ? 0 : -1, through: 1, by: 1)
                }
                .buttonStyle(PlainButtonStyle())
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
                
                DigetPadView(text: $text, style: style, locale: locale)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
		}
        .toolbar(content: {
            ToolbarItem(placement: .cancellationAction){
                Button {
                    presentedAsModal.toggle()
                } label: {
                    Label("Done", systemImage: "xmark")
                        .toolbarButtonNativeLabel()
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
        VStack(spacing: 1) {
			HStack(spacing: widthSpace){
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
				}.digitKeyFrame()
				
				Button(action: {
					text.append("3")
				}) {
							Text("3")
						}.digitKeyFrame()
			}
			HStack(spacing:widthSpace){
				Button(action: {
					text.append("4")
				}) {
					Text("4")
				}.digitKeyFrame()
				Button(action: {
					text.append("5")
				}) {
					Text("5")
				}.digitKeyFrame()
				
				Button(action: {
					text.append("6")
				}) {
					Text("6")
				}.digitKeyFrame()
			}
			
			HStack(spacing:widthSpace){
				Button(action: {
					text.append("7")
				}) {
					Text("7")
				}.digitKeyFrame()
				Button(action: {
					text.append("8")
				}) {
					Text("8")
				}.digitKeyFrame()
				
				Button(action: {
					text.append("9")
				}) {
					Text("9")
				}
				.digitKeyFrame()
			}
			HStack(spacing:widthSpace) {
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
        .font(.title2)
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
#endif

#if DEBUG && os(watchOS)
struct EnteredText_Previews: PreviewProvider {
	static var previews: some View {
        ScrollableEnteredText(text: .constant(0), presentedAsModal: .constant(true))
        
        EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .numbers)
        Group {
            EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .decimal)
            EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .decimal)
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .decimal)
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
                .accessibilityElement(children: /*@START_MENU_TOKEN@*/.contain/*@END_MENU_TOKEN@*/)
                
        }
        EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .decimal).previewDevice("Apple Watch Series 6 - 40mm")
        Group {
            EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .numbers).previewDevice("Apple Watch Series 3 - 38mm")
            EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .numbers).environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge).previewDevice("Apple Watch Series 3 - 38mm")
        }
        EnteredText( text: .constant(""), presentedAsModal: .constant(true), style: .decimal).previewDevice("Apple Watch Series 3 - 42mm")
	}
}

struct Content_View_Previews: PreviewProvider {
	static var previews: some View{
		ScrollView {
			ForEach(0 ..< 4) { item in
				DigiTextView(placeholder: "Placeholder", text: .constant(""), presentingModal: false, alignment: .leading)
			}
			Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
				/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Button")/*@END_MENU_TOKEN@*/
			}
		}
	}
}

struct TextField_Previews: PreviewProvider {
	static var previews: some View{
		ScrollView{
			ForEach(0 ..< 4){ item in
				TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
			}
			Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
				/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Button")/*@END_MENU_TOKEN@*/
			}
		}
	}
}
#endif
