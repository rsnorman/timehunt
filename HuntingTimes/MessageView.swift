//
//  MessageView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/27/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

protocol MessageViewDelegate {
    func willShowMessage()
    func didHideMessage()
}

class MessageView : UILabel {
    var messages : [String]
    var delegate : MessageViewDelegate!
    
    override init(frame: CGRect) {
        messages = []
        super.init(frame: frame)
        numberOfLines = 2
        textColor = .white
        font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        textAlignment = .center
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addMessage(_ message: String) {
        messages.append(message)
        
        if messages.count == 1 {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                if let del = self.delegate {
                    del.willShowMessage()
                }
                }, completion: { (complete) -> Void in
                    
                    self.showMessages(self.messages[0], completion: { () -> () in
                        UIView.animate(withDuration: 0.2, animations: { () -> Void in
                            if let del = self.delegate {
                                del.didHideMessage()
                            }
                        })
                    })
            }) 
        }
    }
    
    func showMessages(_ message: String, completion: @escaping () -> ()) {
        text = message
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.alpha = 1.0
            }, completion: { (complete) -> Void in
                UIView.animate(withDuration: 0.2, delay: 1.0, animations: { () -> Void in
                    self.alpha = 0.0
                    }, completion: { (complete) -> Void in
                        self.messages.remove(at: 0)
                        if !self.messages.isEmpty {
                            self.showMessages(self.messages[0], completion: completion)
                        } else {
                            completion()
                        }
                })
        })
    }
}
