//
//  SnapScroll.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-03.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class SnapScroll: UIScrollView, UIScrollViewDelegate{
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var final = targetContentOffset.memory
        var cellIndex = round(final.y / scrollView.frame.height);
        targetContentOffset.initialize(CGPoint(x: final.x, y: cellIndex * scrollView.frame.height))
    }
}