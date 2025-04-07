import UIKit

public protocol Networkable {
    func request(urlString: String) async throws -> Data
    func requestImage(urlString: String) async throws -> UIImage
}
