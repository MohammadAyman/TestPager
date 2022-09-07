//
//  PageViewController.swift
//  TestPAger
//
//  Created by Mac on 9/1/22.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var pages = [UIViewController]()
    let initialPage = 0
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupData()
    }
    func setupData(){
        
        dataSource = self
        delegate = self
        pageControl.addTarget(self, action:#selector(pageControlTapped(_:)), for: .valueChanged)
        
        let vc1 =   ViewController.instantiate() as! ViewController
        let pgD1 = PageData(title: "أفضل العروض", description: "التطبيق الأفضل في الوطن العربي لقطع السيارات , كل ما تحتاجه لسيارتك من قطع بأفضل العروض , والخصومات بين يديك الأن", imgName: "Group2562" , pageNumber: 0)
        vc1.pageData = pgD1
        pages.append(vc1)
        
        let vc2 = ViewController.instantiate() as! ViewController
        let pgD2 = PageData(title: " كتالوج سيارتك", description: "الان بكل سهولة يمكنك طلب قطع  الغيار لسيارتك , من خلال كتالوج سيارتك", imgName: "Group2563" ,  pageNumber: 1)
        vc2.pageData = pgD2
        pages.append(vc2)
        
        
        let vc3 =  ViewController.instantiate() as! ViewController
        let pgD3 = PageData(title: "شحن سريع وأمن", description: "اختر القطع المناسبة وسوف نقوم بالشحن الي عنوانك , بكل سهولة لا داعي بعد الأن لعناء الذهاب لمحالات , القطع كل القطع بين يديك", imgName: "Group2564" , pageNumber: 2)
        vc3.pageData = pgD3
        pages.append(vc3)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        style()
        layout()
    }
    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        self.view.backgroundColor = .white
    }
    
    func layout() {
        view.addSubview(pageControl)
        view.viewWithTag(999)
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            view.bottomAnchor.constraint(equalTo:pageControl.bottomAnchor, constant: 30)
        ])
    }
}

// MARK: - DataSources

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return nil               // wrap to last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            return nil              // wrap to first
        }
    }
    
}

// MARK: - Delegates

extension PageViewController: UIPageViewControllerDelegate {
    
    // How we keep our pageControl in sync with viewControllers
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        pageControl.currentPage = currentIndex
    }
    
}

// MARK: - Actions

extension PageViewController {
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        
    }
}

