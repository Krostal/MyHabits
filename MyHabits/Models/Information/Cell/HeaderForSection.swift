import UIKit

class HeaderForSection: UIView {
    
    private lazy var headerForInfoView: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Привычка за 21 день"
        title.font = .systemFont(ofSize: 20, weight: .semibold)
        return title
    }()
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: frame.width, height: 24)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerForInfoView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        let safeAreaGuide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            headerForInfoView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 12),
            headerForInfoView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            headerForInfoView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: 16)
        ])
    }
            
}

