import UIKit

final class MainApiService {
    private let decoderService: DecoderServicable
    private let networkService: Networkable
    
    init(decoderService: DecoderServicable = DecoderService(), networkService: Networkable = NetworkService()) {
        self.decoderService = decoderService
        self.networkService = networkService
    }
}

extension MainApiService: MainApiServicable {
    func loadImage(urlString: String) async throws -> UIImage? {
        let image = try await networkService.requestImage(urlString: urlString)
        return image
    }
    
    func loadData(urlString: String) async throws -> [ResponseModel] {
        let data = try await networkService.request(urlString: urlString)
        let response: [ResponseModel] = try decoderService.decode(data: data)
        return response
    }
}
