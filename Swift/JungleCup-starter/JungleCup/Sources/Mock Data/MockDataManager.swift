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

protocol Team {
  var marks: [String] { get }
  var playerPictures: [[String]] { get }
}

struct Owls: Team {
  let marks = ["4/5", "3/5", "4/5", "2/5"]
  let playerPictures = [
    ["Owls-goalkeeper"],
    ["Owls-d1", "Owls-d2", "Owls-d3", "Owls-d4"],
    ["Owls-m1", "Owls-m2", "Owls-m3", "Owls-m4"],
    ["Owls-f1", "Owls-f2"]
  ]
}

struct Tigers: Team {
  let marks = ["1/5", "3/5", "3/5", "5/5"]
  let playerPictures = [
    ["Tigers-goalkeeper"],
    ["Tigers-d1", "Tigers-d2", "Tigers-d3", "Tigers-d4"],
    ["Tigers-m1", "Tigers-m2", "Tigers-m3", "Tigers-m4"],
    ["Tigers-f1", "Tigers-f2"]
  ]
}

struct Parrots: Team {
  let marks = ["3/5", "2/5", "4/5", "5/5"]
  let playerPictures = [
    ["Parrots-goalkeeper"],
    ["Parrots-d1", "Parrots-d2", "Parrots-d3", "Parrots-d4"],
    ["Parrots-m1", "Parrots-m2", "Parrots-m3", "Parrots-m4"],
    ["Parrots-f1", "Parrots-f2"]
  ]
}

struct Giraffes: Team {
  let marks = ["5/5", "4/5", "3/5", "1/5"]
  let playerPictures = [
    ["Giraffes-goalkeeper"],
    ["Giraffes-d1", "Giraffes-d2", "Giraffes-d3", "Giraffes-d4"],
    ["Giraffes-m1", "Giraffes-m2", "Giraffes-m3", "Giraffes-m4"],
    ["Giraffes-f1", "Giraffes-f2"]
  ]
}
