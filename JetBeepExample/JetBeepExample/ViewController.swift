//
//  ViewController.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 2/26/19.
//  Copyright © 2019 Max Tymchii. All rights reserved.
//

import UIKit
import JetBeepFramework

class ViewController: UIViewController {

    @IBOutlet var textView: UITextView?
    private var logStack: String = ""

    var controller = JetBeepAnonymouseController.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "JetBeep logs"
        configTextView()
    }

    private func configTextView() {
        textView?.text = logStack
        Log.logCompletion = { [weak self] newText in
            guard let string = newText, let strongSelf = self else {
                return
            }
            strongSelf.logStack.append("\n\n\(string)")
            DispatchQueue.main.async {
                strongSelf.textView?.text = strongSelf.logStack
                let count = strongSelf.logStack.count
                let range = NSMakeRange(count - 1, 0)
                strongSelf.textView?.scrollRangeToVisible(range)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        controller.setup()
        controller.startMonitoring()
        controller.subscribeOnLocationEvents()
        controller.cacheData()
        NotificationController.shared.subscribeOnPushNotifications()
    }

}

