import UIKit
import SnapKit

final class PageViewController: UIViewController {
    var isLastPage = false
    
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
        pageView.titleLabel.text = model.title
        pageView.descriptionLabel.text = model.description
        pageView.imageView.image = model.image
    }
}

