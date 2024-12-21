//
//  GameControllerVC.swift
//  MouseWordWars
//
//  Created by Christmas Clash: Mouse Word Wars on 2024/12/20.
//


import UIKit

class ChristmasGameControllerVC: UIViewController {
    @IBOutlet weak var clashCollectionView: UICollectionView!
    @IBOutlet weak var tipsCollectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var matchImageCollection: [UIImageView]!
    @IBOutlet var matchImageCountLabel: [UILabel]!
    @IBOutlet weak var highestScoreLabel: UILabel!

    private var gridSize = 7
    private var imageArray = ["RS1", "RS2", "RS3", "RS4", "RS5"]
    private var clashGridImages: [[String]] = []
    private var match: [Matched] = []
    private var tips: [String] = []
    private var firstSelectedIndexPath: IndexPath?
    private var score = 0
    private var imageCounts: [String: Int] = [:]

    var highestScore: Int {
        get { UserDefaults.standard.integer(forKey: "HighestScore") }
        set { UserDefaults.standard.set(newValue, forKey: "HighestScore") }
    }

    struct Matched {
        let randomImage: String
        let randomCountImageNumber: Int
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load - Setting up the game")
        setupGame()
        addSwipeGestureRecognizers()
        
        showDelayedAlert(on: self)
    }
    
