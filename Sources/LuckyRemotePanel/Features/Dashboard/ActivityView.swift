import SwiftUI

struct ActivityView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @StateObject private var viewModel: DashboardViewModel

    init() {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(sessionStore: SessionStore()))
    }

    var body: some View {
        NavigationStack {
            List(viewModel.activities) { item in
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                    Text(item.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(item.timestamp)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                .listRowBackground(Color.white.opacity(0.04))
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("动态")
            .task {
                viewModel.bind(sessionStore: sessionStore)
                await viewModel.load()
            }
        }
    }
}
