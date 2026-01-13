import UIKit
import SnapKit

final class BenefitItemView: UIView {
    private lazy var checkMarkImageView = {
        $0.tintColor = .systemGreen
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { make in
            make.size.equalTo(34)
        }
        return $0
    }(UIImageView(image: .checkmark))
    
    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 24, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BenefitItemView {
    func setupConstraints() {
        [checkMarkImageView, titleLabel].forEach {
            addSubview($0)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(checkMarkImageView)
            $0.leading.equalTo(checkMarkImageView.snp.trailing).offset(8)
        }
    }
}
