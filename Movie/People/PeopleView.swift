import SwiftUI

struct PeopleView: View {
    @StateObject private var viewModel = PeopleViewModel()
    @Binding var selectedTab: Int

    var body: some View {
        TabBackground {
            VStack(alignment: .leading, spacing: 24) {
                Text("People Changes")
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal, 24)

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task {
                                await viewModel.fetchPeopleChanges()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.people) { person in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Person ID: \(person.id)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                if let adult = person.adult {
                                    Text("Adult: \(adult ? "Yes" : "No")")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.3))
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color.moviePanel)
                    }
                    .listStyle(.plain)
                    .background(Color.moviePanel)
                    .cornerRadius(34)
                    .padding(.horizontal, 18)
                    .padding(.bottom, 30)
                }
            }
            .padding(.top, 10)
        }
        .task {
            await viewModel.fetchPeopleChanges()
        }
    }
}
