import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    private var pages: [PageViewController] = []
    private var currentPageIndex = 0
    private var pageModels: [PageModel] = []
    
    private var onboardingView: OnboardingView {
        return view as! OnboardingView
    }
    
    private let pageVC = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal,
                                              options: nil)
    
    private let storage = UserDefaultsStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageModels()
        createPages()
        setupPageVC()
        setupActions()
        updateButtons()
    }
    
    override func loadView() {
        view = OnboardingView()
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PageViewController,
              currentVC.pageIndex > 0 else {
            return nil
        }
        return pages[currentVC.pageIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PageViewController,
              currentVC.pageIndex < pages.count - 1 else {
            return nil
        }
        return pages[currentVC.pageIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first as? PageViewController else {
            return
        }
        currentPageIndex = currentVC.pageIndex
        updateButtons()
    }
}

private extension OnboardingViewController {
    func setupPageModels() {
        pageModels = OnboardingFactory.make()
    }
    
    func createPages() {
        pages = pageModels.map { model in
            let pageVC = PageViewController()
            pageVC.configure(with: model)
            pageVC.isLastPage = model.currentIndex == pageModels.count - 1
            return pageVC
        }
    }
    
    func setupPageVC() {
        pageVC.dataSource = self
        pageVC.delegate = self
        
        onboardingView.containerView.addSubview(pageVC.view)
        
        pageVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addChild(pageVC)
        
        if let firstPage = pages.first {
            pageVC.setViewControllers(
                [firstPage],
                direction: .forward,
                animated: false,
                completion: nil
            )
        }
        
        pageVC.didMove(toParent: self)
    }
    
    func setupActions() {
        onboardingView.skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        onboardingView.nextButton.onTap = { [weak self] in
            self?.nextTapped()
        }
        onboardingView.getStartedButton.onTap = { [weak self] in
            self?.getStartedTapped()
        }
    }
    
    @objc func skipTapped() {
        finishOnboarding()
    }
    
    func nextTapped() {
        guard currentPageIndex < pages.count - 1 else {
            finishOnboarding()
            return
        }
        
        let nextIndex = currentPageIndex + 1
        let nextPage = pages[nextIndex]
        
        pageVC.setViewControllers(
            [nextPage],
            direction: .forward,
            animated: true,
            completion: nil
        )
        
        currentPageIndex = nextIndex
        updateButtons()
    }
    
    func getStartedTapped() {
        finishOnboarding()
    }
    
    func updateButtons() {
        let isLastPage = currentPageIndex == pages.count - 1
        
        onboardingView.nextButton.isHidden = isLastPage
        onboardingView.getStartedButton.isHidden = !isLastPage
    }
    
    func finishOnboarding() {
        storage.set(true, for: .isOnboardingShown)
        
        guard let windowScene = view.window?.windowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        window.rootViewController = HomeViewController()
        window.makeKeyAndVisible()
    }
}
