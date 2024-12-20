//
//  GameControllerVC.swift
//  MouseWordWars
//
//  Created by jin fu on 2024/12/20.
//


import UIKit

class ChristmasGameControllerVC: UIViewController {
    @IBOutlet weak var clashCollectionView: UICollectionView!
    @IBOutlet weak var tipsCollectionView: UICollectionView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var matchImageCollection: [UIImageView]!
    @IBOutlet var matchImageCountLabel: [UILabel]!
    @IBOutlet weak var highestScoreLabel: UILabel!
    
    
    
    
    
    struct Matched {
        let randomImage: String
        let randomCountImageNumber: Int
    }

    var imageArray = ["RS1", "RS2", "RS3", "RS4", "RS5"]
    var clashGridImages: [[String]] = []
    var match: [Matched] = []
    var tips: [String] = [] // Declare the tips array here
    var firstSelectedIndexPath: IndexPath? = nil // To track the first selected cell
    var score = 0 // Track the score
    var imageCounts: [String: Int] = [:] // To track counts for each image
    
    var highestScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "HighestScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "HighestScore")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Display the highest score
            highestScoreLabel.text = "Highest Score: \(highestScore)"
        // Generate 3 unique matches for the match logic
        let shuffledImages = imageArray.shuffled()
        for i in 0..<3 {
            let randomImage = shuffledImages[i]
            let randomNumber = Int.random(in: 0...9)
            let matchedItem = Matched(randomImage: randomImage, randomCountImageNumber: randomNumber)
            match.append(matchedItem)
        }

        // Display match images in matchImageCollection
        for (index, matchImageView) in matchImageCollection.enumerated() {
            if index < match.count {
                matchImageView.image = UIImage(named: match[index].randomImage)
            } else {
                matchImageView.image = nil // Clear any extra UIImageViews
            }
        }
        
        
        imageCounts = imageArray.reduce(into: [:]) { $0[$1] = 3 }
        updateLabels()

        // Display random counts in matchImageCountLabel
        for (index, matchCountLabel) in matchImageCountLabel.enumerated() {
            if index < match.count {
                matchCountLabel.text = "\(match[index].randomCountImageNumber)"
            } else {
                matchCountLabel.text = "" // Clear any extra UILabels
            }
        }

        // Populate clashGridImages for a 7x7 grid
        clashGridImages = (0..<7).map { _ in
            (0..<7).map { _ in imageArray.randomElement() ?? "DefaultImage" }
        }

        // Populate tips with 5 unique random images
        tips = Array(imageArray.shuffled().prefix(5))

