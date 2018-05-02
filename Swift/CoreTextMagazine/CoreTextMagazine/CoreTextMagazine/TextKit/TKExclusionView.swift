//
//  TKExclusionView.swift
//  CoreTextMagazine
//
//  Created by lianzhandong on 2018/4/26.
//  Copyright © 2018年 lianzhandong. All rights reserved.
//

import UIKit

class TKExclusionView: UITextView {
    var panImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "pan"))
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    var gestureStartPoint = CGPoint.zero
    var gestureStartingCenter = CGPoint.zero
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setupImageView()
        text = theLittlePrince
        textContainer?.exclusionPaths = [UIBezierPath(rect: panImageView.frame)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupImageView()
        text = heart
        font = UIFont.preferredFont(forTextStyle: .body)
        textContainer.exclusionPaths = [UIBezierPath(rect: panImageView.frame)]
    }
    
    
    func setupImageView() {
        let width = frame.size.width * 0.5
        let height = (panImageView.frame.size.height / panImageView.frame.size.width) * width
        panImageView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        self.addSubview(panImageView)
        let pan = UIPanGestureRecognizer(target: self, action:#selector(respondsTo(_:)))
        panImageView.addGestureRecognizer(pan)
    }
    
    @objc func respondsTo(_ panGesture: UIPanGestureRecognizer) {
        if !panGesture.isKind(of: UIPanGestureRecognizer.self) {
            return
        }
        if panGesture.state == .began {
            gestureStartPoint = panGesture.translation(in: self)
            gestureStartingCenter = panImageView.center
        } else if panGesture.state == .changed {
            let currentPoint = panGesture.translation(in: self)
            let distanceX = currentPoint.x - gestureStartPoint.x
            let distanceY = currentPoint.y - gestureStartPoint.y
            
            let oldCenter = gestureStartingCenter
            let newCenter = CGPoint(x: oldCenter.x + distanceX, y: oldCenter.y + distanceY)
            panImageView.center = newCenter
            
            textContainer.exclusionPaths = [UIBezierPath(rect: panImageView.frame)]
        } else {
            gestureStartPoint = CGPoint.zero
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
let theLittlePrince = "小王子的形象中也有着淡淡的哀愁和忧郁。作者笔下流露出对社会一些丑恶现象尖刻的讽刺和批判，这是作者此间心情的宣泄。作者复员后，因法军溃败而对法国的政治家们完全失望，只身远渡美国，想从那里找到救国的希望，可政党间的斗争、社会现实的黑暗一样令他失望。刚到达美国的圣·埃克苏佩里认为贝当政府要求停战，是为了获得一个喘息机会，他不愿在美国谴责它，重要的是伺机反攻，他不论行动还是感情上都是抗战派。但是戴高乐派中一些头面人物在法国危机时抢先逃到美国，如今隔岸空喊抗战，特别对曾做出牺牲，而今在非洲忍辱负重、不知所从的法国军队频频攻击，使圣埃克苏佩里非常厌恶。此外戴高乐对待法国其他抗战力量的用心和做法也叫他十分怀疑。由于他是名人，维希派要拉拢他，达不到目的就造谣中伤他；戴高乐派见他迟迟不参加他们的阵营，就怀疑他。圣·埃克苏佩里主张“法国高于一切”，要两派摒弃前嫌，共同对敌，却受到双方的夹攻。在美国度过的28个月，是他一生中最痛苦的时期。1941年12月，美国向法西斯国家宣战，加入二战，这使圣埃克苏佩里又看到了希望。他认为有了美国的帮助，一定会打败法西斯的侵略，一定会解放法国。他激动的说：“这是结束的开始，美国不得不应战，我们要赢了。” [4]  小王子世界的美与丑，也寄托了作者对现实的美好向往，表明作者也看到了希望。最后从作品中小王子与狐狸、玫瑰、飞行员的关系来看，表现了一种美好的追求真挚友谊和博大情怀的理想，有着唯美的情感境界，在圣埃克苏佩里这复杂心情的体现下，才有了《小王子》一书这样的写作风格和主人公性格。小王子的形象中也有着淡淡的哀愁和忧郁。作者笔下流露出对社会一些丑恶现象尖刻的讽刺和批判，这是作者此间心情的宣泄。作者复员后，因法军溃败而对法国的政治家们完全失望，只身远渡美国，想从那里找到救国的希望，可政党间的斗争、社会现实的黑暗一样令他失望。刚到达美国的圣·埃克苏佩里认为贝当政府要求停战，是为了获得一个喘息机会，他不愿在美国谴责它，重要的是伺机反攻，他不论行动还是感情上都是抗战派。但是戴高乐派中一些头面人物在法国危机时抢先逃到美国，如今隔岸空喊抗战，特别对曾做出牺牲，而今在非洲忍辱负重、不知所从的法国军队频频攻击，使圣埃克苏佩里非常厌恶。此外戴高乐对待法国其他抗战力量的用心和做法也叫他十分怀疑。由于他是名人，维希派要拉拢他，达不到目的就造谣中伤他；戴高乐派见他迟迟不参加他们的阵营，就怀疑他。圣·埃克苏佩里主张“法国高于一切”，要两派摒弃前嫌，共同对敌，却受到双方的夹攻。在美国度过的28个月，是他一生中最痛苦的时期。1941年12月，美国向法西斯国家宣战，加入二战，这使圣埃克苏佩里又看到了希望。他认为有了美国的帮助，一定会打败法西斯的侵略，一定会解放法国。他激动的说：“这是结束的开始，美国不得不应战，我们要赢了。” [4]  小王子世界的美与丑，也寄托了作者对现实的美好向往，表明作者也看到了希望。最后从作品中小王子与狐狸、玫瑰、飞行员的关系来看，表现了一种美好的追求真挚友谊和博大情怀的理想，有着唯美的情感境界，在圣埃克苏佩里这复杂心情的体现下，才有了《小王子》一书这样的写作风格和主人公性格。"
let eng = "Note: at the time of writing there is a subtle bug with iOS 7 – when the text view is resized, the cursor position may still be off screen. The cursor moves to its correct location if the user taps the ‘return’ key. We’ll keep an eye on this, and if the bug persists we’ll try to find an alternative solution.Note: at the time of writing there is a subtle bug with iOS 7 – when the text view is resized, the cursor position may still be off screen. The cursor moves to its correct location if the user taps the ‘return’ key. We’ll keep an eye on this, and if the bug persists we’ll try to find an alternative solution.Note: at the time of writing there is a subtle bug with iOS 7 – when the text view is resized, the cursor position may still be off screen. The cursor moves to its correct location if the user taps the ‘return’ key. We’ll keep an eye on this, and if the bug persists we’ll try to find an alternative solution.Note: at the time of writing there is a subtle bug with iOS 7 – when the text view is resized, the cursor position may still be off screen. The cursor moves to its correct location if the user taps the ‘return’ key. We’ll keep an eye on this, and if the bug persists we’ll try to find an alternative solution.Note: at the time of writing there is a subtle bug with iOS 7 – when the text view is resized, the cursor position may still be off screen. The cursor moves to its correct location if the user taps the ‘return’ key. We’ll keep an eye on this, and if the bug persists we’ll try to find an alternative solution.Note: at the time of writing there is a subtle bug with iOS 7 – when the text view is resized, the cursor position may still be off screen. The cursor moves to its correct location if the user taps the ‘return’ key. We’ll keep an eye on this, and if the bug persists we’ll try to find an alternative solution."
let heart = "♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️♥️"
