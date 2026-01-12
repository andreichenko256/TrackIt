import UIKit
import SnapKit

final class PrimaryButton: UIView {
    var onTap: VoidBlock?
    
    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .white
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
        setupConstraints()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }
}

private extension PrimaryButton {
    func setupUI() {
        backgroundColor = Colors.primary
        layer.cornerRadius = 16
    }
    
    func setupConstraints() {
        [titleLabel].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupGestureRecognizer() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
        onTap?()
    }
}
