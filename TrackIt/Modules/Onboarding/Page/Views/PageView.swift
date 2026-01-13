import UIKit
import SnapKit

final class PageView: UIView {
    lazy var imageView = {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    lazy var titleLabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    lazy var descriptionLabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = .systemFont(ofSize: 22, weight: .medium)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PageView {
    func setupConstraints() {
        [titleLabel, descriptionLabel, imageView].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(titleLabel)
            $0.bottom.lessThanOrEqualToSuperview().inset(20)
            $0.height.equalTo(300).priority(.high)
        }
    }
}
