import UIKit

protocol ScreenBuildable {
    func makeViewController(mainDiContainer: MainDiContainerable, coreDataManager: CoreDataManagerable, networkMonitor: NetworkMonitorable) -> UIViewController
}
