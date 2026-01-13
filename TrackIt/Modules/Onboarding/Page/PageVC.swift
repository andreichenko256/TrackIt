import UIKit
import SnapKit

final class PageViewController: UIViewController {
    var isLastPage = false
    var pageIndex: Int = 0
    
    private var pageView: PageView {
        return view as! PageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = PageView()
    }
}

extension PageViewController {
    func configure(with model: PageModel) {
        pageIndex = model.currentIndex
        pageView.titleLabel.text = model.title
        pageView.descriptionLabel.text = model.description
        pageView.imageView.image = model.image
    }
}

