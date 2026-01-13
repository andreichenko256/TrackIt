import UIKit
import SnapKit

final class PremiumBadge: UIView {
    
    var isPremium: Bool = false {
        didSet {
            updateAppearance(isPremium: self.isPremium)
        }
    }
    
    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .white
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PremiumBadge {
    func setupUI() {
        backgroundColor = .systemRed
        layer.cornerRadius = 12
    }
    
    func setupConstraints() {
        [titleLabel].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(6)
        }
    }
    
    func updateAppearance(isPremium: Bool) {
        if isPremium {
            backgroundColor = .systemGreen
            titleLabel.text = "You are Premium!"
        } else {
            backgroundColor = .systemRed
            titleLabel.text = "Buy Premium!"
        }
    }
}
