import UIKit

final class ScreenBuilder {}

extension ScreenBuilder: ScreenBuildable {
    func makeViewController(mainDiContainer: MainDiContainerable, coreDataManager: CoreDataManagerable, networkMonitor: NetworkMonitorable) -> UIViewController {
        let viewController = MainViewController()
        let presenter = MainPresenter(mainApiService: mainDiContainer.mainApiService, coreDataManager: coreDataManager, networkMonitor: networkMonitor)
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
