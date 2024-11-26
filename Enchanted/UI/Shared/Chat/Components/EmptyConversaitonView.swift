//
//  EmptyConversaitonView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/02/2024.
//

import SwiftUI

struct EmptyConversaitonView: View, KeyboardReadable {
    @State var showPromptsAnimation = false
    var sendPrompt: (String) -> ()
#if os(iOS)
    @State var isKeyboardVisible = false
#endif

    @State var visibleItems = Set<Int>()

    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 25) {
                Text("MTM")
                    .font(Font.system(size: 46, weight: .thin))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "777777"), Color(hex: "4e4e4e"), Color(hex: "4e4e4e"), Color(hex: "#777777")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("What asset do you want to mark to market?")
                    .font(.system(size: 18))
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                #if !os(visionOS)
                    .foregroundStyle(Color(.systemGray))
                #endif
            }
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation {
                    showPromptsAnimation = true
                }
            }
        }
#if os(iOS)
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            DispatchQueue.main.async {
                withAnimation {
                    isKeyboardVisible = newIsKeyboardVisible
                }
            }
        }
#endif
    }
}

#Preview(traits: .fixedLayout(width: 1000, height: 1000)) {
    EmptyConversaitonView(sendPrompt: {_ in})
}
