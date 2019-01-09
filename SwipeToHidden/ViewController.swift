//
//  ViewController.swift
//  SwipeToHidden
//
//  Created by Mazy on 2019/1/9.
//  Copyright © 2019 Mazy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topHeaderView: UILabel!
    @IBOutlet weak var topTitleLabel: UILabel!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    
    @IBOutlet weak var topHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var toolbarBottomSpace: NSLayoutConstraint!
    
    
    private var headerHidght: CGFloat = 0
    private lazy var swipeToHidden = SwipeToHidden()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerHidght = topHeaderHeight.constant
        swipeToHidden.scrollDistance = headerHidght
        swipeToHidden.delegate = self
        
        let topInset = headerHidght //+ statusBarHeight
        tableView.contentInset.top = topInset
        tableView.scrollIndicatorInsets.top = topInset
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.delegate = swipeToHidden as UITableViewDelegate
        tableView.sectionHeaderHeight = 0.01
    }
    
    func updateViews() {
        let percentHidden = swipeToHidden.percentHidden
        toolbarBottomSpace.constant = -percentHidden * 44
        topHeaderHeight.constant = (1.0 - percentHidden) * headerHidght
        topTitleLabel.textColor = UIColor.white.withAlphaComponent(1.0 - percentHidden)
        bottomToolbar.isHidden = percentHidden == 1.0
    }
    
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = "Item \(indexPath.row + 1)"
        return cell
    }
}

extension ViewController: SwipeToHiddenDelegate {
    
    func swipeToHidden(_ source: SwipeToHidden, didUpdatePercentHiddenInteractively interactive: Bool) {
        
        updateViews()
        
        if !interactive {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0.0, options: [], animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }) { (_) in
                
            }
        }
    }
}
