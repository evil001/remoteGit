//
//  CatalogView.h
//  IpadLisShow
//  拍品View
//  Created by Dwen on 13-1-21.
//  Copyright (c) 2013年 Dwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatalogView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//lot号
@property (weak, nonatomic) IBOutlet UILabel *lotLab;
//名称
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
//成交价
@property (weak, nonatomic) IBOutlet UILabel *closeCostLab;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

//详细图录
- (IBAction)goDetailCatalog:(id)sender;

@end
