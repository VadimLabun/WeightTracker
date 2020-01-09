//
//  OnboardingViewController.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/16/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit

class OnboardingPager : UIPageViewController, NextViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        view.backgroundColor = UIColor.darkGray
        
        // This is the starting point.  Start with step zero.
        if UserSettings.shared.isOnboardingCompleted == false {
            setViewControllers([getStepZero()], direction: .forward, animated: false, completion: nil)
        } else {
            setViewControllers([R.storyboard.main.mainViewController()!], direction: .forward, animated: false, completion: nil)
        }
    }
    
    func getStepZero() -> StepZero {
        let pageVc = R.storyboard.main.stepZero()
        pageVc?.delegate = self
        return pageVc!
    }
    
    func getStepOne() -> StepOne {
        let pageVc = R.storyboard.main.stepOne()
        pageVc?.delegate = self
        return pageVc!
    }
    
    func getStepTwo() -> StepTwo {
        let pageVc = R.storyboard.main.stepTwo()
        pageVc?.delegate = self
        return pageVc!
    }
    
    func getStepThree() -> StepThree {
        let pageVc = R.storyboard.main.stepThree()
        pageVc?.delegate = self
        return pageVc!
    }
    
    func getStepFour() -> StepFour {
        let pageVc = R.storyboard.main.stepFour()
        pageVc?.delegate = self
        return pageVc!
    }
    
    func goNext(viewController: UIViewController) {
        guard let next = findNext(after: viewController) else { return }
        setViewControllers([next], direction: .forward, animated: true, completion: nil)
    }
    
    func findNext(after viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: StepZero.self) {
            // 0 -> 1
            return getStepOne()
        } else if viewController.isKind(of: StepOne.self) {
            // 1 -> 2
            return getStepTwo()
        } else if viewController.isKind(of: StepTwo.self) {
            // 2 -> 3
            return getStepThree()
        } else if viewController.isKind(of: StepThree.self) {
            // 3 -> 4
            return getStepFour()
        } else if viewController.isKind(of: StepFour.self) {
            // 2 -> end of the road
            return R.storyboard.main.mainViewController()!
        } else {
            return nil
        }
    }
}

// MARK: - UIPageViewControllerDataSource methods
extension OnboardingPager : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: MainViewController.self) {
            return nil
        }
        else if viewController.isKind(of: StepFour.self) {
            // 4 -> 3
            return getStepThree()
        } else if viewController.isKind(of: StepThree.self) {
            // 3 -> 2
            return getStepTwo()
        } else if viewController.isKind(of: StepTwo.self) {
            // 2 -> 1
            return getStepOne()
        } else if viewController.isKind(of: StepOne.self) {
            // 1 -> 0
            return getStepZero()
        } else {
            // 0 -> end of the road
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        findNext(after: viewController)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int{
        return 4
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

// MARK: - UIPageViewControllerDelegate methods
extension OnboardingPager : UIPageViewControllerDelegate {
}

