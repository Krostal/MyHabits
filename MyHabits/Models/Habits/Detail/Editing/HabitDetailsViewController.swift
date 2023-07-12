//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Konstantin Tarasov on 09.07.2023.
//

import UIKit

final class HabitDetailsViewController: UIViewController {
    
    let habit: Habit
    let store = HabitsStore.shared
    
    var dates: [Date] {
        return store.dates.sorted(by: { $0 > $1 })
    }
    
    init(habit: Habit) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.habit = Habit(name: String(), date: Date(), color: UIColor())
            super.init(coder: coder)
    }
    
    static let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "LightGrayColor")
        tableView.register(HabitDetailsViewControllerCell.self, forCellReuseIdentifier: HabitDetailsViewControllerCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.safeAreaLayoutGuide.owningView?.backgroundColor = .white
        setupTableView()
        setupConstraints()
        setupNavigationBar()
        
    }
    
    private func setupTableView() {
        view.addSubview(Self.tableView)
        Self.tableView.delegate = self
        Self.tableView.dataSource = self
    }
    
    
    private func setupConstraints() {
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            Self.tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            Self.tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            Self.tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            Self.tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = UIColor(named: "PurpleColor")
        
        let rightBarButton = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    @objc func edit() {
        let habitVC = HabitViewController(currentHabit: habit)
        let habitNavigationController = UINavigationController(rootViewController: habitVC)
        present(habitNavigationController, animated: true)
    }
    
}

extension HabitDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitDetailsViewControllerCell.id, for: indexPath) as? HabitDetailsViewControllerCell else {
            return UITableViewCell()
        }
        cell.configure(dates[indexPath.row])
        if HabitsStore.shared.habit(habit, isTrackedIn: habit.date) == true {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
}
    
