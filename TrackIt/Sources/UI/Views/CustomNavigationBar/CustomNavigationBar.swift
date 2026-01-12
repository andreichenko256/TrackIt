import UIKit
import SnapKit

final class CustomNavigationBar: UIView {
    
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
        
    }
    
    func setupConstraints() {
        [titleLabel].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}
