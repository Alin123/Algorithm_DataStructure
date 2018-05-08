//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by lianzhandong on 2018/5/8.
//  Copyright © 2018年 Razeware LLC. All rights reserved.
//

import UIKit


/*
 https://koenig-media.raywenderlich.com/uploads/2015/05/layout-lifecycle-667x500.png
 */

protocol PinterestLayoutDelegate: class {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
  weak var delegate: PinterestLayoutDelegate!
  
  fileprivate var numberOfColumns = 2
  fileprivate var cellPadding: CGFloat = 6
  
  fileprivate var cache = [UICollectionViewLayoutAttributes]()
  
  fileprivate var contentHeight: CGFloat = 0
  
  fileprivate var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    //1
    guard cache.isEmpty == true,
    let collectionView = collectionView else {
      return
    }
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffset = [CGFloat]()
    for column in 0 ..< numberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
    
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)
      let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
      let height = cellPadding * 2 + photoHeight
      let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)
      
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height
      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
  }
  
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
