import UIKit

protocol MainApiServicable {
    func loadData(urlString: String) async throws -> [ResponseModel]
    func loadImage(urlString: String) async throws -> UIImage?
}
