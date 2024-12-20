//
//  FuncTool.swift
//  MouseWordWars
//
//  Created by Christmas Clash: Mouse Word Wars on 2024/12/20.
//


import UIKit

func showAlert(on viewController: UIViewController, title: String, message: String) {
    // Create the alert controller
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    // Add an OK action to the alert
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        viewController.navigationController?.popViewController(animated: true)
    }
    alert.addAction(okAction)
    
    viewController.present(alert, animated: true, completion: nil)
}
