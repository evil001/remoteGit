//
//  CoverFlowView.h
//  BookReader
//  视频滑动效果视图
//  图片大小：w:178.75 , h:128.75  225,225
//  Created by Dwen on 13-3-6.
//
//

#import <UIKit/UIKit.h>

@interface CoverFlowView : UIView

//setup numbers of images
@property (assign,nonatomic) int sideVisibleImageCount;

//setup the scale of left/right side and middle one
@property (assign,nonatomic) CGFloat sideVisibleImageScale;
@property (assign,nonatomic) CGFloat middleImageScale;

//图片数组
@property (strong,nonatomic) NSMutableArray *images;

//图片层数组
@property (strong,nonatomic) NSMutableArray *imageLayers;

//图片模版层数组
@property (strong,nonatomic) NSMutableArray *templateLayers;

//当前渲染图片index
@property (assign,nonatomic) int currentRenderingImageIndex;

//视频标题
@property (strong,nonatomic) UILabel *videoTitle;

//setup templates
-(void)setupTemplateLayers;
//setup images
-(void)setupImages;
//remove sublayers (after a certain delay)
-(void)removeLayersAfterSeconds:(id)layerToBeRemoved;
//remove all sublayers
-(void)removeSublayers;
//empty imagelayers
-(void)cleanImageLayers;
//add reflections
-(void)showImageAndReflection:(CALayer *)layer;
//adjust the bounds
-(void)scaleBounds: (CALayer *) layer x:(CGFloat)scaleWidth y:(CGFloat)scaleHeight;

//滑动效果方法
+ (id)coverFlowViewWithFrame:(CGRect)frame
                   andImages: (NSMutableArray *)rawImages
              sideImageCount:(int) sideCount
              sideImageScale: (CGFloat) sideImageScale
            middleImageScale: (CGFloat) middleImageScale;

@end
