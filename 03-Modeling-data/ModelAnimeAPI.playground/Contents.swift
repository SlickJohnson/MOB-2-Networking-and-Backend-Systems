import Foundation
import PlaygroundSupport

typealias Titles = [String: String]

struct Anime {
  let id: String
  let titles: Titles
  let posterImage: URL
  let synopsis: String
  let averageRating: String
}

// MARK: Decodable
extension Anime: Decodable {
  enum DataKeys: String, CodingKey {
    case id
    case attributes
  }

  enum PosterImageKeys: String, CodingKey {
    case posterImage = "original"
  }

  enum AttributesKeys: String, CodingKey {
    case titles
    case synopsis
    case averageRating
    case posterImage
  }

  init(from decoder: Decoder) throws {

    let rootContainer = try decoder.container(keyedBy: DataKeys.self)

    let id = try rootContainer.decode(String.self, forKey: .id)

    let attributesContainer = try rootContainer.nestedContainer(keyedBy: AttributesKeys.self, forKey: .attributes)

    let titles = try attributesContainer.decode(Titles.self, forKey: .titles)

    let synopsis = try attributesContainer.decode( String.self, forKey: .synopsis)

    let averageRating = try attributesContainer.decode(String.self, forKey: .averageRating)

    let postImageContainer = try attributesContainer.nestedContainer(keyedBy: PosterImageKeys.self, forKey: .posterImage)

    let posterImage = try postImageContainer.decode(URL.self, forKey: .posterImage)

    self.init(id: id, titles: titles, posterImage: posterImage, synopsis: synopsis, averageRating: averageRating)
  }
}

struct AnimeList: Decodable {
  let data: [Anime]
}

enum NetworkError: Error {
  case unknown
  case couldNotParseJSON
}

class Networking {
  let session = URLSession.shared
  let animeURL = URL(string: "https://kitsu.io/api/edge/anime/")!

  func getAnimeList(completion: @escaping ([Anime]) -> Void) {
    let request = URLRequest(url: animeURL)

    session.dataTask(with: request) { (data, resp, err) in
      guard let data = data else { return }
      guard let animeList = try? JSONDecoder().decode(AnimeList.self, from: data) else { return }

      let animes = animeList.data

      completion(animes)
      }.resume()

  }
}

let networking = Networking()
networking.getAnimeList() { (result) in
  print(result)
}

PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true
