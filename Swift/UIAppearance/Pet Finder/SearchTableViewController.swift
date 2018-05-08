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
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import UIKit

class SearchTableViewController: UITableViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var numberOfPawsLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var searchProgress: UIProgressView!
  @IBOutlet weak var pawStepper: UIStepper!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var distanceSlider: UISlider!
  @IBOutlet weak var speciesSelector: UISegmentedControl!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissAnimated))
    
    updateNumberOfPaws(pawStepper)
    updateDistance(distanceSlider)
    
    speciesSelector.setImage(UIImage(named: "dog"), forSegmentAt: 0)
    speciesSelector.setImage(UIImage(named: "cat"), forSegmentAt: 1)
    
  }
}

// MARK: - Actions
private extension SearchTableViewController {

  @objc func dismissAnimated() {
    dismiss(animated: true)
  }
  
  func hideKeyboard() {
    nameTextField.resignFirstResponder()
  }
  
  @IBAction func updateDistance(_ sender: UISlider) {
    distanceLabel.text = "\(Int(sender.value)) miles"
  }
  
  @IBAction func updateNumberOfPaws(_ sender: UIStepper) {
    numberOfPawsLabel.text = "\(Int(sender.value)) paws"
  }
  
  @IBAction func search(_ sender: UIButton) {
    UIView.animate(withDuration: TimeInterval(2.0), animations: {
      self.searchProgress.setProgress(1.0, animated: true)
      self.view.alpha = 0.7
    }, completion: { finished in
      if finished {
        self.dismissAnimated()
      }
    })
  }
}

// MARK: - UIScrollViewDelegate
extension SearchTableViewController {

  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    hideKeyboard()
  }
}

// MARK: - UITextFieldDelegate
extension SearchTableViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    hideKeyboard()
    return true
  }
}
