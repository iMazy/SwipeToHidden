//
//  SwipeToHidden.swift
//  SwipeToHidden
//
//  Created by Mazy on 2019/1/9.
//  Copyright © 2019 Mazy. All rights reserved.
//

import UIKit

protocol SwipeToHiddenDelegate {
    
    /// Description
    ///
    /// - Parameters:
    ///   - source: 源文件
    ///   - interactive:
    func swipeToHidden(_ source: SwipeToHidden, didUpdatePercentHiddenInteractively interactive: Bool)
}

class SwipeToHidden: NSObject {
    
    var delegate: SwipeToHiddenDelegate?
    
    var percentHidden: CGFloat = 0
    var scrollDistance: CGFloat = 50
    
    private var  dragStartPosition: CGFloat = 0.0
    private var isDragging: Bool = false
    
    func beginDragAtPosition(_ value: CGFloat) {
        dragStartPosition = max(value, 0.0)
        isDragging = true
    }
    
    func endDragAtTargetPosition(_ value: CGFloat, velocity: CGFloat) {
        isDragging = false
        
        var shouldHidden: Bool = true
        if velocity < 0.0 || (velocity == 0.0 && percentHidden == 0.0) || (value < scrollDistance) {
            shouldHidden = false
        }
        setPercentHidden(shouldHidden ? 1.0 : 0.0, interactive: false)
    }
    
    func scrollToPosition(_ value: CGFloat) {
        if value <= 0 {
            setPercentHidden(0.0, interactive: false)
        } else if isDragging {
            if value < scrollDistance {
                let newPercentHidden = value / scrollDistance
                if newPercentHidden < percentHidden {
                    setPercentHidden(newPercentHidden, interactive: true)
                    return
                }
            }
            
            if percentHidden < 1.0 {
                let diff = value - dragStartPosition
                setPercentHidden(diff / scrollDistance, interactive: true)
                if diff < 0.0 {
                    dragStartPosition = value
                }
            }
        }
    }
    
    private func setPercentHidden(_ percent: CGFloat, interactive: Bool) {
        
        var newPercent = percent < 0 ? 0 : percent
        newPercent  = percent > 1.0 ? 1.0 : percent
        
        if newPercent == percentHidden { return }
        percentHidden = newPercent
        
        delegate?.swipeToHidden(self, didUpdatePercentHiddenInteractively: interactive)
    }
    
    public func xm_scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beginDragAtPosition(scrollView.contentOffset.y + scrollView.contentInset.top)
    }
    
    public func xm_scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        endDragAtTargetPosition(targetContentOffset.pointee.y + scrollView.contentInset.top, velocity: velocity.y)
    }
    
    public func xm_scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollToPosition(scrollView.contentOffset.y + scrollView.contentInset.top)
    }
}
