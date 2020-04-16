//
//  ViewController.swift
//  SSE-Demo
//
//  Created by Marco Marengo on 16/04/2020.
//  Copyright © 2020 Marco Marengo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var messagesTextView: UITextView!
    
    private var eventSource: EventSource = {
        let serverURL = URL(string: "http://127.0.0.1:3000/sse")!
        return EventSource(url: serverURL, headers: ["Authorization": "Bearer basic-auth-token"])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        resetUI()
        
        configureEventSource()
    }
    
    private func configureEventSource() {
        eventSource.onOpen { [weak self] in
            NSLog("=> onOpen");
            //self?.statusLabel.backgroundColor = UIColor(red: 166/255, green: 226/255, blue: 46/255, alpha: 1)
            self?.statusLabel.text = "CONNECTED"
        }

        eventSource.onComplete { [weak self] statusCode, reconnect, error in
            NSLog("=> onComplete");
            //self?.statusLabel.backgroundColor = UIColor(red: 249/255, green: 38/255, blue: 114/255, alpha: 1)
            self?.statusLabel.text = "DISCONNECTED"

            guard reconnect ?? false else { return }

            let retryTime = self?.eventSource.retryTime ?? 3000
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(retryTime)) { [weak self] in
                self?.eventSource.connect()
            }
        }

        eventSource.onMessage { [weak self] id, event, data in
            NSLog("=> MESSAGE");
            self?.updateLabels(id: id, event: event, data: data)
        }

        eventSource.addEventListener("user-connected") { [weak self] id, event, data in
            NSLog("=> USER-CONNECTED");
            self?.updateLabels(id: id, event: event, data: data)
        }
    }

    
    @IBAction func start() {
        messagesTextView.text = ""
        statusLabel.text = "... connecting ..."
        
        eventSource.connect()
    }
    
    @IBAction func stop() {
        statusLabel.text = "... disconnecting ..."
        
        eventSource.disconnect()
    }
    
    private func updateLabels(id: String?, event: String?, data: String?) {
        messagesTextView.text += "id: \(id ?? "?"), event: \(event ?? "-"), data: \(data ?? "-")\n"
    }
    
    private func resetUI() {
        statusLabel.text = "DISCONNECTED"
        messagesTextView.text = ""
    }

}

