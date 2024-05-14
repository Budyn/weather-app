import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = buildAppWindow()
    
        window.makeKeyAndVisible()
        self.window = window

        return true
    }

    private func buildAppWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = buildHome()
        return window
    }

    private func buildHome() -> UIViewController {
        let weatherService = WeatherServiceImpl()
        let viewModel = HomeViewModel(weatherService: weatherService)
        let presenter = HomePresenter()
        let view = HomeViewController(
            state: presenter.makeViewState(from: viewModel.state),
            viewModel: viewModel
        )
        return view
    }
}
