import UIKit
import SnapKit
import Combine

final class PaywallViewController: UIViewController {
    private let viewModel = PaywallViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private var paywallView: PaywallView {
        return view as! PaywallView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        bindViewModel()
        viewModel.load()
    }
    
    override func loadView() {
        view = PaywallView()
    }
}

private extension PaywallViewController {
    func bindViewModel() {
        viewModel.$products
            .receive(on: RunLoop.main)
            .sink { [weak self] products in
                guard let product = products.first else { return }
                self?.paywallView.configure(with: product)
            }
            .store(in: &cancellables)

        viewModel.$isPremium
            .receive(on: RunLoop.main)
            .sink { [weak self] isPremium in
                if isPremium {
                    self?.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)

        viewModel.$error
            .compactMap { $0 }
            .sink { error in
                print("❌ Purchase error:", error)
            }
            .store(in: &cancellables)
    }
}

private extension PaywallViewController {
    func setupActions() {
        continueButtonTapped()
        laterButtonTapped()
    }
    
    func continueButtonTapped() {
        paywallView.continueButton.onTap = { [weak self] in
            self?.viewModel.buy { [weak self] result in
                switch result {
                case .success(let success):
                    if success {
                        UserDefaultsStorage.shared.set(true, for: .isPremiumUser)
                        self?.dismiss(animated: true)
                    } else {
                        print("User cancelled or pending")
                    }
                case .failure(let error):
                    print("Purchase failed:", error)
                }
            }
        }
    }
    
    func laterButtonTapped() {
        paywallView.laterButton.onTap = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
