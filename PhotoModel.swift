import SwiftUI

enum PicsumError: String, Error {
    case couldNotFindData = "Couldn't find Picsum Data"
}

@Observable
class ViewModel {
    var photos = [Photo]()
    var images = [String: Image]()
    let gridItemSize = 177.0

    private var appeared = Set<String>()
    private var page = 1
    private let pageLength = 30

    func load() throws {
        Task { @MainActor in
            guard let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=\(pageLength)") else {
                throw PicsumError.couldNotFindData
            }
            let urlSession = URLSession.shared
            let (data, _) = try! await urlSession.data(from: url)
            photos += try JSONDecoder().decode([Photo].self, from: data)
        }
    }

    func showed(_ id: String) throws {
        appeared.insert(id)
        if appeared.count == page * pageLength {
            page += 1
            try load()
        }
    }
}

struct Photo: Identifiable, Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case author
        case url
        case downloadUrl = "download_url"
    }

    var id: String
    var width: Int
    var height: Int
    var author: String
    var url: String
    var downloadUrl: String
    var isFavorite = false

    static var sample: Photo {
        Photo(id: "0", width: 5614, height: 3744, author: "Alejandro Escamilla",
              url: "https://unsplash.com/photos/yC-Yzbqy7PY",
              downloadUrl: "https://picsum.photos/id/0/5000/3333")
    }
}
/*
"id": "0",
"author": "Alejandro Escamilla",
"width": 5616,
"height": 3744,
"url": "https://unsplash.com/photos/yC-Yzbqy7PY",
"download_url": "https://picsum.photos/id/0/5000/3333"
*/
