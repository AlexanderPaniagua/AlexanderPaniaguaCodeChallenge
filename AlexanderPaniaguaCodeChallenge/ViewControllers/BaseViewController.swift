//
//  BaseViewController.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 29/10/22.
//

import UIKit

/// Custom UIViewController base class to extend from child classes
class BaseViewController: UIViewController {
    // MARK: IBOutlet connections
    @IBOutlet weak var viewContent: UIView!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Class props
    var spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: Class methods
    func showAlert(message: String) {
        let alert = UIAlertController(title: "CodeChallenge", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoader() {
        self.spinner.startAnimating()
        self.spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.spinner)
        self.spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func hideLoader() {
        self.spinner.stopAnimating()
        self.spinner.removeFromSuperview()
    }

}
