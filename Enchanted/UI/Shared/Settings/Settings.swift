import SwiftUI
import Combine

struct Settings: View {
    var languageModelStore = LanguageModelStore.shared
    var conversationStore = ConversationStore.shared
    var swiftDataService = SwiftDataService.shared
    
    @AppStorage("systemPrompt") private var systemPrompt: String = ""
    @AppStorage("vibrations") private var vibrations: Bool = true
    @AppStorage("colorScheme") private var colorScheme = AppColorScheme.system
    @AppStorage("appUserInitials") private var appUserInitials: String = ""
    @AppStorage("voiceIdentifier") private var voiceIdentifier: String = ""
    
    @StateObject private var speechSynthesiser = SpeechSynthesizer.shared
    @Environment(\.presentationMode) var presentationMode

    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var cancellable: AnyCancellable?
    
    private func deleteAll() {
        Task {
            try? await conversationStore.deleteAllConversations()
            try? await languageModelStore.deleteAllModels()
        }
    }

    var body: some View {
        SettingsView(
            systemPrompt: $systemPrompt,
            vibrations: $vibrations,
            colorScheme: $colorScheme,
            appUserInitials: $appUserInitials,
            voiceIdentifier: $voiceIdentifier,
            deleteAll: deleteAll,
            voices: speechSynthesiser.voices
        )
        .frame(maxWidth: 700)
        #if os(visionOS)
        .frame(minWidth: 600, minHeight: 800)
        #endif
        .onAppear {
            cancellable = timer.sink { _ in
                speechSynthesiser.fetchVoices()
            }
        }
        .onDisappear {
            cancellable?.cancel()
        }
    }
}

#Preview {
    Settings()
}
