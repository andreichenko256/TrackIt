import UIKit
import SnapKit

final class OnboardingView: UIView {
    let containerView = UIView()
    let skipButton = UIButton(type: .system)
    let nextButton = PrimaryButton(title: "Next")
    let getStartedButton = PrimaryButton(title: "Get Started")
    
    private lazy var gradientLayer = {
        $0.colors = Colors.Gradients.primaryBg
        $0.startPoint = CGPoint(x: 0.5, y: 0.0)
        $0.endPoint = CGPoint(x: 0.5, y: 1.0)
        return $0
    }(CAGradientLayer())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

private extension OnboardingView {
    func setupUI() {
        layer.insertSublayer(gradientLayer, at: 0)
        
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        getStartedButton.isHidden = true
    }
    
    func setupConstraints() {
        [containerView, skipButton, nextButton, getStartedButton].forEach {
            addSubview($0)
        }
        
        skipButton.snp.makeConstraints {
            $0.top.equalTo(safeTop).inset(16)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(skipButton.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-24)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeBottom).inset(24)
        }
        
        getStartedButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeBottom).inset(24)
        }
    }
}
