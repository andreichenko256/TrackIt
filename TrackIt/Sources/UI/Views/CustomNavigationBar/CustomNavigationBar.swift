import UIKit
import SnapKit

final class CustomNavigationBar: UIView {
    let editMenu = EditMenu()
    let premiumBadge = PremiumBadge()
    
    private lazy var titleLabel = {
        $0.text = "Track It!"
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 0
        $0.textColor = .white
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

private extension CustomNavigationBar {
    func setupUI() {
        backgroundColor = .clear
    }
    
    func setupConstraints() {
        [titleLabel, editMenu, premiumBadge].forEach {
            addSubview($0)
        }
        
        premiumBadge.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        editMenu.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
