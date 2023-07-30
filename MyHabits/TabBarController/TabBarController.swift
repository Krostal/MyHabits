import UIKit

final class TabBarController: UITabBarController {
    
    private var habitsTabNavigationController: UINavigationController!
    private var infoTabNavigationController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor(named: "PurpleColor")
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupUI() {
        habitsTabNavigationController = UINavigationController.init(rootViewController: HabitsViewController())
        infoTabNavigationController = UINavigationController.init(rootViewController: InfoViewController())
        
        self.viewControllers = [habitsTabNavigationController, infoTabNavigationController]
        
        let item1 = UITabBarItem(title: "Привычки", image: UIImage(named: "habits_tab_icon"), tag: 0)

        let item2 = UITabBarItem(title: "Информация", image: UIImage(systemName: "info.circle.fill"), tag: 1)
        
        habitsTabNavigationController.tabBarItem = item1
        infoTabNavigationController.tabBarItem = item2
    }
    
}
