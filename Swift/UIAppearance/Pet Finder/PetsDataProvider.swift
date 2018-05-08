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

import Foundation

class PetsDataProvider {

  // MARK: - Properties
  static let sharedProvider = PetsDataProvider()
  
  let pets: [Pet]
  private(set) var adoptedPets: [Pet] = []

  // MARK: - Initializers
  init() {
    self.pets = [Pet(name: "Rusty", type: "Golden Retriever", imageName: "pet0"),
                 Pet(name: "Max", type: "Mixed Terrier", imageName: "pet1"),
                 Pet(name: "Lucifer", type: "Freaked Out", imageName: "pet2"),
                 Pet(name: "Tiger", type: "Sensitive Whiskers", imageName: "pet3"),
                 Pet(name: "Widget", type: "Mouse Catcher", imageName: "pet4"),
                 Pet(name: "Wiggles", type: "Border Collie", imageName: "pet5"),
                 Pet(name: "Clover", type: "Mixed Breed", imageName: "pet6"),
                 Pet(name: "Snow White", type: "Black Cat", imageName: "pet7")]
  }

  // MARK: - Internal
  func adopt(pet: Pet) {
    guard !adoptedPets.contains(pet) else { return }

    adoptedPets.append(pet)
  }
}