        clashCollectionView.delegate = self
        clashCollectionView.dataSource = self
        tipsCollectionView.delegate = self
        tipsCollectionView.dataSource = self
        
        
        autoCheckAndResolveMatches()
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    private func autoCheckAndResolveMatches() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.checkMatches() // Call checkMatches recursively
        }
    }
    
    
    private func checkMatches() {
        if let matchedIndexes = checkForMatches() {
            // Process matches
            updateScore(for: matchedIndexes.count)
            updateMatchedCells(with: matchedIndexes)

            // Continue checking after resolving matches
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.autoCheckAndResolveMatches()
            }
        } else {
            // No matches found, continue auto-checking
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.autoCheckAndResolveMatches()
            }
        }
    }
    
    
    
    private func checkGameCompletion() {
        // Check if all labels have a value of 0
        let allZero = matchImageCountLabel.allSatisfy { label in
            guard let value = Int(label.text ?? "0") else { return false }
            return value == 0
        }

        if allZero {
            // Show alert and restart the game
            showCompletionAlert()
        }
    }
    
    
    private func showCompletionAlert() {
        let alert = UIAlertController(title: "Game Over", message: "All matches completed! Restarting the game.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.restartGame()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    private func restartGame() {
        // Reset the score
        score = 0
        scoreLabel.text = "Score: \(score)"

        // Display the highest score
        highestScoreLabel.text = "Highest Score: \(highestScore)"

        // Reset match image counts
        imageCounts = imageArray.reduce(into: [:]) { $0[$1] = 3 }
        for (index, label) in matchImageCountLabel.enumerated() {
            if index < imageArray.count {
                label.text = "\(imageCounts[imageArray[index]] ?? 3)"
            } else {
                label.text = ""
            }
        }

        // Reset the grid
        clashGridImages = (0..<7).map { _ in
            (0..<7).map { _ in imageArray.randomElement() ?? "DefaultImage" }
        }

        // Reload the collection view
        clashCollectionView.reloadData()

        // Restart auto-checking for matches
        autoCheckAndResolveMatches()
    }

    func resolveMatches() {
        if let matchedIndexes = checkForMatches() {
            updateScore(for: matchedIndexes.count)
            updateMatchedCells(with: matchedIndexes)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.resolveMatches() // Recursive check until no matches
            }
        }
    }
    func updateMatchedCells(with matchedIndexes: [IndexPath]) {
        for indexPath in matchedIndexes {
            guard let cell = clashCollectionView.cellForItem(at: indexPath) as? ChristmasClashCVCell else { continue }

            // Animate score increment
            let scoreLabel = UILabel(frame: cell.bounds)
            scoreLabel.text = "+10"
            scoreLabel.textAlignment = .center
            scoreLabel.textColor = .white
            scoreLabel.font = UIFont.boldSystemFont(ofSize: 16)
            scoreLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            scoreLabel.layer.cornerRadius = 5
            scoreLabel.clipsToBounds = true
            scoreLabel.alpha = 0

            cell.addSubview(scoreLabel)

            UIView.animate(withDuration: 0.3, animations: {
                scoreLabel.alpha = 1
            }) { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    scoreLabel.alpha = 0
                }) { _ in
                    scoreLabel.removeFromSuperview()

                    // Replace matched image
                    let row = indexPath.item / 7
                    let col = indexPath.item % 7
                    self.clashGridImages[row][col] = self.imageArray.randomElement() ?? "DefaultImage"

                    self.clashCollectionView.reloadItems(at: [indexPath])
                }
            }
        }

        // Update match counts and labels
        for indexPath in matchedIndexes {
            let row = indexPath.item / 7
            let col = indexPath.item % 7
            let image = clashGridImages[row][col]

            if let currentCount = imageCounts[image] {
                imageCounts[image] = max(0, currentCount - 1)
            }
        }

        updateLabels()

        // Check if the game is complete
        checkGameCompletion()
    }
    
    
       func updateLabels() {
           for (index, label) in matchImageCountLabel.enumerated() {
               if index < imageArray.count {
                   let image = imageArray[index]
                   label.text = "\(imageCounts[image] ?? 0)"
               } else {
                   label.text = ""
               }
           }
       }
    
    
        func checkForMatches() -> [IndexPath]? {
            var matchedIndexes = [IndexPath]()

            // Check rows
            for row in 0..<7 {
                var currentMatches = [IndexPath]()
                for col in 0..<7 {
                    if col > 0 && clashGridImages[row][col] == clashGridImages[row][col - 1] {
                        if currentMatches.isEmpty {
                            currentMatches.append(IndexPath(item: (row * 7) + (col - 1), section: 0))
                        }
                        currentMatches.append(IndexPath(item: (row * 7) + col, section: 0))
                    } else {
                        if currentMatches.count >= 3 {
                            matchedIndexes.append(contentsOf: currentMatches)
                        }
                        currentMatches.removeAll()
                    }
                }
                if currentMatches.count >= 3 {
                    matchedIndexes.append(contentsOf: currentMatches)
                }
            }

            for col in 0..<7 {
                var currentMatches = [IndexPath]()
                for row in 0..<7 {
                    if row > 0 && clashGridImages[row][col] == clashGridImages[row - 1][col] {
                        if currentMatches.isEmpty {
                            currentMatches.append(IndexPath(item: ((row - 1) * 7) + col, section: 0))
                        }
                        currentMatches.append(IndexPath(item: (row * 7) + col, section: 0))
                    } else {
                        if currentMatches.count >= 3 {
                            matchedIndexes.append(contentsOf: currentMatches)
                        }
                        currentMatches.removeAll()
                    }
                }
                if currentMatches.count >= 3 {
                    matchedIndexes.append(contentsOf: currentMatches)
                }
            }

            return matchedIndexes.isEmpty ? nil : matchedIndexes
        }

    
    func updateScore(for matchCount: Int) {
        let points: Int
        switch matchCount {
        case 3:
            points = 10
        case 4:
            points = 20
        case 5:
            points = 50
        default:
            points = 0
        }
        score += points
        scoreLabel.text = "Score: \(score)"

        // Check and update the highest score
        if score > highestScore {
            highestScore = score
        }
    }
    
}

extension ChristmasGameControllerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clashCollectionView {
            return 7 * 7 // 7x7 grid
        } else if collectionView == tipsCollectionView {
            return tips.count // 5 images
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == clashCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clashCVCell", for: indexPath) as! ChristmasClashCVCell
            let row = indexPath.item / 7
            let col = indexPath.item % 7
            let imageName = clashGridImages[row][col]
            cell.clashImage.image = UIImage(named: imageName)
            return cell
        } else if collectionView == tipsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tipsCVCell", for: indexPath) as! ChristmasTipsCVCell
            let imageName = tips[indexPath.item]
            cell.tipsImage.image = UIImage(named: imageName)
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == clashCollectionView {
            if firstSelectedIndexPath == nil {
                // Mark the first selected cell
                firstSelectedIndexPath = indexPath
            } else {
                // Handle the second selection
                guard let firstIndexPath = firstSelectedIndexPath else { return }

                let firstRow = firstIndexPath.item / 7
                let firstCol = firstIndexPath.item % 7
                let secondRow = indexPath.item / 7
                let secondCol = indexPath.item % 7

                // Swap images in the grid
                let temp = clashGridImages[firstRow][firstCol]
                clashGridImages[firstRow][firstCol] = clashGridImages[secondRow][secondCol]
                clashGridImages[secondRow][secondCol] = temp

                // Apply swap animation
                UIView.transition(with: clashCollectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.clashCollectionView.reloadData()
                }) { _ in
                    // Check for matches after swap
                    if let matchedIndexes = self.checkForMatches() {
                        self.updateScore(for: matchedIndexes.count)
                        self.updateMatchedCells(with: matchedIndexes)
                       
                    } else {
                        // Revert the swap if no matches
                        let temp = self.clashGridImages[firstRow][firstCol]
                        self.clashGridImages[firstRow][firstCol] = self.clashGridImages[secondRow][secondCol]
                        self.clashGridImages[secondRow][secondCol] = temp

                        UIView.transition(with: self.clashCollectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            self.clashCollectionView.reloadData()
                        }, completion: nil)
                    }
                }

                firstSelectedIndexPath = nil
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == clashCollectionView {
            
            return CGSize(width: collectionView.frame.width / 7 , height: collectionView.frame.height / 7)
        } else if collectionView == tipsCollectionView {
            return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height)
        }
        return CGSize.zero
    }
}
