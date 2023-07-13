import UIKit

final class HabitDetailsViewController: UIViewController {
    
    let habit: Habit
    let store = HabitsStore.shared
    
    var dates: [Date] {
        let sortedDates = store.dates.sorted(by: >)
        return sortedDates
    }
    
    init(habit: Habit) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.habit = Habit(name: String(), date: Date(), color: UIColor())
            super.init(coder: coder)
    }
    
    private lazy var tableView: UITableView = {
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
        self.navigationItem.title = habit.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.navigationItem.title = habit.name
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    private func setupConstraints() {
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
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
        if store.habit(self.habit, isTrackedIn: dates[indexPath.row]) == true {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
}
    
