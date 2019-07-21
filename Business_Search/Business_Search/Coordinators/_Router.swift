import UIKit

protocol RouterType: class, Presentable {
	var navigationController: UINavigationController { get }
	var rootViewController: UIViewController? { get }
	func present(_ module: Presentable, animated: Bool)
	func dismissModule(animated: Bool, completion: (() -> Void)?)
	func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
	func popModule(animated: Bool)
	func setRootModule(_ module: Presentable, hideBar: Bool)
	func popToRootModule(animated: Bool)
}


final class Router: NSObject, RouterType, UINavigationControllerDelegate {
    //because it's dictionary, only one velue per key.
    private var completions: [UIViewController : () -> Void] {
        didSet {
            print("Completions.count ==> \(completions.count)")
        }
    }
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        self.completions = [:]
        super.init()
        self.navigationController.delegate = self
    }
    
    //  Computed
	var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }
    
	var hasRootController: Bool {
        return rootViewController != nil
    }
    
    func toPresentable() -> UIViewController {
        return navigationController
    }
}

extension Router {
    //  PRESENT/DISMISS
	func present(_ module: Presentable, animated: Bool = true) {
		navigationController.present(module.toPresentable(), animated: animated, completion: nil)
	}
	
	func dismissModule(animated: Bool = true, completion: (() -> Void)? = nil) {
		navigationController.dismiss(animated: animated, completion: completion)
	}
	
    //  PUSH/POP
	func push(_ module: Presentable, animated: Bool = true, completion: (() -> Void)? = nil) {
		let controller = module.toPresentable()
        //print("controller -> \(controller)\ncompletion -> \(completion)\ncompletions.count -> \(completions.count)")
        guard controller is UINavigationController == false else {return}   //Avoid pushing UINavigationController
		if let completion = completion {
			completions[controller] = completion
            print("Appended to completions")
		}
        navigationController.pushViewController(controller, animated: animated)
	}
	
	func popModule(animated: Bool = true)  {
		if let controller = navigationController.popViewController(animated: animated) {
			runCompletion(for: controller)
		}
	}
	
    //  ROOT
	func setRootModule(_ module: Presentable, hideBar: Bool = false) {
		completions.forEach { $0.value() }  // All coordinators can be deallocated
		navigationController.setViewControllers([module.toPresentable()], animated: false)
		navigationController.isNavigationBarHidden = hideBar
	}
	
	func popToRootModule(animated: Bool) {
		if let controllers = navigationController.popToRootViewController(animated: animated) {
			controllers.forEach { runCompletion(for: $0) }
		}
	}
	
    //  DE-ALLOCATION
	fileprivate func runCompletion(for controller: UIViewController) {
		guard let completion = completions[controller] else { return }
		completion()
		completions.removeValue(forKey: controller)
	}

	// MARK: UINavigationControllerDelegate
	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		// Ensure the view controller is popping
		guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
			!navigationController.viewControllers.contains(poppedViewController) else {
			return
		}
		runCompletion(for: poppedViewController)
	}
}
