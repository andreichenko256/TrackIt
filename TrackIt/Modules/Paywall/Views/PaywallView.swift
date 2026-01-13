import UIKit
import SnapKit
import StoreKit

final class PaywallView: UIView {
    
    lazy var continueButton = {
        $0.backgroundColor = .systemYellow
        return $0
    }(PrimaryButton(title: "Continue"))
    
    lazy var laterButton = {
        $0.backgroundColor = .systemGray
        return $0
    }(PrimaryButton(title: "Maybe later"))
    
    private let unlimitedBenefit = BenefitItemView(title: "Unlimited tracking")
    private let advanceBenefit = BenefitItemView(title: "Advanced statistics")
    private let remindersBenefit = BenefitItemView(title: "Smart reminders")
    
    private lazy var benefitsStackView = {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .leading
        $0.distribution = .fillEqually
        return $0
    }(UIStackView(arrangedSubviews: [
        unlimitedBenefit,
        advanceBenefit,
        remindersBenefit
    ]))
    
    private lazy var titleLabel: UILabel = {
        let fullText = "Get more with\nTrack It Pro"
        let highlightedText = "Track It Pro"
        
        let attributed = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 34, weight: .bold),
                .foregroundColor: UIColor.label
            ]
        )
        
        if let range = fullText.range(of: highlightedText) {
            let nsRange = NSRange(range, in: fullText)
            attributed.addAttributes(
                [.foregroundColor: Colors.primary],
                range: nsRange
            )
        }
        
        $0.attributedText = attributed
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var divider = {
        $0.backgroundColor = .systemGray.withAlphaComponent(0.1)
        $0.layer.cornerRadius = 6
        $0.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        return $0
    }(UIView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PaywallView {
    func setupUI() {
        backgroundColor = .systemBackground
    }
    
    func setupConstraints() {
        [titleLabel, benefitsStackView, laterButton, continueButton, divider].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeTop).inset(32)
            $0.centerX.equalToSuperview()
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        benefitsStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(64)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        continueButton.snp.makeConstraints {
            $0.bottom.equalTo(laterButton.snp.top).offset(-16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        laterButton.snp.makeConstraints {
            $0.bottom.equalTo(safeBottom).inset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}

extension PaywallView {
    func configure(with product: Product) {
        let price = product.displayPrice
        continueButton.setTitle("Continue for \(price)")
    }
}
