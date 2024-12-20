//
//  SearchGiftVC.swift
//  MouseWordWars
//
//  Created by Christmas Clash: Mouse Word Wars on 2024/12/20.
//

import UIKit

class ChristmasSearchGiftVC: UIViewController {
    
    @IBOutlet weak var treeView: UIView!
    @IBOutlet var checkImageCollection: [UIImageView]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var imageArray = ["RS1", "RS2", "RS3", "RS4", "RS5", "RS6", "RS7", "RS8"]
    var randomFiveImagesAssigned = [String]()
    var tappedImages = Set<String>()
    var imageViewsInTree: [UIImageView] = []
    var score = 0 // Track the current score
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignRandomImagesToCollection()
        setupImageTapGestures()
        addImagesToTreeView()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // Assign random images to the image collection
    func assignRandomImagesToCollection() {
        randomFiveImagesAssigned = Array(imageArray.shuffled().prefix(5))
        for (index, imageView) in checkImageCollection.enumerated() {
            if index < randomFiveImagesAssigned.count {
                imageView.image = UIImage(named: randomFiveImagesAssigned[index])
            } else {
                imageView.image = nil // Clear any extra image views
            }
        }
    }
    
    // Add random images to treeView
    func addImagesToTreeView() {
        for imageName in randomFiveImagesAssigned {
            if let image = UIImage(named: imageName) {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.frame.size = CGSize(width: 50, height: 50) // Adjust size if needed
                
                // Position the imageView randomly inside the treeView
                let randomX = CGFloat.random(in: 0...(treeView.bounds.width - imageView.frame.width))
                let randomY = CGFloat.random(in: 0...(treeView.bounds.height - imageView.frame.height))
                imageView.frame.origin = CGPoint(x: randomX, y: randomY)
                
                imageView.isUserInteractionEnabled = true
                imageView.tag = randomFiveImagesAssigned.firstIndex(of: imageName) ?? -1 // Tag for matching
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(treeImageTapped(_:)))
                imageView.addGestureRecognizer(tapGesture)
                
                // Add the imageView to the treeView
                treeView.addSubview(imageView)
                imageViewsInTree.append(imageView)
            }
        }
    }
    
    // Setup tap gestures for checkImageCollection
    func setupImageTapGestures() {
        for imageView in checkImageCollection {
            imageView.isUserInteractionEnabled = true
            imageView.layer.borderWidth = 0
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @objc func treeImageTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        
        // Check if the tapped image matches any in the collection
        if tappedImageView.tag != -1 {
            let tappedImageName = randomFiveImagesAssigned[tappedImageView.tag]
            if !tappedImages.contains(tappedImageName) {
                tappedImages.insert(tappedImageName)
                
                // Increment score
                score += 10
                scoreLabel.text = "Score: \(score)"
                
                // Highlight the corresponding image in the collection
                if let matchingImageView = checkImageCollection.first(where: { $0.image == UIImage(named: tappedImageName) }) {
                    matchingImageView.layer.borderWidth = 2
                    matchingImageView.layer.borderColor = UIColor.green.cgColor
                }
                
                // Add a checkmark or visual indication to the treeView image
                let checkmark = UILabel(frame: CGRect(x: tappedImageView.frame.width - 20, y: tappedImageView.frame.height - 20, width: 20, height: 20))
                checkmark.text = "✓"
                checkmark.textColor = .green
                checkmark.font = UIFont.boldSystemFont(ofSize: 16)
                tappedImageView.addSubview(checkmark)
            }
        }
        
        // Check if all images are tapped
        if tappedImages.count == randomFiveImagesAssigned.count {
            showCompletionAlert()
        }
    }
    
    func showCompletionAlert() {
        let alert = UIAlertController(title: "Congratulations!", message: "You found all the images!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.resetGame()
        }))
        present(alert, animated: true)
    }
    
    func resetGame() {
        // Reset the game state
        tappedImages.removeAll()
        imageViewsInTree.forEach { $0.removeFromSuperview() }
        imageViewsInTree.removeAll()
        //score = 0 // Reset score
        scoreLabel.text = "Score: \(score)"
        
        assignRandomImagesToCollection()
        addImagesToTreeView()
        
        for imageView in checkImageCollection {
            imageView.layer.borderWidth = 0
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
