import Foundation
import PlaygroundSupport

struct Joke: Decodable {
  var id: Int
  var type: String
  var setup: String
  var punchline: String
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum JokeError: Error {
    case couldNotParse
    case noData
}

class Networking {
    func fetchJoke(completion: @escaping (Result<Joke?>) -> Void) {
        let session = URLSession.shared

        let url = URL(string: "https://08ad1pao69.execute-api.us-east-1.amazonaws.com/dev/random_joke")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { (data, response, error) -> Void in
            
            if let error = error {
                return completion(Result.failure(error))
            }
            
            guard let data = data else {
                return completion(Result.failure(JokeError.noData))
            }
        
            let joke = try? JSONDecoder().decode(Joke.self, from: data)

            let result = Result.success(joke)
            
            completion(result)
        }.resume()
    }
}

let networking = Networking()
networking.fetchJoke { (joke) in
    print(joke)
}

PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true

