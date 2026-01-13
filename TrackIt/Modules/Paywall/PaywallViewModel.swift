import Combine
import StoreKit

final class PaywallViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let purchaseService = PurchaseService.shared

    @Published private(set) var products: [Product] = []
    @Published private(set) var isPremium = false
    @Published private(set) var error: Error?

    init() {
        bind()
    }

    func load() {
        purchaseService.loadProducts(ids: ["premium_month"])
    }

    func buy(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let product = products.first else {
            print("❌ No product loaded yet")
            completion(.failure(PurchaseError.failedVerification))
            return
        }

        Task {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verificationResult):
                    let transaction = try checkVerified(verificationResult)
                    await transaction.finish()
                    self.isPremium = true
                    completion(.success(true))
                case .userCancelled, .pending:
                    completion(.success(false))
                @unknown default:
                    completion(.success(false))
                }
            } catch {
                self.error = error
                completion(.failure(error))
            }
        }
    }

    private func bind() {
        purchaseService.productsPublisher
            .assign(to: &$products)

        purchaseService.purchaseResultPublisher
            .assign(to: &$isPremium)

        purchaseService.errorPublisher
            .sink { [weak self] error in
                self?.error = error
            }
            .store(in: &cancellables)
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw PurchaseError.failedVerification
        }
    }
}
