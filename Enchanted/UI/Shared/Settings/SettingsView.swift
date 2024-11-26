import SwiftUI
import AVFoundation

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var systemPrompt: String
    @Binding var vibrations: Bool
    @Binding var colorScheme: AppColorScheme
    @Binding var appUserInitials: String
    @Binding var voiceIdentifier: String
    @State private var deleteConversationsDialog = false
    var deleteAll: () -> ()
    var voices: [AVSpeechSynthesisVoice]

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(.label))
                    }
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(Color(.label))
                    
                    Spacer()
                }
            }
            .padding()
            
            Form {
                VStack(alignment: .leading) {
                    Text("System prompt")
                    TextEditor(text: $systemPrompt)
                        .font(.system(size: 13))
                        .cornerRadius(4)
                        .multilineTextAlignment(.leading)
                        .frame(minHeight: 100)
                }
                .padding(.vertical)
                
                Picker(selection: $colorScheme) {
                    ForEach(AppColorScheme.allCases, id:\.self) { scheme in
                        Text(scheme.toString).tag(scheme.id)
                    }
                } label: {
                    Label("Appearance", systemImage: "sun.max")
                        .foregroundStyle(Color.label)
                }
                
                Picker(selection: $voiceIdentifier) {
                    ForEach(voices, id:\.self.identifier) { voice in
                        Text(voice.prettyName).tag(voice.identifier)
                    }
                } label: {
                    Label("Voice", systemImage: "waveform")
                        .foregroundStyle(Color.label)
                }
                
                TextField("Initials", text: $appUserInitials)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
#if os(iOS)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
#endif
                
                Button(action: {deleteConversationsDialog.toggle()}) {
                    HStack {
                        Spacer()
                        
                        Text("Clear All Data")
                            .foregroundStyle(Color(.systemRed))
                            .padding(.vertical, 6)
                        
                        Spacer()
                    }
                }
            }
            .formStyle(.grouped)
        }
        .preferredColorScheme(colorScheme.toiOSFormat)
        .confirmationDialog("Delete All Conversations?", isPresented: $deleteConversationsDialog) {
            Button("Delete", role: .destructive) { deleteAll() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Delete All Conversations?")
        }
    }
}

#Preview {
    SettingsView(
        systemPrompt: .constant("You are an intelligent assistant solving complex problems."),
        vibrations: .constant(true),
        colorScheme: .constant(.light),
        appUserInitials: .constant("AM"),
        voiceIdentifier: .constant("sample"),
        deleteAll: {},
        voices: []
    )
}
