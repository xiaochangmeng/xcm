//
//  FateDetailBottomButtonView.h
//  Appointment
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FateDetailBottomButtonViewButtonHandle)(NSUInteger tag);
@interface FateDetailBottomButtonView : UIView

/**背景图 */
@property (strong, nonatomic) UIImageView* bottomImageView;

/**发信 */
@property (strong, nonatomic) UIButton* sendMessageButton;
/**打招呼 */
@property (strong, nonatomic) UIButton* helloButton;
/**下一个 */
@property (strong, nonatomic) UIButton* nextButton;

@property (strong, nonatomic) FateDetailBottomButtonViewButtonHandle buttonHandle;
@end
