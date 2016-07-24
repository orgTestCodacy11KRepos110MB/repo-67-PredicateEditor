//
//  PredicateEditorViewController.swift
//  Pods
//
//  Created by Arvindh Sukumar on 07/07/16.
//
//

import UIKit
import StackViewController
import SnapKit

public struct PredicatorEditorConfig {
    public var keyPathDisplayColor: UIColor!
    public var comparisonButtonColor: UIColor!
    public var inputColor: UIColor!
    public var backgroundColor: UIColor!
    public var sectionBackgroundColor: UIColor!
    
    public init() {
        self.keyPathDisplayColor = UIColor(red:0.64, green:0.41, blue:0.65, alpha:1.00)
        self.comparisonButtonColor = UIColor(red:0.27, green:0.47, blue:0.74, alpha:1.00)
        self.inputColor = UIColor(red:0.00, green:0.53, blue:0.19, alpha:1.00)
        self.backgroundColor = UIColor(red:0.87, green:0.89, blue:0.93, alpha:1.00)
        self.sectionBackgroundColor = UIColor(red:0.94, green:0.95, blue:0.97, alpha:1.00)
    }
}

public class PredicateEditorViewController: UIViewController {
    var config: PredicatorEditorConfig!
    var sections: [Section] = []
    var sectionViews: [SectionView] = []
    private let stackViewController: StackViewController
    
    public convenience init(sections:[Section], config: PredicatorEditorConfig = PredicatorEditorConfig() ) {
        self.init()
        self.sections = sections
        self.config = config
    }
    
    init() {
        stackViewController = StackViewController()
        stackViewController.stackViewContainer.separatorViewFactory = StackViewContainer.createSeparatorViewFactory()
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        setupStackView()
    }

    private func setupStackView(){
        stackViewController.view.backgroundColor = config.backgroundColor
        addChildViewController(stackViewController)
        view.addSubview(stackViewController.view)
        stackViewController.view.snp_makeConstraints {
            make in
            make.edges.equalTo(view)
        }
        stackViewController.didMoveToParentViewController(self)
        stackViewController.stackViewContainer.scrollView.alwaysBounceVertical = true

        for section in sections {
            let sectionViewController = SectionViewController(section: section, config: config)
            stackViewController.addItem(sectionViewController)
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

public extension PredicateEditorViewController {
    public func predicates() throws -> [NSPredicate] {
        return try sections.map({ (section) -> NSPredicate in
            dump(try section.predicates())
            return try section.compoundPredicate()
        })
    }
}

