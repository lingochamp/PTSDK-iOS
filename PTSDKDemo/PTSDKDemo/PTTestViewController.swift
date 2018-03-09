//
//  PTTestViewController.swift
//  PTSDKDemo
//
//  Created by Chun on 27/02/2018.
//  Copyright © 2018 LLS iOS Team. All rights reserved.
//

import UIKit
import PTSDK
import AVFoundation

// MARK: - PTTestViewController

class PTTestViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.white
    
    AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
      print("record permission: \(granted)");
    }
    
    loadMenu()
  }
  
  private func loadMenu() {
    let ptTestButton = UIButton()
    ptTestButton.translatesAutoresizingMaskIntoConstraints = false
    ptTestButton.setTitle("开始测试 PT", for: .normal)
    ptTestButton.setTitleColor(UIColor.black, for: .normal)
    ptTestButton.addTarget(self, action: #selector(handlePTTestButtonTapped), for: .touchUpInside)
    view.addSubview(ptTestButton)
    
    NSLayoutConstraint.activate([ptTestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), ptTestButton.centerYAnchor.constraint(equalTo: view.centerYAnchor), ptTestButton.widthAnchor.constraint(equalToConstant: 120), ptTestButton.heightAnchor.constraint(equalToConstant: 44)])
  }
  
  @objc private func handlePTTestButtonTapped() {
    if AVAudioSession.sharedInstance().recordPermission() == .granted {
      let tokenProvider = PTTokenProvider()
      PT.start(withUserIdentifier: "userID", tokenProvider: tokenProvider, from: self.navigationController!, completionHandler: { (responseObject, error) in
        print("responseObject: \(String(describing: responseObject)), error: \(String(describing: error))")
      })
    } else {
      assertionFailure("使用 PTSDK 需要用户的录音权限。")
    }
  }
}

// MARK: - PTTokenProvider

class PTTokenProvider: NSObject, PTTokenProviding {
  
  func fetchToken(completionHandler: @escaping (String?, Error?) -> Void) {
    if let cachedToken = cachedToken {
      completionHandler(cachedToken, nil)
    } else {
      // PTSDK 内部没有设置异步 fetch 数据时界面 Loading 的提示
      // 为了更好的用户体验，可以在这个异步 fetch 的前后根据需要，加上自定义的 Loading HUD 提示。
      
      // HUD.start()
      fetchTokenFromServer(complete: { [weak self] (token, error) in
        // HUD.finish()
        if let error = error {
          completionHandler(nil, error)
        } else {
          guard let `self` = self else { return }
          self.cachedToken = token;
          completionHandler(token, nil)
        }
      })
    }
  }
  
  func invalidToken(_ token: String) {
    if cachedToken == token {
      cachedToken = nil
    }
  }
  
  // 这里根据需要应该使用更加安全的方式存储 Token
  var cachedToken: String? {
    get {
      return UserDefaults.standard.string(forKey: "PTSDK_TOKEN")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "PTSDK_TOKEN")
      UserDefaults.standard.synchronize()
    }
  }
  
  // 这个需要实现从自己的 Server 端获取到对应的 PTSDK Token 信息。
  // 为了更好的用户体验：在使用 PTSDK 之前，应该在某个时间点就拉取到用于 PTSDK 的 Token 信息。
  // 从 Server 返回的 Token 信息可以带上当前 Token 的有效期，以便客户端可以根据这个有效期，调整主动 Token 的逻辑。
  func fetchTokenFromServer(complete: (String?, Error?) -> Void) {
    //TODO: 开发者如果需要运行当前的 Demo，需要自行实现这一部分获取 Token 的功能。
    complete(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "开发者如果需要运行当前的 Demo，需要自行实现这一部分获取 Token 的功能"]))
  }
}
