//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Konstantin Tarasov on 07.07.2023.
//

import UIKit

class HabitsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }

    
    private func setupNavigationBar() {
        
        self.title = "Cегодня"
        
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "PurpleColor")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc func barButtonItemTapped(_ sender: UIBarButtonItem) {
        let habitViewController = HabitViewController.init()
        let navigationVC = UINavigationController(rootViewController: habitViewController)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
    
}
