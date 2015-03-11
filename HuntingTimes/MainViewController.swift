//
//  ViewController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/21/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPageViewControllerDataSource, DateLineScrollerDelegate, MenuIconViewDelegate, MenuControllerDelegate, FCLocationManagerDelegate, UIPageViewControllerDelegate, DatePickerIconDelegate, DatePickerControllerDelegate, TimesPageControllerDelegate {
    
    var pageViewController : UIPageViewController?
    var huntingControllers : [HuntingPageController]?
    var currentIndex : Int = 0
    
    var mainView : MainView!
    
    var menuController : MenuController!
    var datePickerController : DatePickerController!
    var timesPageController : TimesPageController!
    var temperaturePageController : TemperaturePageController!
    
    var startScrollPosition  : CGPoint!
    var huntingSeason        : HuntingSeason!
    var locationManager      : FCLocationManager!
    
    var nextDateGesture : UISwipeGestureRecognizer!
    var prevDateGesture : UISwipeGestureRecognizer!

    override func viewDidLoad() {
        
        menuController = MenuController()
        menuController.delegate = self
        menuController.selectedBackground = UserSettings.getBackgroundImage()
        
        datePickerController = DatePickerController()
        datePickerController.delegate = self
        
        super.viewDidLoad()
        view.alpha = 0
        
        mainView = MainView(frame: view.frame)
        mainView.setDelegate(self)
        mainView.datePickerIcon.disable()
        view.addSubview(mainView)
        
        addDateGestures()
        
        locationManager = FCLocationManager.sharedManager() as FCLocationManager
        locationManager.delegate = self
        
        huntingControllers = []
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        pageViewController!.delegate = self
        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        
        addChildViewController(pageViewController!)
        pageViewController!.view.alpha = 0
        mainView.insertSubview(pageViewController!.view, belowSubview: mainView.datePickerIcon)
        pageViewController!.didMoveToParentViewController(self)
        
        findLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.alpha = 1
        })  { (complete) -> Void in
            self.fadeInView()
        }
    }
    
    func fadeInView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.mainView.show()
            self.pageViewController!.view.alpha = 1
        })
    }
    
    func findLocation() {
        startLoadingDate()
        locationManager.startUpdatingLocation()
    }
    
    
    /* Action Methods */
    
    func startLoadingDate() {
        hideErrorMessage()
        mainView.startLoadingIndicator()
        mainView.datePickerIcon.disable()
        nextDateGesture.enabled = false
        prevDateGesture.enabled = false
        pageViewController!.view.userInteractionEnabled = false
    }
    
    func finishLoadingDate() {
        mainView.stopLoadingIndicator()
        mainView.datePickerIcon.enable()
        nextDateGesture.enabled = true
        prevDateGesture.enabled = true
        pageViewController!.view.userInteractionEnabled = true
    }
    
    func showNextDate() {
        if !huntingSeason.closingDay() {
            startLoadingDate()
            
            mainView.dateTimeScroller.setProgress(1, animate: true)
            mainView.dateTimeScroller.hideIndicator(setProgress: 0)
            
            getCurrentPage().startChangingDay(reverse: true) { (reverse) -> Void in
                self.huntingSeason.nextDay()
                self.huntingSeason.fetchDay({ (error, huntingDay) -> () in
                   self.showDay(error, huntingDay: huntingDay, reverse: reverse)
                })
            }
        }
    }
    
    func showPreviousDate() {
        if !huntingSeason.openingDay() {
            startLoadingDate()
            
            mainView.dateTimeScroller.setProgress(0, animate: true)
            mainView.dateTimeScroller.hideIndicator(setProgress: 1)
            
            getCurrentPage().startChangingDay(reverse: false) { (reverse) -> Void in
                self.huntingSeason.previousDay()
                self.huntingSeason.fetchDay({ (error, huntingDay) -> () in
                    self.showDay(error, huntingDay: huntingDay, reverse: reverse)
                })
            }
        }
    }
    
    func getCurrentPage() -> HuntingPageController {
        return pageViewController!.viewControllers[0] as HuntingPageController
    }
    
    func showDay(error: NSError?, huntingDay: HuntingDay, reverse: Bool) {
        if error == nil {
            for page in huntingControllers! {
                page.setDay(huntingDay)
            }
            
            mainView.dateTimeScroller.setDate(huntingDay.getCurrentTime().time)
            mainView.dateTimeScroller.setProgress(getCurrentPage().currentProgress(), animate: true)
            mainView.dateTimeScroller.showIndicator()
            
            getCurrentPage().finishChangingDay(reverse: reverse)
            
            finishLoadingDate()
        } else {
            showErrorMessage(reverse ? "showNextDate" : "showPreviousDate")
        }
    }
    
    func showErrorMessage(retryAction: Selector) {
        mainView.errorMessage.setMessage("Could not load weather data\nTap to retry")
        mainView.errorMessage.setRetryAction(self, action: retryAction)
        mainView.stopLoadingIndicator()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.mainView.errorMessage.alpha = 1
        })
    }
    
    func showLocationErrorMessage() {
        mainView.errorMessage.setMessage("Could not determine location\nTap to retry")
        mainView.errorMessage.setRetryAction(self, action: "findLocation")
        mainView.stopLoadingIndicator()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.mainView.errorMessage.alpha = 1
        })
    }
    
    func hideErrorMessage() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.mainView.errorMessage.alpha = 0
        })
    }
    
    /* End Action Methods */
    
    
    /* Delegate Methods */
    
    func didChangeProgress(percent: CGFloat) {
        let totalDays  = huntingSeason.length()
        let currentDay = Int(round(CGFloat(totalDays - 1) * percent))
        huntingSeason.setCurrentDay(currentDay)
        mainView.dateTimeScroller.setDate(huntingSeason.currentDay().date)
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
    
    func didOpenDatePicker() {
        addChildViewController(datePickerController)
        datePickerController.view.alpha = 0
        mainView.insertSubview(datePickerController.view, belowSubview: mainView.datePickerIcon)
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.datePickerController.view.alpha = 1
            self.pageViewController!.view.alpha = 0
            self.mainView.dateTimeScroller.setProgress(self.huntingSeason.percentComplete(), animate: false)
            self.mainView.dateTimeScroller.showCurrentProgress()
        })
    }
    
    func didCloseDatePicker() {
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.datePickerController.view.alpha = 0
            self.mainView.dateTimeScroller.hideCurrentProgress()
            
        }) {(complete) -> Void in
            self.huntingSeason.fetchDay({ (error, huntingDay) -> () in
                
                if error == nil {
                    for page in self.huntingControllers! {
                        page.setDay(huntingDay)
                    }
                    
                    UIView.animateWithDuration(0.5, animations: {() -> Void in
                        let pageController = self.pageViewController!.viewControllers[0] as HuntingPageController
                        self.mainView.dateTimeScroller.setProgress(pageController.currentProgress(), animate: false)
                        self.mainView.dateTimeScroller.showIndicator()
                        self.pageViewController!.view.alpha = 1
                    })
                } else {
//                    self.showErrorMessage()
                }
            })
        }
    }
    
    func didScrollDates(position: CGFloat) {
        self.mainView.dateTimeScroller.setOffsetProgress(position)
    }
    
    func didSelectBackground(backgroundImage: String) {
        mainView.bgImageView.setImage(UIImage(named: backgroundImage)!)
        UserSettings.setBackgroundImage(backgroundImage)
    }
    
    func didAcquireLocation(location: CLLocation!) {
        huntingSeason = HuntingSeason(startDate: HUNTING_SEASON_START_DATE, endDate: HUNTING_SEASON_END_DATE, location: location)
        
        mainView.dateTimeScroller.markCurrentProgress(huntingSeason.percentComplete())
        
        getDayForLocation()
    }
    
    func getDayForLocation() {
        startLoadingDate()
        
        huntingSeason.fetchDay { (error, huntingDay) -> () in
            if error == nil {
                self.timesPageController = TimesPageController(huntingDay: huntingDay)
                self.timesPageController.delegate = self
                
                self.temperaturePageController = TemperaturePageController(huntingDay: huntingDay)
                
                self.huntingControllers = [self.timesPageController, self.temperaturePageController]
                
                let startingViewController: UIViewController = self.viewControllerAtIndex(0)!
                let viewControllers: NSArray = [startingViewController]
                self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
                
                self.mainView.dateTimeScroller.setProgress((startingViewController as HuntingPageController).currentProgress(), animate: true)
                self.mainView.dateTimeScroller.setDate(huntingDay.getCurrentTime().time)
                
                self.finishLoadingDate()
            } else {
                self.showErrorMessage("getDayForLocation")
            }
        }
    }
    
    func didFailToAcquireLocationWithErrorMsg(errorMsg: String!) {
        self.showLocationErrorMessage()
    }
    
    func didTickCountdown() {
        if pageViewController!.view.alpha != 0 {
            let pageController = pageViewController!.viewControllers[0] as HuntingPageController
            mainView.dateTimeScroller.setProgress(pageController.currentProgress(), animate: true)
        }
    }


    /* End Delegate Methods*/

    
    /* Gestures */
    
    func addDateGestures() {
        nextDateGesture = UISwipeGestureRecognizer(target: self, action: "showNextDate")
        nextDateGesture.direction = .Up
        view.addGestureRecognizer(nextDateGesture)
        
        prevDateGesture = UISwipeGestureRecognizer(target: self, action: "showPreviousDate")
        prevDateGesture.direction = .Down
        view.addGestureRecognizer(prevDateGesture)
    }
    
    /* End Gestures */
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if (huntingControllers?.count == 0) {
            return nil
        }
        
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
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if (huntingControllers?.count == 0) {
            return nil
        }
        
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
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if self.huntingControllers!.count == 0 || index >= self.huntingControllers!.count
        {
            return nil
        }
        
        return huntingControllers![index]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.huntingControllers!.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.mainView.dateTimeScroller.alpha = 0
            self.mainView.datePickerIcon.alpha = 0
            self.mainView.menuIcon.alpha = 0
        })
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            self.mainView.dateTimeScroller.alpha = 1
            self.mainView.datePickerIcon.alpha = 1
            self.mainView.menuIcon.alpha = 1
        })
    }
}

