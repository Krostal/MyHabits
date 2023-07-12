//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Konstantin Tarasov on 07.07.2023.
//

import UIKit

class HabitsViewController: UIViewController {
    
    var progressCell: ProgressCollectionViewCell?
    
    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupLayouts()
        setupNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.reloadData()
        collectionView.refreshControl?.endRefreshing()
        
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(named: "LightGrayColor")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupLayouts() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 22),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -12),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
    }

    private func setupNavigationBar() {
        
        self.navigationItem.title = "Cегодня"
        
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "PurpleColor")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewHabit(_:)))
        navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc func addNewHabit(_ sender: UIBarButtonItem) {
        let habitViewController = HabitViewController.init()
        let navigationVC = UINavigationController(rootViewController: habitViewController)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
    
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    private func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        
        let itemsInRow: CGFloat = 1
        let totalSpacing: CGFloat = 2 * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        return floor(finalWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemWidth(for: view.frame.width, spacing: 16)
        if indexPath.row == 0 {
            return CGSize(width: width, height: 60)
        } else {
            return CGSize(width: width, height: 130)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

extension HabitsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        HabitsStore.shared.habits.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as? ProgressCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            progressCell = cell
            cell.setup()
            return cell
        }
    
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath) as? HabitCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.onLabelTapped = { [weak self] in
            let habit = HabitsStore.shared.habits[indexPath.row-1]
            let habitDetailsVC = HabitDetailsViewController(habit: habit)
            self?.navigationController?.pushViewController(habitDetailsVC, animated: true)
            habitDetailsVC.self.title = cell.habitName.text
            
        }
        
        let habits = HabitsStore.shared.habits[indexPath.row-1]
        cell.setup(with: habits)
        return cell
    }
    

}
