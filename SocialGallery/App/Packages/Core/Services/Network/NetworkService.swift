import UIKit

final class NetworkService {}

extension NetworkService: Networkable {
    func request(urlString: String) async throws -> Data {
        let url = URL(string: urlString)
        
        guard let url = url else {
            throw URLError(.badURL)
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        switch httpURLResponse.statusCode {
        case 200...299:
            return data
//        case 401:
//          print()
        default:
            throw URLError(.badServerResponse)
        }
    }
    
    func requestImage(urlString: String) async throws -> UIImage {
        let url = URL(string: urlString)
        guard let url = url else {
            throw URLError(.badURL)
        }
        let urlRequest = URLRequest(url: url)
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        switch httpURLResponse.statusCode {
        case 200...299:
            guard let image = UIImage(data: data) else {
                   throw URLError(.cannotDecodeContentData)
               }
            return image
        default:
            throw URLError(.badServerResponse)
        }
    }
}
