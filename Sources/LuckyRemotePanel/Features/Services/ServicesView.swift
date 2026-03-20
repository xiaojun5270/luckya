import SwiftUI

struct ServicesView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @StateObject private var viewModel = ServicesViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.services) { service in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(service.name).font(.headline)
                        Spacer()
                        Text(service.status)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(statusColor(service.status).opacity(0.18))
                            .clipShape(Capsule())
                    }
                    Text(service.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .listRowBackground(Color.white.opacity(0.04))
            }
            .overlay {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.orange)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("服务")
            .task(id: sessionStore.authToken?.token) {
                viewModel.bind(sessionStore: sessionStore)
                await viewModel.load()
            }
        }
    }

    private func statusColor(_ value: String) -> Color {
        switch value {
        case "running": return .green
        case "available": return .cyan
        default: return .orange
        }
    }
}
