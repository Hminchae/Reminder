//
//  UIViewController+Extension.swift
//  Reminder
//
//  Created by 황민채 on 7/4/24.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, 
                   message: String,
                   confirm: String,
                   completionHandler: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let confirm = UIAlertAction(title: confirm, style: .default) { _ in
            completionHandler()
        }
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
