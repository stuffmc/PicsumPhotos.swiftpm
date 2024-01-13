import SwiftUI

@main
struct PicsumPhotos: App {
    var body: some Scene {
        WindowGroup {
            PicsumTabView()
        }
    }
}

struct PicsumTabView: View {
    @State private var viewModel = ViewModel()

    var body: some View {
        TabView {
            ContentView(viewModel: viewModel)
                .tabItem { Label("Photos", systemImage: "photo") }
            FavoritesView(viewModel: viewModel)
                .tabItem { Label("Favorites", systemImage: "star") }
        }
    }
}
