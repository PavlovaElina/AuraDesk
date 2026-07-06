import SwiftUI

struct NoteWidgetView: View {
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Note", systemImage: "note.text")
                .font(.headline)

            TextEditor(text: $text)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }
        .padding(18)
    }
}

#Preview {
    NoteWidgetView(text: .constant("Write something..."))
        .frame(width: 260, height: 180)
}
