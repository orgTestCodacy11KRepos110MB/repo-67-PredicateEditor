//
//  SectionViewController.swift
//  PredicateEditor
//
//  Created by Arvindh Sukumar on 09/07/16.
//
//

import UIKit
import SnapKit

class SectionViewController: UIViewController {
    var section: Section!
    var sectionView: SectionView!

    convenience init(section:Section){
        self.init(nibName: nil, bundle: nil)
        self.section = section
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView(){
        sectionView = SectionView(frame: CGRectZero)
        sectionView.delegate = self
        sectionView.dataSource = self
        view.addSubview(sectionView)
        sectionView.snp_makeConstraints {
            make in
            make.edges.equalTo(view)
        }
        sectionView.reloadData()
    }
}

extension SectionViewController {
    func showKeyPathOptions(forRow row: Row) {
        guard let section = row.section else {return}
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for property in section.keyPathTitles {
            let action = UIAlertAction(title: property, style: UIAlertActionStyle.Default, handler: { (action) in
                
            })
            sheet.addAction(action)
        }
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        showViewController(sheet, sender: nil)
    }
    
    func showComparisonOptions(forRow row: Row) {
        guard let descriptor = row.descriptor else { return }
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let keyPathType = descriptor.propertyType
        let comparisonOptions = keyPathType.comparisonTypes().map { (type) -> String in
            return type.rawValue
        }
        
        for comparison in comparisonOptions {
            let action = UIAlertAction(title: comparison, style: UIAlertActionStyle.Default, handler: { (action) in
                
            })
            sheet.addAction(action)
        }
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        showViewController(sheet, sender: nil)
    }
}

extension SectionViewController: SectionViewDelegate, SectionViewDataSource {
    func sectionViewTitle() -> String {
        return "test"
    }

    func sectionViewNumberOfRows() -> Int {
        return section.rows.count
    }

    func sectionViewRowForItemAtIndex(index: Int) -> UIView {
        let view = RowView(frame: CGRectZero)
        view.delegate = self
        view.tag = index
        view.backgroundColor = UIColor.whiteColor()
        let row = section.rows[index]
        view.configureWithRow(row)
        return view
    }
}

extension SectionViewController: RowViewDelegate {
    func didTapKeyPathButton(index: Int) {
        let row = section.rows[index]
        print(row.descriptor?.keyPath)
        showKeyPathOptions(forRow: row)
    }
    
    func didTapComparisonButton(index: Int) {
        let row = section.rows[index]
        print(row.comparisonType)
        showComparisonOptions(forRow: row)
    }
}