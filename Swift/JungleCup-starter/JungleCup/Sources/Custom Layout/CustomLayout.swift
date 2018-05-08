/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

final class CustomLayout: UICollectionViewLayout {
  
  enum Element: String {
    case header
    case menu
    case sectionHeader
    case sectionFooter
    case cell
    
    var id: String {
      return self.rawValue
    }
    
    var kind: String {
      return "Kind\(self.rawValue.capitalized)"
    }
  }
  // 2
  override public class var layoutAttributesClass: AnyClass {
    print("layoutAttributesClass:")
    return CustomLayoutAttributes.self
  }
  // 3
  override public var collectionViewContentSize: CGSize {
    print("collectionViewContentSize:")
    return CGSize(width: collectionViewWith, height: contentHeight)
  }
  
  // 4
  var settings = CustomLayoutSettings()
  private var oldBounds = CGRect.zero
  private var contentHeight = CGFloat()
  private var cache = [Element: [IndexPath: CustomLayoutAttributes]]()
  private var visibleLayoutAttributes = [CustomLayoutAttributes]()
  private var zIndex = 0
  
  
  // 5
  private var collectionViewHeight: CGFloat {
    return collectionView!.frame.height
  }
  private var collectionViewWith: CGFloat {
    return collectionView!.frame.width
  }
  
  private var cellHeight: CGFloat {
    guard let itemSize = settings.itemSize else {
      return collectionViewHeight
    }
    return itemSize.height
  }
  
  private var cellWidth: CGFloat {
    guard let itemSize = settings.itemSize else {
      return collectionViewWith
    }
    return itemSize.width
  }
  private var headerSize: CGSize {
    guard let headerSize = settings.headerSize else {
      return .zero
    }
    return headerSize
  }
  
  private var menuSize: CGSize {
    guard let menuSize = settings.menuSize else {
      return .zero
    }
    return menuSize
  }
  
  private var sectionHeaderSize: CGSize {
    guard let sectionHeaderSize = settings.sectionsHeaderSize else {
      return .zero
    }
    return sectionHeaderSize
  }
  
  private var sectionFooterSize: CGSize {
    guard let sectionFooterSize = settings.sectionsFooterSize else {
      return .zero
    }
    return sectionFooterSize
  }
  
  private var contentOffset: CGPoint {
    return collectionView!.contentOffset
  }
}

extension CustomLayout {
  override func prepare() {
    print("prepare:")
    // 1
    guard let collectionView = collectionView,
    cache.isEmpty else {
      return
    }
    // 2
    prepareCache()
    contentHeight = 0 //总高度
    zIndex = 0
    oldBounds = collectionView.bounds
    let itemSize = CGSize(width: cellWidth, height: cellHeight)
    
    
    // 3
    let headerAttributes = CustomLayoutAttributes(
      forSupplementaryViewOfKind: Element.header.kind,
      with: IndexPath(item: 0, section: 0)
    )
    prepareElement(size: headerSize, type: .header, attributes: headerAttributes)
    
    
    // 4
    let menuAttributes = CustomLayoutAttributes(
      forSupplementaryViewOfKind: Element.menu.kind,
      with: IndexPath(item: 0, section: 0)
    )
    prepareElement(size: menuSize, type: .menu, attributes: menuAttributes)
    
    // 5
    for section in 0..<collectionView.numberOfSections {
      let sectionHeaderAttributes = CustomLayoutAttributes(
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
        with: IndexPath(item: 0, section: section))
      prepareElement(size: sectionHeaderSize, type: .sectionHeader, attributes: sectionHeaderAttributes)
      
      for item in 0..<collectionView.numberOfItems(inSection: section) {
        let cellIndexPath = IndexPath(item: item, section: section)
        let attributes = CustomLayoutAttributes(forCellWith: cellIndexPath)
        let lineInterSapce = settings.minimumLineSpacing
        attributes.frame = CGRect(
          x: 0 + settings.minimumInteritemSpacing,
          y: contentHeight + lineInterSapce,
          width: itemSize.width,
          height: itemSize.height
        )
        attributes.zIndex = zIndex
        contentHeight = attributes.frame.maxY
        cache[.cell]?[cellIndexPath] = attributes
        zIndex += 1
      }
      
      let sectionFooterAttributes = CustomLayoutAttributes(
        forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
        with: IndexPath(item: 1, section: section)
      )
      prepareElement(size: sectionFooterSize, type: .sectionFooter, attributes: sectionFooterAttributes)
    }
    // 6
    updateZIndexes()
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    print("shouldInvalidateLayout")
    if oldBounds.size != newBounds.size {
      cache.removeAll(keepingCapacity: true)
    }
    return true
  }
  
  private func prepareCache() {
    cache.removeAll(keepingCapacity: true)
    cache[.header] = [IndexPath: CustomLayoutAttributes]()
    cache[.menu] = [IndexPath: CustomLayoutAttributes]()
    cache[.sectionHeader] = [IndexPath: CustomLayoutAttributes]()
    cache[.sectionFooter] = [IndexPath: CustomLayoutAttributes]()
    cache[.cell] = [IndexPath: CustomLayoutAttributes]()
  }
  
