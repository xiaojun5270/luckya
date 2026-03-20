import SwiftUI

struct ActivityView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            List {
                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundStyle(.orange)
                    }
                    .listRowBackground(Color.orange.opacity(0.08))
                }

                if viewModel.activities.isEmpty {
                    Section {
                        Text("暂无动态数据")
                            .foregroundStyle(.secondary)
                    }
                    .listRowBackground(Color.white.opacity(0.04))
                } else {
                    ForEach(viewModel.activities) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top) {
                                Circle()
                                    .fill(.cyan)
                                    .frame(width: 8, height: 8)
                                    .padding(.top, 5)

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.title)
                                        .font(.headline)
                                        .foregroundStyle(.white)

                                    Text(item.detail)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .textSelection(.enabled)

                                    Text(item.timestamp)
                                        .font(.caption2)
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(Color.white.opacity(0.04))
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("动态")
            .task(id: sessionStore.authToken?.token) {
                viewModel.bind(sessionStore: sessionStore)
                await viewModel.load()
            }
        }
    }
}
