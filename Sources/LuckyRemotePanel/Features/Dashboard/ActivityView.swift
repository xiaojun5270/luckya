import SwiftUI

struct ActivityView: View {
    var body: some View {
        NavigationStack {
            List {
                Label("12:40 Gateway restarted", systemImage: "arrow.clockwise.circle")
                Label("12:41 RPC probe ok", systemImage: "checkmark.seal")
                Label("12:43 Auto report delivered", systemImage: "paperplane")
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("动态")
        }
    }
}
