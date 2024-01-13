import SwiftUI

struct FavoritesView: View {
    @Bindable var viewModel: ViewModel

    var body: some View {
        if viewModel.photos.filter({ $0.isFavorite }).isEmpty {
            Text("No favorites yet")
                .font(.largeTitle)
        } else {
            NavigationStack { ScrollView { grid } }
        }
    }

    @ViewBuilder
    private var grid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.gridItemSize))]) {
            ForEach($viewModel.photos) {
                if $0.wrappedValue.isFavorite {
                    PhotoView(model: viewModel, photo: $0, thumbnail: true)
                }
            }
        }
    }
}
