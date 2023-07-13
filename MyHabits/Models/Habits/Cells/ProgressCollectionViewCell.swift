import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    var habit: Habit?
    
    private lazy var motivationLabel: UILabel = {
        let motivationLabel = UILabel()
        motivationLabel.translatesAutoresizingMaskIntoConstraints = false
        motivationLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        motivationLabel.textColor = .systemGray
        return motivationLabel
    }()
    
    private lazy var progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        progressLabel.textColor = .systemGray
        return progressLabel
    }()
    
    private lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.layer.cornerRadius = 5
        progressBar.trackTintColor = UIColor(named: "ProgressBackgrounColor")
        progressBar.progressTintColor = UIColor(named: "PurpleColor")
        return progressBar
    }()
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
    }
    
    private func setupSubviews() {
        contentView.addSubview(motivationLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(progressBar)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            motivationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            motivationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            motivationLabel.widthAnchor.constraint(equalToConstant: 216),
            motivationLabel.heightAnchor.constraint(equalToConstant: 18),
            
            progressLabel.centerYAnchor.constraint(equalTo: motivationLabel.centerYAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressLabel.heightAnchor.constraint(equalToConstant: 18),
            
            progressBar.topAnchor.constraint(lessThanOrEqualTo: motivationLabel.bottomAnchor, constant: 10),
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressBar.heightAnchor.constraint(equalToConstant: 7),
            progressBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupSubviews()
        setupLayouts()
    }
    
    func update() {
        progressLabel.text = HabitsStore.shared.todayProgress.formatted(.percent)
        progressBar.progress = HabitsStore.shared.todayProgress
        switch progressBar.progress {
        case 1:
            motivationLabel.text = "Ты молодец! Так держать!"
        default:
            motivationLabel.text = "У тебя получится!"
        }

    }

}
