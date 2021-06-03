//
//  BlurImageView.swift
//  ImageBlur
//
//  Created by com on 6/3/21.
//

import SwiftUI


extension Notification.Name {
    static var blurAmountChanged: Notification.Name { return .init("blurAmountChanged") }
}


struct BlurImageView: View {
    @State var blurAmount: CGFloat = 0
    var notificationBlurChanged = NotificationCenter.default.publisher(for: .blurAmountChanged)
    
    @State var image: UIImage
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .scaledToFill()
                .blur(radius: blurAmount)
                .onReceive(notificationBlurChanged, perform: { info in
                    self.blurAmount = info.userInfo!["value"]! as! CGFloat
                })
            
            //Slider(value: $blurAmount, in: 0...10)
        }
    }
}