  private func prepareElement(size: CGSize, type: Element, attributes: CustomLayoutAttributes) {
    // 1
    guard size != .zero else {
      return
    }
    // 2
    attributes.initialOrigin = CGPoint(x: 0, y: contentHeight)
    attributes.frame = CGRect(origin: attributes.initialOrigin, size: size)
    // 3
    attributes.zIndex = zIndex
    zIndex += 1
    // 4
    contentHeight = attributes.frame.maxY
    // 5
    cache[type]?[attributes.indexPath] = attributes
  }
  
  private func updateZIndexes() {
    guard let sectionHeaders = cache[.sectionHeader] else {
      return
    }
    var sectionHeadersZIndex = zIndex
    for (_, atttributes) in sectionHeaders {
      atttributes.zIndex = sectionHeadersZIndex
      sectionHeadersZIndex += 1
    }
    cache[.menu]?.first?.value.zIndex = sectionHeadersZIndex
  }
}

extension CustomLayout {
  // 1
  override func layoutAttributesForSupplementaryView(
    ofKind elementKind: String,
    at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    print("layoutAttributesForSupplementaryView")
    switch elementKind {
    case UICollectionElementKindSectionHeader:
      return cache[.sectionHeader]?[indexPath]
    case UICollectionElementKindSectionFooter:
      return cache[.sectionFooter]?[indexPath]
    case Element.header.kind:
      return cache[.header]?[indexPath]
    default:
      return cache[.menu]?[indexPath]
    }
  }
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    print(#function)
    return cache[.cell]?[indexPath]
  }
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    print("layoutAttributesForElements")
    guard let collectionView = collectionView else {
      return nil
    }
    visibleLayoutAttributes.removeAll(keepingCapacity: true)
    // 1.避免重复计算
    let halfHeight = collectionViewHeight * 0.5
    let halfCellHeight = cellHeight * 0.5
    // 2.枚举所有缓存的属性
    for (type, elementInfos) in cache {
      for (indexPath, attributes) in elementInfos {
        // 3.设置默认的
        attributes.parallax = .identity
        attributes.transform = .identity
        // 4
        updateSupplementaryViews(type, attributes: attributes, collectionView: collectionView, indexPath: indexPath)
        if attributes.frame.intersects(rect) {
          if type == .cell,
            settings.isParallaxOnCellsEnabled {
            updateCells(attributes, halfHeight: halfHeight, halfCellHeight: halfCellHeight)
          }
          visibleLayoutAttributes.append(attributes)
        }
      }
    }
    return visibleLayoutAttributes
  }
  private func updateSupplementaryViews(_ type: Element,
                                        attributes: CustomLayoutAttributes,
                                        collectionView: UICollectionView,
                                        indexPath: IndexPath) {
    // 分区的头部
    if type == .sectionHeader,
      settings.isSectionHeadersSticky {
      // 当前分区的总高度
      let upperLimit = CGFloat(collectionView.numberOfItems(inSection: indexPath.section)) * (cellHeight + settings.minimumLineSpacing)
      let menuOffset = settings.isMenuSticky ? menuSize.height : 0
      attributes.transform = CGAffineTransform(
        translationX: 0,
        y: min(upperLimit,
               max(0, contentOffset.y - attributes.initialOrigin.y + menuOffset)))
    } else if type == .header,
      settings.isHeaderStretchy {
      let updateHeight = min(
        collectionView.frame.height,
        max(headerSize.height, headerSize.height - contentOffset.y)
      )
      let scaleFactor  = updateHeight / headerSize.height
      let delta = (updateHeight - headerSize.height) / 2
      let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
      let translation = CGAffineTransform(translationX: 0, y: min(contentOffset.y, headerSize.height) + delta)
      attributes.transform = scale.concatenating(translation)
      if settings.isAlphaOnHeaderActive {
        attributes.headerOverlayAlpha = min(settings.headerOverlayMaxAlphaValue, contentOffset.y / headerSize.height)
      }
    } else if type == .menu,
      settings.isMenuSticky {
      attributes.transform = CGAffineTransform(
        translationX: 0,
        y: max(attributes.initialOrigin.y, contentOffset.y) - headerSize.height
      )
    }
  }
  
  private func updateCells(_ attributes: CustomLayoutAttributes,
                           halfHeight: CGFloat,
                           halfCellHeight: CGFloat) {
    // 1.计算cell中心到collectionView中心的距离
    let cellDistanceFromCenter = attributes.center.y - contentOffset.y - halfHeight
    // 2.将单元格与中心的距离映射到最大视差值
    let parallaxOffset = -(settings.maxParallaxOffset * cellDistanceFromCenter) / (halfHeight + halfCellHeight)
    // 3
    let boundedParallaxOffset = min(max(-settings.maxParallaxOffset, parallaxOffset), settings.maxParallaxOffset)
    // 4
    attributes.parallax = CGAffineTransform(translationX: 0, y: boundedParallaxOffset)
  }
  
}
