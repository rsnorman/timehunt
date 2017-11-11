//
//  ViewController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/21/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UIPageViewControllerDataSource, DateLineScrollerDelegate, MenuIconViewDelegate, MenuControllerDelegate, CLLocationManagerDelegate, UIPageViewControllerDelegate, DatePickerIconDelegate, DatePickerControllerDelegate, TimesPageControllerDelegate {
    
    var pageViewController : UIPageViewController?
    var huntingControllers : [HuntingPageController]?
    var currentIndex : Int = 0
    
    var mainView : MainView!
    
    var menuController : MenuController!
    var datePickerController : DatePickerController!
    var timesPageController : TimesPageController!
    var temperaturePageController : TemperaturePageController!
    var windPageController : WindPageController!
    var pressurePageController : PressurePageController!
    
    var startScrollPosition  : CGPoint!
    var huntingSeason        : HuntingSeason!
    var locationManager      : CLLocationManager!
    
    var nextDateGesture : UISwipeGestureRecognizer!
    var prevDateGesture : UISwipeGestureRecognizer!
    var viewingDatePicker : Bool!

    override func viewDidLoad() {
        
        menuController = MenuController()
        menuController.delegate = self
        menuController.selectedBackground = UserSettings.getBackgroundImage() as String!
        
        datePickerController = DatePickerController()
        datePickerController.delegate = self
        
        super.viewDidLoad()
        view.alpha = 0
        
        viewingDatePicker = false
        
        mainView = MainView(frame: view.bounds)
        mainView.setDelegate(self)
        mainView.datePickerIcon.disable()
        view.addSubview(mainView)
        
        addDateGestures()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestAlwaysAuthorization()
        
        huntingControllers = []
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController!.dataSource = self
        pageViewController!.delegate = self
        pageViewController!.view.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height);
        
        addChildViewController(pageViewController!)
        pageViewController!.view.alpha = 0
        mainView.insertSubview(pageViewController!.view, belowSubview: mainView.datePickerIcon)
        pageViewController!.didMove(toParentViewController: self)
        
        findLocation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mainView.frame = view.bounds
        pageViewController!.view.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.alpha = 1
        }, completion: { (complete) -> Void in
            self.fadeInView()
        })  
    }
    
    func fadeInView() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.mainView.show()
            self.pageViewController!.view.alpha = 1
        })
    }
    
    @objc func findLocation() {
        startLoadingDate()
        locationManager.distanceFilter = 1000
        locationManager.startUpdatingLocation()
    }
    
    
    /* Action Methods */
    
    func startLoadingDate() {
        hideErrorMessage()
        mainView.startLoadingIndicator()
        mainView.datePickerIcon.disable()
        nextDateGesture.isEnabled = false
        prevDateGesture.isEnabled = false
        pageViewController!.view.isUserInteractionEnabled = false
    }
    
    func finishLoadingDate() {
        mainView.stopLoadingIndicator()
        mainView.datePickerIcon.enable()
        nextDateGesture.isEnabled = true
        prevDateGesture.isEnabled = true
        pageViewController!.view.isUserInteractionEnabled = true
    }
    
    @objc func showNextDate() {
        if !viewingDatePicker && !huntingSeason.closingDay() {
            startLoadingDate()
            
            mainView.dateTimeScroller.setProgress(1, animate: true)
            mainView.dateTimeScroller.hideIndicator(setProgress: 0)
            
            getCurrentPage().startChangingDay(true) { (reverse) -> Void in
                self.huntingSeason.moveToNextDay()
                self.huntingSeason.fetchDay({ (error, huntingDay) -> () in
                   self.showDay(error, huntingDay: huntingDay, reverse: reverse)
                })
            }
        }
    }
    
    @objc func showPreviousDate() {
        if !viewingDatePicker && !huntingSeason.openingDay() {
            startLoadingDate()
            
            mainView.dateTimeScroller.setProgress(0, animate: true)
            mainView.dateTimeScroller.hideIndicator(setProgress: 1)
            
            getCurrentPage().startChangingDay(false) { (reverse) -> Void in
                self.huntingSeason.moveToPreviousDay()
                self.huntingSeason.fetchDay({ (error, huntingDay) -> () in
                    self.showDay(error, huntingDay: huntingDay, reverse: reverse)
                })
            }
        }
    }
    
    func getCurrentPage() -> HuntingPageController {
        return pageViewController!.viewControllers![0] as! HuntingPageController
    }
    
    func showDay(_ error: NSError?, huntingDay: HuntingDay, reverse: Bool) {
        DispatchQueue.main.async {
            if error == nil {
                for page in self.huntingControllers! {
                    page.setDay(huntingDay)
                }
                
                self.mainView.dateTimeScroller.setDate(huntingDay.date)
                self.mainView.dateTimeScroller.setProgress(self.getCurrentPage().currentProgress(), animate: true)
                self.mainView.dateTimeScroller.showIndicator()
                
                self.getCurrentPage().finishChangingDay(reverse)
                
                self.finishLoadingDate()
            } else {
                self.showErrorMessage(reverse ? #selector(MainViewController.showNextDate) : #selector(MainViewController.showPreviousDate))
            }
        }
    }
    
    func showErrorMessage(_ retryAction: Selector) {
        mainView.errorMessage.setMessage("Could not load sunrise and sunset times\nTap to retry")
        mainView.errorMessage.setRetryAction(self, action: retryAction)
        mainView.stopLoadingIndicator()
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.mainView.errorMessage.alpha = 1
        })
    }
    
    func showLocationErrorMessage() {
        mainView.errorMessage.setMessage("Could not determine location\nTap to retry")
        mainView.errorMessage.setRetryAction(self, action: #selector(MainViewController.findLocation))
        mainView.stopLoadingIndicator()
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.mainView.errorMessage.alpha = 1
        })
    }
    
    func hideErrorMessage() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.mainView.errorMessage.alpha = 0
        })
    }
    
    /* End Action Methods */
    
    
    /* Delegate Methods */
    
    func didChangeProgress(_ percent: CGFloat) {
        if !viewingDatePicker {
            return
        }

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
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.menuController.view.alpha = 0.0
        }, completion: { (complete) -> Void in
            self.menuController.view.removeFromSuperview()
            self.menuController.removeFromParentViewController()
        }) 
    }
    
    func didOpenDatePicker() {
        viewingDatePicker = true
        addChildViewController(datePickerController)
        datePickerController.view.alpha = 0
        pageViewController!.view.isUserInteractionEnabled = false
        
        mainView.insertSubview(datePickerController.view, belowSubview: mainView.datePickerIcon)
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.datePickerController.view.alpha = 1
            self.pageViewController!.view.alpha = 0
            self.mainView.dateTimeScroller.setProgress(self.huntingSeason.percentComplete(), animate: false)
            self.mainView.dateTimeScroller.showCurrentProgress()
        })
    }
    
    func didCloseDatePicker() {
        pageViewController!.view.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.datePickerController.view.alpha = 0
            self.mainView.dateTimeScroller.hideCurrentProgress()
            
        }, completion: {(complete) -> Void in
            self.showSelectedDay()
            self.viewingDatePicker = false
        }) 
    }
    
    @objc func showSelectedDay() {
        startLoadingDate()
        
        huntingSeason.fetchDay({ (error, huntingDay) -> () in
            DispatchQueue.main.async {
                if error == nil {
                    for page in self.huntingControllers! {
                        page.setDay(huntingDay)
                    }
                    
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        let pageController = self.pageViewController!.viewControllers?[0] as! HuntingPageController
                        self.mainView.dateTimeScroller.setProgress(pageController.currentProgress(), animate: false)
                        self.mainView.dateTimeScroller.showIndicator()
                        self.pageViewController!.view.alpha = 1
                    })
                    
                    self.finishLoadingDate()
                } else {
                    self.showErrorMessage(#selector(MainViewController.showSelectedDay))
                }
            }
        })
    }
    
    func didScrollDates(_ percent: CGFloat) {
        self.mainView.dateTimeScroller.setProgress(percent, animate: false)
    }
    
    func didSelectBackground(_ backgroundImage: String) {
        mainView.bgImageView.setTiltImage(UIImage(named: backgroundImage)!)
        UserSettings.setBackgroundImage(backgroundImage)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if huntingSeason != nil {
            huntingSeason.location = locations[0]
            huntingSeason.fetchDay { (error, huntingDay) -> () in
                DispatchQueue.main.async {
                    if error == nil {
                        self.timesPageController.setDay(huntingDay)
                        self.temperaturePageController.setDay(huntingDay)
                        self.windPageController.setDay(huntingDay)
                        self.pressurePageController.setDay(huntingDay)
                    } else {
                        self.showErrorMessage(#selector(MainViewController.getDayForLocation))
                    }
                }
            }
        } else {
            huntingSeason = HuntingSeason(startDate: Date(), endDate: HUNTING_SEASON_END_DATE, location: locations[0])
            mainView.dateTimeScroller.markCurrentProgress(huntingSeason.percentComplete())
            getDayForLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showLocationErrorMessage()
    }
    
    @objc func getDayForLocation() {
        startLoadingDate()
        
        huntingSeason.fetchDay { (error, huntingDay) -> () in
            DispatchQueue.main.async {
                if error == nil {
                    self.timesPageController = TimesPageController(huntingDay: huntingDay)
                    self.timesPageController.delegate = self
                    
                    self.temperaturePageController = TemperaturePageController(huntingDay: huntingDay)
                    self.windPageController = WindPageController(huntingDay: huntingDay)
                    self.pressurePageController = PressurePageController(huntingDay: huntingDay)
                    
                    self.huntingControllers = [self.timesPageController, self.temperaturePageController, self.windPageController, self.pressurePageController]
                    
                    let startingViewController: UIViewController = self.viewControllerAtIndex(0)!
                    let viewControllers: NSArray = [startingViewController]
                    self.pageViewController!.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: false, completion: nil)
                    
                    self.mainView.dateTimeScroller.setProgress((startingViewController as! HuntingPageController).currentProgress(), animate: true)
                    self.mainView.dateTimeScroller.setDate(huntingDay.date)
                    self.finishLoadingDate()
                } else {
                    self.showErrorMessage(#selector(MainViewController.getDayForLocation))
                }
            }
        }
    }
    
    func didTickCountdown() {
        if pageViewController!.view.alpha != 0 {
            let pageController = pageViewController!.viewControllers?[0] as! HuntingPageController
            mainView.dateTimeScroller.setProgress(pageController.currentProgress(), animate: true)
        }
    }


    /* End Delegate Methods*/

    
    /* Gestures */
    
    func addDateGestures() {
        nextDateGesture = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.showNextDate))
        nextDateGesture.direction = .up
        view.addGestureRecognizer(nextDateGesture)
        
        prevDateGesture = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.showPreviousDate))
        prevDateGesture.direction = .down
        view.addGestureRecognizer(prevDateGesture)
    }
    
    /* End Gestures */
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if (huntingControllers?.count == 0) {
            return nil
        }
        
        if var index = huntingControllers!.index(of: viewController as! HuntingPageController) {
            if index == 0 {
                return nil
            }
            
            index -= 1
            
            return viewControllerAtIndex(index)
        } else {
            return nil
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if (huntingControllers?.count == 0) {
            return nil
        }
        
        if var index = huntingControllers!.index(of: viewController as! HuntingPageController) {
            index += 1
            
            if (index == self.huntingControllers!.count) {
                return nil
            }
            
            return viewControllerAtIndex(index)
        } else {
            return nil
        }
    }
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if self.huntingControllers!.count == 0 || index >= self.huntingControllers!.count
        {
            return nil
        }
        
        return huntingControllers![index]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.huntingControllers!.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    private func pageViewController(_ pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.mainView.dateTimeScroller.alpha = 0
            self.mainView.datePickerIcon.alpha = 0
            self.mainView.menuIcon.alpha = 0
        })
    }
    
    private func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        UIView.animate(withDuration: 0.8, animations: { () -> Void in
            self.mainView.dateTimeScroller.alpha = 1
            self.mainView.datePickerIcon.alpha = 1
            self.mainView.menuIcon.alpha = 1
        })
    }
}

