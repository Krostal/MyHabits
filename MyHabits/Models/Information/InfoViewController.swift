import UIKit

class InfoViewController: UIViewController {
    
    private enum Constants {
        static let verticalSpacing: CGFloat = 12.0
        static let horizontalPadding: CGFloat = 16.0
        static let titleHeight: CGFloat = 24.0
    }
    
    private lazy var infoScrollView: UIScrollView = {
        let infoScrollView = UIScrollView()
        infoScrollView.backgroundColor = .white
        infoScrollView.translatesAutoresizingMaskIntoConstraints = false
        return infoScrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var infoText: UILabel = {
        let infoText = UILabel()
        infoText.translatesAutoresizingMaskIntoConstraints = false
        infoText.backgroundColor = .clear
        infoText.text = InformationText().infoTextDescription
        infoText.font = .systemFont(ofSize: 17, weight: .regular)
        infoText.tintColor = .black
        infoText.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = Constants.verticalSpacing
        let attributedString = NSAttributedString(string: InformationText().infoTextDescription, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        infoText.attributedText = attributedString
        
        return infoText
    }()
    
    private lazy var titleLabelText: UILabel = {
        let titleLabelText = UILabel()
        titleLabelText.translatesAutoresizingMaskIntoConstraints = false
        titleLabelText.backgroundColor = .clear
        titleLabelText.text = InformationText().titleLabelText
        titleLabelText.font = .systemFont(ofSize: 20, weight: .semibold)
        return titleLabelText
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.safeAreaLayoutGuide.owningView?.backgroundColor = UIColor(named: "LightGrayColor")
        addSubviews()
        setupConstraints()
        setupContentOfScrollView()
        setupNavigationBar()
    }
    
    private func addSubviews() {
        view.addSubview(infoScrollView)
        infoScrollView.addSubview(contentView)
        contentView.addSubview(infoText)
        contentView.addSubview(titleLabelText)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            infoScrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            infoScrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            infoScrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            infoScrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: infoScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: infoScrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: infoScrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: infoScrollView.bottomAnchor)
        ])
    }
    
    private func setupContentOfScrollView() {
        
        NSLayoutConstraint.activate([
        
            titleLabelText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            titleLabelText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            titleLabelText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            titleLabelText.heightAnchor.constraint(equalToConstant: Constants.titleHeight),
            
            infoText.topAnchor.constraint(equalTo: titleLabelText.bottomAnchor, constant: Constants.verticalSpacing),
            infoText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            infoText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            infoText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalSpacing)
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Информация"
        navigationController?.navigationBar.backgroundColor = UIColor(named: "LightGrayColor")
    }

}
