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

struct CustomLayoutSettings {

  // Elements sizes
  var itemSize: CGSize?
  var headerSize: CGSize?
  var menuSize: CGSize?
  var sectionsHeaderSize: CGSize?
  var sectionsFooterSize: CGSize?

  // Behaviours
  var isHeaderStretchy: Bool
  var isAlphaOnHeaderActive: Bool
  var headerOverlayMaxAlphaValue: CGFloat
  var isMenuSticky: Bool
  var isSectionHeadersSticky: Bool
  var isParallaxOnCellsEnabled: Bool

  // Spacing
  var minimumInteritemSpacing: CGFloat
  var minimumLineSpacing: CGFloat
  var maxParallaxOffset: CGFloat
}

extension CustomLayoutSettings {

  init() {
    self.itemSize = nil
    self.headerSize = nil
    self.menuSize = nil
    self.sectionsHeaderSize = nil
    self.sectionsFooterSize = nil
    self.isHeaderStretchy = false
    self.isAlphaOnHeaderActive = true
    self.headerOverlayMaxAlphaValue = 0
    self.isMenuSticky = false
    self.isSectionHeadersSticky = false
    self.isParallaxOnCellsEnabled = false
    self.maxParallaxOffset = 0
    self.minimumInteritemSpacing = 0
    self.minimumLineSpacing = 0
  }
}
