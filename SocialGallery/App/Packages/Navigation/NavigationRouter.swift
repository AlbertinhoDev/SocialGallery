import UIKit

final class NavigationRouter {
    private let navigtionController: UINavigationController
    
    init(navigtionController: UINavigationController) {
        self.navigtionController = navigtionController
    }
}

extension NavigationRouter: Router {
    func setRoot(viewController: UIViewController, animated: Bool) {
        navigtionController.setViewControllers([viewController], animated: animated)
    }
}
