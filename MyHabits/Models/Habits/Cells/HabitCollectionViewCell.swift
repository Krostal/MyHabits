import UIKit

typealias Action = () -> Void?

final class HabitCollectionViewCell: UICollectionViewCell {
    
    var habit: Habit?
    var progressCell: ProgressCollectionViewCell?
    
    private lazy var clikableContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var habitName: UILabel = {
        let habitName = UILabel()
        habitName.translatesAutoresizingMaskIntoConstraints = false
        habitName.numberOfLines = 2
        habitName.font = .systemFont(ofSize: 17, weight: .semibold)
        return habitName
    }()
    
    private lazy var habitTime: UILabel = {
        let habitTime = UILabel()
        habitTime.translatesAutoresizingMaskIntoConstraints = false
        habitTime.font = .systemFont(ofSize: 12, weight: .regular)
        habitTime.textColor = .systemGray2
        return habitTime
    }()
    
    private lazy var habitCounter: UILabel = {
        let habitCounter = UILabel()
        habitCounter.translatesAutoresizingMaskIntoConstraints = false
        habitCounter.font = .systemFont(ofSize: 13, weight: .regular)
        habitCounter.textColor = .systemGray
        return habitCounter
    }()
    
    private lazy var trackMarker: UIButton = {
        let trackMarker = UIButton()
        trackMarker.translatesAutoresizingMaskIntoConstraints = false
        trackMarker.clipsToBounds = true
        trackMarker.layer.borderWidth = 3
        trackMarker.layer.cornerRadius = 19
        trackMarker.addTarget(self, action: #selector(trackHabit), for: .touchUpInside)
        trackMarker.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        trackMarker.setBackgroundImage(UIImage(systemName: ""), for: .normal)
        return trackMarker
    }()
    
    var onLabelTapped: Action?
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.isUserInteractionEnabled = true
    }
    
    private func setupSubviews() {
        contentView.addSubview(clikableContainer)
        clikableContainer.addSubview(habitName)
        clikableContainer.addSubview(habitTime)
        clikableContainer.addSubview(habitCounter)
        contentView.addSubview(trackMarker)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            clikableContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            clikableContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            clikableContainer.widthAnchor.constraint(equalToConstant: 220),
            
            habitName.topAnchor.constraint(equalTo: clikableContainer.topAnchor, constant: 20),
            habitName.leadingAnchor.constraint(equalTo: clikableContainer.leadingAnchor, constant: 20),
            habitName.widthAnchor.constraint(equalTo: clikableContainer.widthAnchor),
            
            habitTime.topAnchor.constraint(equalTo: habitName.bottomAnchor, constant: 4),
            habitTime.leadingAnchor.constraint(equalTo: clikableContainer.leadingAnchor, constant: 20),
            habitTime.widthAnchor.constraint(equalTo: clikableContainer.widthAnchor),
            habitTime.heightAnchor.constraint(equalToConstant: 16),
            
            habitCounter.topAnchor.constraint(lessThanOrEqualTo: habitTime.bottomAnchor, constant: 30),
            habitCounter.leadingAnchor.constraint(equalTo: clikableContainer.leadingAnchor, constant: 20),
            habitCounter.widthAnchor.constraint(equalToConstant: 188),
            habitCounter.heightAnchor.constraint(equalToConstant: 18),
            habitCounter.bottomAnchor.constraint(equalTo: clikableContainer.bottomAnchor, constant: -20),
            
            trackMarker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trackMarker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            trackMarker.widthAnchor.constraint(equalToConstant: 38),
            trackMarker.heightAnchor.constraint(equalToConstant: 38)
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
        addTarget()
    }
    
    
    private func addTarget() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOnLabel))
        clikableContainer.isUserInteractionEnabled = true
        clikableContainer.addGestureRecognizer(gesture)
    }
    
    func setup(with habit: Habit, progressCell: ProgressCollectionViewCell) {
        self.habit = habit
        self.progressCell = progressCell
        
        habitName.text = habit.name
        habitName.textColor = habit.color
        habitTime.text = habit.dateString
        trackMarker.layer.borderColor = habit.color.cgColor
        trackMarker.tintColor = habit.color
        habitCounter.text = "Счетчик: \(habit.trackDates.count)"
        if habit.isAlreadyTakenToday {
            trackMarker.isSelected = true
        }
        
        
    }
    
    @objc
    private func tapOnLabel() {
        onLabelTapped?()
    }
    
    @objc
    private func trackHabit() {
        
        if let habit = self.habit {
            if trackMarker.isSelected == false {
                trackMarker.isSelected = true
                HabitsStore.shared.track(habit)
                habitCounter.text = "Счетчик: \(habit.trackDates.count)"
            }
        }
        if let progressCell = self.progressCell {
            progressCell.update()
        }
    }
    
}
