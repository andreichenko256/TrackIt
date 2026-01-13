import UIKit
import SnapKit

final class PaywallViewController: UIViewController {
    
    private var paywallView: PaywallView {
        return view as! PaywallView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    override func loadView() {
        view = PaywallView()
    }
}

private extension PaywallViewController {
    func setupActions() {
        continueButtonTapped()
        laterButtonTapped()
    }
    
    func continueButtonTapped() {
        paywallView.continueButton.onTap = { [weak self] in
            print("continue")
        }
            
    }
    
    func laterButtonTapped() {
        paywallView.laterButton.onTap = { [weak self] in
            print("later")
        }
    }
}
