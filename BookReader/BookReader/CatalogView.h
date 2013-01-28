//
//  CatalogView.h
//  IpadLisShow
//
//  Created by Dwen on 13-1-21.
//  Copyright (c) 2013年 Dwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatalogView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lotLab;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

//详细图录
- (IBAction)goDetailCatalog:(id)sender;

@end
