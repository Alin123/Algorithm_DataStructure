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

class ViewController: UIViewController {
  
  @IBOutlet weak var counterView: CounterView!
  @IBOutlet weak var counterLabel: UILabel!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var graphView: GraphView!
  @IBOutlet weak var averageWaterDrunk: UILabel!
  @IBOutlet weak var maxLabel: UILabel!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var medalView: MedalView!
  
  var isGraphViewShowing = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    counterLabel.text = String(counterView.counter)
    setupGraphDisplay()
  }

  func setupGraphDisplay() {
    let maxDayIndex = stackView.arrangedSubviews.count - 1
    graphView.graphPoints[graphView.graphPoints.count - 1] = counterView.counter
    graphView.setNeedsDisplay()
    
    maxLabel.text = "\(graphView.graphPoints.max()!)"
    let average = graphView.graphPoints.reduce(0, +) / graphView.graphPoints.count
    averageWaterDrunk.text = "Average: \(average)"
    
    let today = Date()
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEEE")
    for i in 0..<maxDayIndex {
      if let date = calendar.date(byAdding: .day, value: -i, to: today),
        let label = stackView.arrangedSubviews[maxDayIndex - i] as? UILabel {
        label.text = formatter.string(from: date)
      }
    }
  }
  
  @IBAction func pushButtonPressed(_ button: PushButton) {
    if button.isAddButtion {
      if counterView.counter < counterView.MAX {
        counterView.counter += 1
      }
    } else {
      if counterView.counter > 0 {
        counterView.counter -= 1
      }
    }
    counterLabel.text = String(counterView.counter)
    if isGraphViewShowing {
      counterViewTap(nil)
    }
    checkTotal()
  }
  
  @IBAction func counterViewTap(_ geture: UITapGestureRecognizer?) {
    if isGraphViewShowing {
      // hide Graph
      UIView.transition(from: graphView,
                        to: counterView,
                        duration: 1.0,
                        options: [.transitionFlipFromLeft, .showHideTransitionViews],
                        completion: nil)
    } else {
      UIView.transition(from: counterView,
                        to: graphView,
                        duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews],
                        completion: nil)
    }
    isGraphViewShowing = !isGraphViewShowing
  }
  
  func checkTotal() {
    if counterView.counter >= 8 {
      medalView.showMedal(show: true)
    } else {
      medalView.showMedal(show: false)
    }
  }
  
}


