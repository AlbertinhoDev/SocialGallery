import UIKit

final class MainFlowCoordinator {
    private let router: Router
    private let screenBuilder: ScreenBuildable
    private let mainDiContainer: MainDiContainerable
    private let coreDataManager: CoreDataManagerable
    private let networkMonitor: NetworkMonitorable
    
    init(router: Router,
         screenBuilder: ScreenBuildable = ScreenBuilder(),
         mainDiContainer: MainDiContainerable = MainDiContainer(),
         coreDataManager: CoreDataManagerable = CoreDataManager(),
         networkMonitor: NetworkMonitorable = NetworkMonitor()
    ) {
        self.router = router
        self.screenBuilder = screenBuilder
        self.mainDiContainer = mainDiContainer
        self.coreDataManager = coreDataManager
        self.networkMonitor = networkMonitor
    }
}

extension MainFlowCoordinator: Coordinator {
    func start() {
        let viewController = screenBuilder.makeViewController(mainDiContainer: mainDiContainer, coreDataManager: coreDataManager, networkMonitor: networkMonitor)
        router.setRoot(viewController: viewController, animated: true)
    }
}
