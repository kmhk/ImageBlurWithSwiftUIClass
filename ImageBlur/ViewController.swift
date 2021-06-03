//
//  ViewController.swift
//  ImageBlur
//
//  Created by com on 6/3/21.
//

import UIKit
import AVKit
import SwiftUI


class ViewController: UIViewController {
    
    var imgView: UIImageView?
    var btnPlay: UIButton?
    
    var blurEffectView: UIVisualEffectView?
    
    
    let session = AVAudioSession.sharedInstance()
    var player: AVAudioPlayer?
    
    var timer: Timer?
    
    var context = CIContext(options: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupSession()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        btnPlay = UIButton(type: .system)
        btnPlay?.setTitle("Play", for: .normal)
        btnPlay?.setTitleColor(UIColor.systemBlue, for: .normal)
        btnPlay?.setTitleColor(UIColor.systemGray, for: .disabled)
        btnPlay?.frame = CGRect(x: 20, y: 60, width: 50, height: 40)
        btnPlay?.addTarget(self, action: #selector(btnPlayTapped(_:)), for: .touchUpInside)
        view.addSubview(btnPlay!)
        
        imgView = UIImageView(frame: CGRect(x: 0, y: 120, width: view.frame.width, height: 160))
        imgView?.contentMode = .scaleToFill
        imgView?.image = UIImage(named: "imgTree")!
        view.addSubview(imgView!)
        
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView?.frame = imgView!.frame
        blurEffectView?.alpha = 0.8
        view.addSubview(blurEffectView!)
        
        let c = BlurImageView(blurAmount: 10, image: UIImage(named: "imgTree")!)//BlurImageView(image: UIImage(named: "imgTree")!)
        let vc = UIHostingController(rootView: c)
        vc.view.frame = CGRect(x: 0, y: 300, width: view.frame.width, height: 300)
        view.addSubview(vc.view)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            guard let player = self.player else { return }
            
            let blurValue = CGFloat(0.8 - (0.8 * (player.currentTime / player.duration)))
            self.blurEffectView?.alpha = blurValue
            
            let val = CGFloat(10 - (10 * (player.currentTime / player.duration)))
            NotificationCenter.default.post(Notification(name: .blurAmountChanged, object: nil, userInfo: ["value": val]))
        })
    }
    
    
    @objc func btnPlayTapped(_ sender: Any) {
        setupAudio()
        player?.play()
        btnPlay?.isEnabled = false
        
        //blurEffect3()
    }

    
    private func setupAudio() {
        do {
            let url = Bundle.main.url(forResource: "demo", withExtension: "m4a")
            self.player = try AVAudioPlayer(contentsOf: url!)
            self.player?.prepareToPlay()
            self.player?.delegate = self
            
        } catch let error {
            print("*** Unable to set up the audio player: \(error.localizedDescription) ***")
            return
        }
    }
    

    private func setupSession() {
        do {
            try session.setCategory(AVAudioSession.Category.playback,
                                    mode: .default,
                                    policy: .longFormAudio,
                                    options: [])
            try session.setActive(true, options: [])
            
        } catch let error {
            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
        }
    }
    
}


extension ViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        btnPlay?.isEnabled = true
    }
    
}

