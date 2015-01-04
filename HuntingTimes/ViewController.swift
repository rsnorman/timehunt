//
//  ViewController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/21/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, ScrollLineViewDelegate, MenuIconViewDelegate, MenuControllerDelegate, FCLocationManagerDelegate, UIPageViewControllerDelegate {
    
    var pageViewController : UIPageViewController?
    var huntingControllers : [HuntingPageController]?
    var currentIndex : Int = 0
    
    var mainView : MainView!
    var animator : MainViewAnimations!
    
    var menuController : MenuController!
    var timesPageController : TimesPageController!
    var temperaturePageController : TemperaturePageController!
    
    var startScrollPosition  : CGPoint!
    var huntingSeason        : HuntingSeason!
    var locationManager      : FCLocationManager!

    override func viewDidLoad() {
        
        menuController = MenuController()
        menuController.delegate = self
        menuController.selectedBackground = UserSettings.getBackgroundImage()
        
        super.viewDidLoad()
        view.alpha = 0
        
        mainView = MainView(frame: view.frame)
        mainView.setDelegate(self)
        view.addSubview(mainView)
        
        animator = MainViewAnimations(mainView: mainView)
        addDateGestures()
        
        locationManager = FCLocationManager.sharedManager() as FCLocationManager
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        huntingControllers = []
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        pageViewController!.delegate = self
        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        
        addChildViewController(pageViewController!)
        pageViewController!.view.alpha = 0
        mainView.insertSubview(pageViewController!.view, belowSubview: mainView.menuIcon)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if var index = find(huntingControllers!, viewController as HuntingPageController) {
            if index == 0 {
                return nil
            }
            
            index--
            
            return viewControllerAtIndex(index)
        } else {
            return nil
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if var index = find(huntingControllers!, viewController as HuntingPageController) {
            index++
            
            if (index == self.huntingControllers!.count) {
                return nil
            }
            
            return viewControllerAtIndex(index)
        } else {
            return nil
        }
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController?
    {
        if self.huntingControllers!.count == 0 || index >= self.huntingControllers!.count
        {
            return nil
        }
        
        if index == 0 {
            return timesPageController
        } else {
            return temperaturePageController
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.huntingControllers!.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.mainView.dateTimeScroller.alpha = 0
            self.mainView.dateLabel.alpha = 0
        })
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            self.mainView.dateTimeScroller.alpha = 1
            self.mainView.dateLabel.alpha = 1
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.alpha = 1
        })  { (complete) -> Void in
            self.fadeInView()
        }
    }
    
    func fadeInView() {
        for gesture in mainView.superview!.gestureRecognizers as [UIGestureRecognizer] {
            gesture.enabled = true
        }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.mainView.show()
            self.pageViewController!.view.alpha = 1
        })
    }
    
    
    /* Action Methods */
    
    func showNextDate() {
        if !huntingSeason.closingDay() {
            timesPageController.startChangingDay(reverse: true) { (reverse) -> Void in
                self.mainView.dateTimeScroller.setPosition(1, animate: true)
                self.huntingSeason.nextDay()
                self.huntingSeason.fetchDay({ (huntingDay) -> () in
                    self.mainView.dateLabel.text  = huntingDay.getCurrentTime().toDateString()
                    self.timesPageController.setDay(huntingDay)
                    self.temperaturePageController.setDay(huntingDay)
                    self.timesPageController.finishChangingDay(reverse: reverse)
                })
            }
        }
    }
    
    func showPreviousDate() {
        if !huntingSeason.openingDay() {
            timesPageController.startChangingDay(reverse: false) { (reverse) -> Void in
                self.mainView.dateTimeScroller.setPosition(0, animate: true)
                self.huntingSeason.previousDay()
                self.huntingSeason.fetchDay({ (huntingDay) -> () in
                    self.mainView.dateLabel.text  = huntingDay.getCurrentTime().toDateString()
                    self.timesPageController.setDay(huntingDay)
                    self.temperaturePageController.setDay(huntingDay)
                    self.timesPageController.finishChangingDay(reverse: reverse)
                })
            }
        }
    }
    
    /* End Action Methods */
    
    
    /* Delegate Methods */
    
    func didPositionIndicator(percent: CGFloat) {
        let totalDays  = huntingSeason.length()
        let currentDay = Int(round(CGFloat(totalDays - 1) * percent))
        huntingSeason.setCurrentDay(currentDay)
//        mainView.datepickerLabel.text = currentTime().toDateString()
    }
    
    func didOpenMenu() {
        addChildViewController(menuController)
        mainView.insertSubview(menuController.view, belowSubview: mainView.menuIcon)
    }
    
    func didCloseMenu() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.menuController.view.alpha = 0.0
        }) { (complete) -> Void in
            self.menuController.view.removeFromSuperview()
            self.menuController.removeFromParentViewController()
        }
    }
    
    func didSelectBackground(backgroundImage: String) {
        mainView.bgImageView.setImage(UIImage(named: backgroundImage)!)
        UserSettings.setBackgroundImage(backgroundImage)
    }
    
    func didAcquireLocation(location: CLLocation!) {
        huntingSeason = HuntingSeason(location: location)
        mainView.dateTimeScroller.markCurrentPosition(huntingSeason.percentComplete())
        
        huntingSeason.fetchDay { (huntingDay) -> () in
            self.mainView.dateLabel.text  = huntingDay.getCurrentTime().toDateString()
            self.timesPageController = TimesPageController(huntingDay: huntingDay)
            self.temperaturePageController = TemperaturePageController(huntingDay: huntingDay)
            self.huntingControllers = [self.timesPageController, self.temperaturePageController]
            
            let startingViewController: UIViewController = self.viewControllerAtIndex(0)!
            let viewControllers: NSArray = [startingViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        }
    }
    
    func didFailToAcquireLocationWithErrorMsg(errorMsg: String!) {
        println("Failed to aquire location!!!!")
    }


    /* End Delegate Methods*/

    
    
    /* Gestures */
    
    func addDateGestures() {
        let nextDateGesture       = UISwipeGestureRecognizer(target: self, action: "showNextDate")
        nextDateGesture.direction = .Up
        view.addGestureRecognizer(nextDateGesture)
        
        let previousDateGesture       = UISwipeGestureRecognizer(target: self, action: "showPreviousDate")
        previousDateGesture.direction = .Down
        view.addGestureRecognizer(previousDateGesture)
        
        let hintTapGesture  = UITapGestureRecognizer(target: animator, action: "showSwipeHint")
        view.addGestureRecognizer(hintTapGesture)
    }
    
    /* End Gestures */
}

