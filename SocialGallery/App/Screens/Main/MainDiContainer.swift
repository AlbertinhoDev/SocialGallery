import UIKit

final class MainDiContainer: MainDiContainerable {
    var mainApiService: MainApiServicable
    
    init(mainApiService: MainApiServicable = MainApiService()) {
        self.mainApiService = mainApiService
    }
}

