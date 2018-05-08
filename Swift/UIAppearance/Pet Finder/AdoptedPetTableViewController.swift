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

class AdoptedPetTableViewController: UITableViewController {

  // MARK: - Properties
  let dataProvider = PetsDataProvider.sharedProvider

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = 110
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    tableView.reloadData()
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowPet",
      let controller = segue.destination as? PetViewController,
      let tableViewCell = sender as? UITableViewCell,
      let selectedPetIndex = tableView.indexPath(for: tableViewCell)?.row {
        let pet = dataProvider.pets[selectedPetIndex]
        controller.pet = pet
    }
  }
}

// MARK: - UITableViewDatasource
extension AdoptedPetTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataProvider.adoptedPets.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritePetCell", for: indexPath)
    let pet = dataProvider.adoptedPets[indexPath.row]
    cell.imageView?.image = UIImage(named: pet.imageName)
    cell.imageView?.layer.masksToBounds = true
    cell.imageView?.layer.cornerRadius = 5
    
    cell.detailTextLabel?.text = dataProvider.adoptedPets[indexPath.row].type
    
    cell.textLabel?.text = dataProvider.adoptedPets[indexPath.row].name
    
    return cell
  }
}
