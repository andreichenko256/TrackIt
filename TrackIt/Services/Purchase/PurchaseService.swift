import Combine
import StoreKit

@MainActor
final class PurchaseService {
    static let shared = PurchaseService()
    
    private init() {
        startTransactionListener()
    }
    
    let productsPublisher = CurrentValueSubject<[Product], Never>([])
    let purchaseResultPublisher = PassthroughSubject<Bool, Never>()
    let errorPublisher = PassthroughSubject<Error, Never>()
    
    func loadProducts(ids: [String]) {
        Task {
            do {
                let products = try await Product.products(for: ids)
                self.productsPublisher.send(products)
            } catch {
                self.errorPublisher.send(error)
            }
        }
    }
    
    func purchase(_ product: Product) {
        Task {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verificationResult):
                    let transaction = try checkVerified(verificationResult)
                    await transaction.finish()
                    purchaseResultPublisher.send(true)
                case .userCancelled, .pending:
                    purchaseResultPublisher.send(false)
                @unknown default:
                    purchaseResultPublisher.send(false)
                }
            } catch {
                errorPublisher.send(error)
            }
        }
    }
    
    func restorePurchases() {
        Task {
            do {
                for await result in Transaction.currentEntitlements {
                    _ = try checkVerified(result)
                }
            } catch {
                errorPublisher.send(error)
            }
        }
    }
    
    private func startTransactionListener() {
        Task.detached { [weak self] in
            for await transaction in Transaction.updates {
                guard let self = self else { continue }
                do {
                    let verified = try await self.checkVerified(transaction)
                    await verified.finish()
                    self.purchaseResultPublisher.send(true)
                } catch {
                    self.errorPublisher.send(error)
                }
            }
        }
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
