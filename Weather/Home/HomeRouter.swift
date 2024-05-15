import UIKit

final class HomeRouter {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func present(_ view: UIViewController){
        navigationController.pushViewController(view, animated: true)
    }
}
