import SwiftUI

struct ContentView: View {
    @Bindable var viewModel: ViewModel
    @State private var text = "Loading..."

    var body: some View {
        if viewModel.photos.isEmpty {
            Text(text)
                .multilineTextAlignment(.center)
                .padding()
                .onAppear { 
                    do {
                        try viewModel.load()
                    } catch {
                        text = error.localizedDescription
                    }
                }
        } else {
            NavigationStack { ScrollView { grid } }
        }
    }

    @ViewBuilder
    private var grid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.gridItemSize))]) {
            ForEach($viewModel.photos) { photo in
                PhotoView(model: viewModel, photo: photo, thumbnail: true)
                    .onAppear {
                        do {
                            try viewModel.showed(photo.id)
                        } catch {
                            text = error.localizedDescription
                        }
                    }
            }
        }
    }
}