    func showDelayedAlert(on viewController: UIViewController) {
        // Delay for 0.1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Create an alert
            let alert = UIAlertController(title: "How to play?",
                                          message: "Move and match three or more identical items horizontally and vertically to get points and eliminate them",
                                          preferredStyle: .alert)
            
            // Add OK button
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            // Present the alert
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    private func setupGame() {
        print("Setup Game - Reset score and initialize components")
        score = 0
        scoreLabel.text = "Score: \(score)"
        highestScoreLabel.text = "Highest Score: \(highestScore)"

        initializeMatchImages()
        initializeTips()
        generateNonMatchingGrid()

        clashCollectionView.delegate = self
        clashCollectionView.dataSource = self
        tipsCollectionView.delegate = self
        tipsCollectionView.dataSource = self

        clashCollectionView.reloadData()
        tipsCollectionView.reloadData()
    }

    private func initializeMatchImages() {
        print("Initializing match images")
        match.removeAll()
        let shuffledImages = imageArray.shuffled()
        for i in 0..<3 {
            let randomImage = shuffledImages[i]
            let randomNumber = Int.random(in: 5...15)
            match.append(Matched(randomImage: randomImage, randomCountImageNumber: randomNumber))
        }

        for (index, matchImageView) in matchImageCollection.enumerated() {
            if index < match.count {
                matchImageView.image = UIImage(named: match[index].randomImage)
                matchImageCountLabel[index].text = "\(match[index].randomCountImageNumber)"
            } else {
                matchImageView.image = nil
                matchImageCountLabel[index].text = ""
            }
        }

        imageCounts = match.reduce(into: [:]) { $0[$1.randomImage] = $1.randomCountImageNumber }
        print("Match Images Initialized: \(match)")
    }

    private func initializeTips() {
        print("Initializing tips")
        tips = Array(imageArray.shuffled().prefix(5))
        print("Tips Initialized: \(tips)")
    }

    private func generateNonMatchingGrid() {
        print("Generating non-matching grid")
        clashGridImages = Array(repeating: Array(repeating: "", count: gridSize), count: gridSize)

        for row in 0..<gridSize {
            for col in 0..<gridSize {
                var availableImages = imageArray

                if col >= 2 && clashGridImages[row][col - 1] == clashGridImages[row][col - 2] {
                    availableImages.removeAll { $0 == clashGridImages[row][col - 1] }
                }

                if row >= 2 && clashGridImages[row - 1][col] == clashGridImages[row - 2][col] {
                    availableImages.removeAll { $0 == clashGridImages[row - 1][col] }
                }

                clashGridImages[row][col] = availableImages.randomElement() ?? imageArray.first!
            }
        }
        print("Grid Generated: \(clashGridImages)")
    }

//    private func autoCheckAndResolveMatches() {
//        print("Auto Check for Matches")
//        let matches = checkForMatches()
//        if !matches.isEmpty {
//            print("Matches Found: \(matches)")
//            resolveMatches(matches)
//        } else {
//            print("No Matches Found")
//        }
//    }

    private func checkForMatches() -> [IndexPath] {
        var matches = [IndexPath]()
        print("Checking for matches")

        // Check rows
        for row in 0..<gridSize {
            var currentMatches = [IndexPath]()
            for col in 0..<gridSize {
                if col > 0, clashGridImages[row][col] == clashGridImages[row][col - 1] {
                    if currentMatches.isEmpty {
                        currentMatches.append(IndexPath(item: (row * gridSize) + col - 1, section: 0))
                    }
                    currentMatches.append(IndexPath(item: (row * gridSize) + col, section: 0))
                } else {
                    if currentMatches.count >= 3 { matches.append(contentsOf: currentMatches) }
                    currentMatches.removeAll()
                }
            }
            if currentMatches.count >= 3 { matches.append(contentsOf: currentMatches) }
        }

        // Check columns
        for col in 0..<gridSize {
            var currentMatches = [IndexPath]()
            for row in 0..<gridSize {
                if row > 0, clashGridImages[row][col] == clashGridImages[row - 1][col] {
                    if currentMatches.isEmpty {
                        currentMatches.append(IndexPath(item: ((row - 1) * gridSize) + col, section: 0))
                    }
                    currentMatches.append(IndexPath(item: (row * gridSize) + col, section: 0))
                } else {
                    if currentMatches.count >= 3 { matches.append(contentsOf: currentMatches) }
                    currentMatches.removeAll()
                }
            }
            if currentMatches.count >= 3 { matches.append(contentsOf: currentMatches) }
        }

        print("Matches Checked: \(matches)")
        return matches
    }

//    private func resolveMatches(_ matches: [IndexPath]) {
//        print("Resolving Matches")
//        for indexPath in matches {
//            let row = indexPath.item / gridSize
//            let col = indexPath.item % gridSize
//            let matchedImage = clashGridImages[row][col]
//
//            if let currentCount = imageCounts[matchedImage], currentCount > 0 {
//                imageCounts[matchedImage] = currentCount - 1
//                updateMatchLabels()
//            }
//
//            clashGridImages[row][col] = imageArray.randomElement() ?? imageArray.first!
//        }
//
//        score += matches.count * 10
//        scoreLabel.text = "Score: \(score)"
//        if score > highestScore {
//            highestScore = score
//        }
//
//        clashCollectionView.reloadItems(at: matches)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.autoCheckAndResolveMatches()
//        }
//    }

    private func updateMatchLabels() {
        print("Updating Match Labels")
        for (index, label) in matchImageCountLabel.enumerated() {
            if index < match.count {
                let image = match[index].randomImage
                label.text = "\(imageCounts[image] ?? 0)"
            } else {
                label.text = ""
            }
        }
    }

    private func addSwipeGestureRecognizers() {
        print("Adding swipe gesture recognizers")
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        directions.forEach { direction in
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipe.direction = direction
            clashCollectionView.addGestureRecognizer(swipe)
        }
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard let indexPath = clashCollectionView.indexPathForItem(at: gesture.location(in: clashCollectionView)) else { return }
        print("Handling swipe at indexPath: \(indexPath) with direction: \(gesture.direction)")

        let (row, col) = (indexPath.item / gridSize, indexPath.item % gridSize)
        let neighbor: IndexPath?

        switch gesture.direction {
        case .up:
            neighbor = row > 0 ? IndexPath(item: (row - 1) * gridSize + col, section: 0) : nil
        case .down:
            neighbor = row < gridSize - 1 ? IndexPath(item: (row + 1) * gridSize + col, section: 0) : nil
        case .left:
            neighbor = col > 0 ? IndexPath(item: row * gridSize + col - 1, section: 0) : nil
        case .right:
            neighbor = col < gridSize - 1 ? IndexPath(item: row * gridSize + col + 1, section: 0) : nil
        default:
            neighbor = nil
        }

        guard let neighborIndexPath = neighbor else { return }

        print("Swapping with neighbor at indexPath: \(neighborIndexPath)")

        // Swap images
        let temp = clashGridImages[row][col]
        clashGridImages[row][col] = clashGridImages[neighborIndexPath.item / gridSize][neighborIndexPath.item % gridSize]
        clashGridImages[neighborIndexPath.item / gridSize][neighborIndexPath.item % gridSize] = temp

        clashCollectionView.reloadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.autoCheckAndResolveMatches()
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    private func autoCheckAndResolveMatches() {
        print("Auto Check for Matches")
        let matches = checkForMatches()
        if !matches.isEmpty {
            print("Matches Found: \(matches)")
            resolveMatches(matches)
        } else if isLevelComplete() {
            print("Level Complete!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showLevelCompleteAlert()
            }
        } else {
            print("No Matches Found")
        }
    }

    private func resolveMatches(_ matches: [IndexPath]) {
        print("Resolving Matches")
        for indexPath in matches {
            let row = indexPath.item / gridSize
            let col = indexPath.item % gridSize
            let matchedImage = clashGridImages[row][col]

            if let currentCount = imageCounts[matchedImage], currentCount > 0 {
                imageCounts[matchedImage] = currentCount - 1
                updateMatchLabels()
            }

            clashGridImages[row][col] = imageArray.randomElement() ?? imageArray.first!
        }

        score += matches.count * 10
        scoreLabel.text = "Score: \(score)"
        if score > highestScore {
            highestScore = score
        }

        clashCollectionView.reloadItems(at: matches)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.autoCheckAndResolveMatches()
        }
    }

    private func isLevelComplete() -> Bool {
        let allZero = matchImageCountLabel.allSatisfy { label in
            guard let value = Int(label.text ?? "0") else { return false }
            return value == 0
        }
        return allZero
    }

    private func showLevelCompleteAlert() {
        print("Showing Level Complete Alert")
        let alert = UIAlertController(title: "Level Complete!", message: "You've collected all matches. Starting a new level.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.restartGame()
        }))
        present(alert, animated: true, completion: nil)
    }

    private func restartGame() {
        print("Restarting Game")
        setupGame()
    }
    
}

// MARK: - UICollectionViewDelegate, DataSource

extension ChristmasGameControllerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == clashCollectionView ? gridSize * gridSize : tips.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == clashCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clashCVCell", for: indexPath) as! ChristmasClashCVCell
            let row = indexPath.item / gridSize
            let col = indexPath.item % gridSize
            cell.clashImage.image = UIImage(named: clashGridImages[row][col])
            return cell
        } else if collectionView == tipsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tipsCVCell", for: indexPath) as! ChristmasTipsCVCell
            cell.tipsImage.image = UIImage(named: tips[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView == clashCollectionView ? collectionView.frame.width / CGFloat(gridSize) : collectionView.frame.width / 5
        return CGSize(width: size, height: size)
    }
}
