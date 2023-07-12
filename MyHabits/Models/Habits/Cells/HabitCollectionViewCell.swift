//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Konstantin Tarasov on 08.07.2023.
//

import UIKit

typealias Action = () -> Void?

final class HabitCollectionViewCell: UICollectionViewCell {
    
    var habit: Habit?
    var progressCell: ProgressCollectionViewCell?
    
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
        return trackMarker
    }()
    
    var onLabelTapped: Action?
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.isUserInteractionEnabled = true
        
    }
    
    private func setupSubviews() {
        contentView.addSubview(habitName)
        contentView.addSubview(habitTime)
        contentView.addSubview(habitCounter)
        contentView.addSubview(trackMarker)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            habitName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            habitName.widthAnchor.constraint(equalToConstant: 220),
            habitName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            habitTime.topAnchor.constraint(equalTo: habitName.bottomAnchor, constant: 4),
            habitTime.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            habitTime.widthAnchor.constraint(equalTo: habitName.widthAnchor),
            habitTime.heightAnchor.constraint(equalToConstant: 16),
            
            habitCounter.topAnchor.constraint(lessThanOrEqualTo: habitTime.bottomAnchor, constant: 30),
            habitCounter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            habitCounter.widthAnchor.constraint(equalToConstant: 188),
            habitCounter.heightAnchor.constraint(equalToConstant: 18),
            habitCounter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
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
        habitName.isUserInteractionEnabled = true
        habitName.addGestureRecognizer(gesture)
    }
    
    func setup(with habit: Habit) {
        
        habitName.text = habit.name
        habitName.textColor = habit.color
        habitTime.text = habit.dateString
        habitCounter.text = "Счетчик: \(habit.trackDates.count)"
        trackMarker.layer.borderColor = habit.color.cgColor
        trackMarker.tintColor = habit.color
    }
    
    
    
    @objc
    private func tapOnLabel() {
        onLabelTapped?()
    }
    
    @objc
    private func trackHabit() {
        
        trackMarker.isSelected.toggle()
        trackMarker.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        
        if let habit = habit {
            HabitsStore.shared.track(habit)
            
        }
        
    }
    
}
