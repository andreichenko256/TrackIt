import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    private var pages: [UIViewController] = []
    private var currentPageIndex = 0
    private var pageModels: [PageModel] = []
    
    private var onboardingView: OnboardingView {
        return view as! OnboardingView
    }
    
    private let pageVC = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal,
                                              options: nil)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = OnboardingView()
    }
}

private extension OnboardingViewController {
    func setupPageVC() {
        onboardingView.containerView.addSubview(pageVC.view)
        
        pageVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addChild(pageVC)
        
        if let firstPage = pages.first {
            pageVC.setViewControllers(
                [firstPage],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
        
        pageVC.didMove(toParent: self)
    }
}
