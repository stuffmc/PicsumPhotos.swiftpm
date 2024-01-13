import SwiftUI

extension Image {
    var resizable: some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                self
                    .resizable()
                    .scaledToFill()
                )
            .clipShape(Rectangle())
    }
}

struct PhotoView: View {
    @Bindable var model: ViewModel
    @Binding var photo: Photo
    var thumbnail = false
    let size = 200.0

    var body: some View {
        if let image = model.images[photo.id] {
            zstack(for: image)
        } else {
            if let url = URL(string: photo.downloadUrl) {
                AsyncImage(url: url) { phase in
                    image(with: phase)
                }
            } else {
                Text("\(photo.id) has no image")
            }
        }
    }

    @ViewBuilder
    private func image(with phase: AsyncImagePhase) -> some View {
        if let image = phase.image {
            NavigationLink {
                image.resizable
                    .navigationTitle(photo.author)
            } label: {
                zstack(for: image)
            }
            .onAppear {
                model.images[photo.id] = image
            }
        } else if phase.error != nil {
            Text(phase.error?.localizedDescription ?? "Error occured")
        } else {
            ProgressView()
                .frame(width: size, height: size)
        }
    }

    private func zstack(for image: Image) -> some View {
        ZStack {
            image.resizable
            if thumbnail {
                button
            }
        }
    }

    private var button: some View {
        Button(photo.isFavorite ? "Unfave" : "Fave",
               systemImage: photo.isFavorite ? "star.fill" : "star") {
            photo.isFavorite.toggle()
        }
               .buttonStyle(.borderedProminent)
               .padding(.top, 10)
               .padding(.trailing, 20)
               .frame(width: size, height: size, alignment: .topTrailing)
    }
}
