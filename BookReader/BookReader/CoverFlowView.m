//
//  CoverFlowView.m
//  BookReader
//
//  Created by Dwen on 13-3-6.
//
//

#import "CoverFlowView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

//滑动距离
#define DISTNACE_TO_MAKE_MOVE_FOR_SWIPE 60
//默认当前渲染index
#define CURRENT_RENDERING_INDEX 6
//左右两边图片距离宽度
#define GAP_AMONG_SIDE_IMAGES 80.0f
//设中间图片两边图片距离
#define GAP_BETWEEN_MIDDLE_SIDE 180.0f

@implementation CoverFlowView
@synthesize images;
@synthesize imageLayers;
@synthesize templateLayers;
@synthesize currentRenderingImageIndex;
@synthesize sideVisibleImageCount;
@synthesize sideVisibleImageScale;
@synthesize middleImageScale;
@synthesize videoTitle;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //set up perspective
        CATransform3D transformPerspective = CATransform3DIdentity;
        transformPerspective.m34 = -1.0 / 500.0;
        self.layer.sublayerTransform = transformPerspective;
        //视频标题
        videoTitle = [[UILabel alloc] initWithFrame:CGRectMake(360, 320, 230, 50)];
        videoTitle.textAlignment = UITextAlignmentCenter;
        videoTitle.textColor = [UIColor whiteColor];
        videoTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:videoTitle];
    }
    return self;
}

//调整倒影界限
- (void)adjustReflectionBounds:(CALayer *)layer scale:(CGFloat)scale {
    // set originLayer's reflection bounds
    CALayer *reflectLayer = (CALayer*)[layer.sublayers objectAtIndex:0];
    [self scaleBounds:reflectLayer x:scale y:scale];
    // set originLayer's reflection bounds
    [self scaleBounds:reflectLayer.mask x:scale y:scale];
    // set originLayer's reflection bounds
    [self scaleBounds:(CALayer*)[reflectLayer.sublayers objectAtIndex:0] x:scale y:scale];
    // set originLayer's reflection position
    reflectLayer.position = CGPointMake(layer.bounds.size.width/2, layer.bounds.size.height*1.5);
    // set originLayer's mask position
    reflectLayer.mask.position = CGPointMake(reflectLayer.bounds.size.width/2, reflectLayer.bounds.size.height/2);
    // set originLayer's reflection position
    ((CALayer*)[reflectLayer.sublayers objectAtIndex:0]).position = CGPointMake(reflectLayer.bounds.size.width/2, reflectLayer.bounds.size.height/2);
}

//手指滑动图片
- (void)moveOneStep:(BOOL)isSwipingToLeftDirection {
    //当滑动到最左边或最右边一张时，不可再滑动
    if ((self.currentRenderingImageIndex == 0 && !isSwipingToLeftDirection) || (self.currentRenderingImageIndex == self.images.count -1 && isSwipingToLeftDirection)){
        return;
    }
    
    int offset = isSwipingToLeftDirection ?  -1 : 1;
    int indexOffsetFromImageLayersToTemplates = (self.currentRenderingImageIndex - self.sideVisibleImageCount < 0) ? (self.sideVisibleImageCount + 1 + offset - self.currentRenderingImageIndex) : 1 + offset;
    for (int i = 0; i < self.imageLayers.count; i++) {
        CALayer *originLayer = [self.imageLayers objectAtIndex:i];
        CALayer *targetTemplate = [self.templateLayers objectAtIndex: i + indexOffsetFromImageLayersToTemplates];
        [CATransaction setAnimationDuration:1];
        originLayer.position = targetTemplate.position;
        originLayer.zPosition = targetTemplate.zPosition;
        originLayer.transform = targetTemplate.transform;
        //set originlayer's bounds
        CGFloat scale = 1.0f;
        if (i + indexOffsetFromImageLayersToTemplates - 1 == self.sideVisibleImageCount) {
            scale = self.middleImageScale  / self.sideVisibleImageScale;
        } else if (((i + indexOffsetFromImageLayersToTemplates - 1 == self.sideVisibleImageCount - 1) && isSwipingToLeftDirection) ||
                   ((i + indexOffsetFromImageLayersToTemplates - 1 == self.sideVisibleImageCount + 1) && !isSwipingToLeftDirection)) {
            scale = self.sideVisibleImageScale / self.middleImageScale;
        }
        
        originLayer.bounds = CGRectMake(0, 0, originLayer.bounds.size.width * scale, originLayer.bounds.size.height * scale);
        [self adjustReflectionBounds:originLayer scale:scale];
    }
    
    if (isSwipingToLeftDirection){//左边滑动图片大小、位置等加载
        //when current rendering index  >= sidecout
        if(self.currentRenderingImageIndex >= self.sideVisibleImageCount){
            CALayer *removeLayer = [self.imageLayers objectAtIndex:0];
            [self.imageLayers removeObject:removeLayer];
            [removeLayer removeFromSuperlayer];
        }
        int num = self.images.count - self.sideVisibleImageCount - 1;
        if (self.currentRenderingImageIndex < num){
            UIImage *candidateImage = [self.images objectAtIndex:self.currentRenderingImageIndex  + self.sideVisibleImageCount + 1];
            CALayer *candidateLayer = [CALayer layer];
            candidateLayer.contents = (__bridge id)candidateImage.CGImage;
            //添加阴影
            candidateLayer.shadowColor = [UIColor blackColor].CGColor;
            candidateLayer.shadowOffset = CGSizeMake(2, 2);//阴影偏移
            candidateLayer.shadowOpacity = 0.5;//阴影不透明度
            candidateLayer.shadowRadius = 6.0;//阴影半径
            
            CGFloat scale = self.sideVisibleImageScale;
            candidateLayer.bounds = CGRectMake(0, 0, candidateImage.size.width * scale+100, candidateImage.size.height * scale+50);
            [self.imageLayers addObject:candidateLayer];
            
            CALayer *template = [self.templateLayers objectAtIndex:self.templateLayers.count - 2];
            candidateLayer.position = template.position;
            candidateLayer.zPosition = template.zPosition;
            candidateLayer.transform = template.transform;
            //show the layer
            [self showImageAndReflection:candidateLayer];
        }
    }else{//if the right, then move the rightest layer and insert one to left (if left is full)
        //右边滑动图片大小、位置等加载
        //when to remove rightest, only when image in the rightest is indeed sitting in the template  imagelayer's rightes
        if (self.currentRenderingImageIndex + self.sideVisibleImageCount <= self.images.count -1) {
            CALayer *removeLayer = [self.imageLayers lastObject];
            [self.imageLayers removeObject:removeLayer];
            [removeLayer removeFromSuperlayer];
        }
        
        //check out whether we need to add layer to left, only when (currentIndex - sideCount > 0)
        if (self.currentRenderingImageIndex > self.sideVisibleImageCount){
            UIImage *candidateImage = [self.images objectAtIndex:self.currentRenderingImageIndex - 1 - self.sideVisibleImageCount];
            CALayer *candidateLayer = [CALayer layer];
            candidateLayer.contents = (__bridge id)candidateImage.CGImage;
            
            //添加阴影
            candidateLayer.shadowColor = [UIColor blackColor].CGColor;
            candidateLayer.shadowOffset = CGSizeMake(2, 2);//阴影偏移
            candidateLayer.shadowOpacity = 0.5;//阴影不透明度
            candidateLayer.shadowRadius = 6.0;//阴影半径
            
            CGFloat scale = self.sideVisibleImageScale;
            candidateLayer.bounds = CGRectMake(0, 0, candidateImage.size.width * scale+100, candidateImage.size.height * scale+50);
            [self.imageLayers insertObject:candidateLayer atIndex:0];
            
            CALayer *template = [self.templateLayers objectAtIndex:1];
            candidateLayer.position = template.position;
            candidateLayer.zPosition = template.zPosition;
            candidateLayer.transform = template.transform;
            //显示图片倒影
            [self showImageAndReflection:candidateLayer];
        }
    }
    //update index if you move to right, index--
    self.currentRenderingImageIndex = isSwipingToLeftDirection ? self.currentRenderingImageIndex + 1 : self.currentRenderingImageIndex - 1;
    //修改视频标题
    videoTitle.text = [NSString stringWithFormat:@"视频标题-%i",self.currentRenderingImageIndex];
    //视频标题置顶层
    [self bringSubviewToFront:videoTitle];
}


- (void)scaleBounds:(CALayer*)layer x:(CGFloat)scaleWidth y:(CGFloat)scaleHeight
{
    layer.bounds = CGRectMake(0, 0, layer.bounds.size.width*scaleWidth, layer.bounds.size.height*scaleHeight);
}

//滑动手势方法
- (void)handleGesture:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged){
        //get offset
        CGPoint offset = [recognizer translationInView:recognizer.view];
        if (abs(offset.x) > DISTNACE_TO_MAKE_MOVE_FOR_SWIPE) {
            BOOL isSwipingToLeftDirection = (offset.x > 0) ? NO :YES;
            //执行滑动
            [self moveOneStep:isSwipingToLeftDirection];
            [recognizer setTranslation:CGPointZero inView:recognizer.view];
        }
    }
}

+ (id)coverFlowViewWithFrame:(CGRect)frame andImages:(NSMutableArray *)rawImages sideImageCount:(int)sideCount sideImageScale:(CGFloat)sideImageScale middleImageScale:(CGFloat)middleImageScale {
    CoverFlowView *flowView = [[CoverFlowView alloc] initWithFrame:frame];
    flowView.sideVisibleImageCount = sideCount;//中间图旁边数量
    flowView.sideVisibleImageScale = sideImageScale;
    flowView.middleImageScale = middleImageScale;
    //默认当前图片数组中索引下标的图片
    flowView.currentRenderingImageIndex = CURRENT_RENDERING_INDEX;
    //图片数组
    flowView.images = [NSMutableArray arrayWithArray:rawImages];
    //图片层数组
    flowView.imageLayers = [[NSMutableArray alloc] initWithCapacity:flowView.sideVisibleImageCount* 2 + 1];
    //图片模版层数组
    flowView.templateLayers = [[NSMutableArray alloc] initWithCapacity:(flowView.sideVisibleImageCount + 1)* 2 + 1];
    
    //添加手指滑动手势
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:flowView action:@selector(handleGesture:)];
    [flowView addGestureRecognizer:gestureRecognizer];
    
    //模板层布局
    [flowView setupTemplateLayers];
    //设置图片
    [flowView setupImages];
    return flowView;
}

//模板层布局
-(void)setupTemplateLayers {
    //设置视频标题
    videoTitle.text = [NSString stringWithFormat:@"视频标题-%i",self.currentRenderingImageIndex];
    
    CGFloat centerX = self.bounds.size.width/2;
    CGFloat centerY = self.bounds.size.height/2;
    
    //the angle to rotate
    CGFloat leftRadian = M_PI/3;
    CGFloat rightRadian = -M_PI/3;
    
    //左右两边图片距离宽度
    CGFloat gapAmongSideImages = GAP_AMONG_SIDE_IMAGES;
    //设中间图片两边图片距离
    CGFloat gapBetweenMiddleAndSide = GAP_BETWEEN_MIDDLE_SIDE;
    
    //setup the layer templates
    //遍历添加左边图片层
    for(int i = 0; i <= self.sideVisibleImageCount; i++){
        CALayer *layer = [CALayer layer];
        layer.position = CGPointMake(centerX - gapBetweenMiddleAndSide - gapAmongSideImages * (self.sideVisibleImageCount - i), centerY);
        layer.zPosition = (i - self.sideVisibleImageCount - 1) * 10;
        layer.transform = CATransform3DMakeRotation(leftRadian, 0, 1, 0);
        [self.templateLayers addObject:layer];
    }
    
    //添加中间图片层
    CALayer *layer = [CALayer layer];
    layer.position = CGPointMake(centerX, centerY);
    [self.templateLayers addObject:layer];
    
    //添加右边图片层
    for(int i = 0; i <= self.sideVisibleImageCount; i++){
        CALayer *layer = [CALayer layer];
        layer.position = CGPointMake(centerX + gapBetweenMiddleAndSide + gapAmongSideImages * i, centerY);
        layer.zPosition = (i + 1) * -10;
        layer.transform = CATransform3DMakeRotation(rightRadian, 0, 1, 0);
        [self.templateLayers addObject:layer];
    }
}

//设置图片
- (void)setupImages {
    //建立显示区域，得到开始index和结束index
    int startingImageIndex = (self.currentRenderingImageIndex - self.sideVisibleImageCount <= 0) ? 0 : self.currentRenderingImageIndex - self.sideVisibleImageCount;
    int endImageIndex = (self.currentRenderingImageIndex + self.sideVisibleImageCount < self.images.count )  ? (self.currentRenderingImageIndex + self.sideVisibleImageCount) : (self.images.count -1 );
    
    //设立准备渲染的图片 set up images that ready for rendering
    for (int i = startingImageIndex; i <= endImageIndex; i++) {
        UIImage *image = [self.images objectAtIndex:i];
        CALayer *imageLayer = [CALayer layer];
        imageLayer.contents = (__bridge id)image.CGImage;
        //添加阴影
        imageLayer.shadowColor = [UIColor blackColor].CGColor;
        imageLayer.shadowOffset = CGSizeMake(2, 2);//阴影偏移
        imageLayer.shadowOpacity = 0.5;//阴影不透明度
        imageLayer.shadowRadius = 6.0;//阴影半径
        //默认中间当前图片
        if (i == self.currentRenderingImageIndex) {
            CGFloat scale = self.middleImageScale;
            //修改图片大小
            imageLayer.bounds = CGRectMake(0, 0, image.size.width * scale+180, image.size.height*scale+80);
        }else{
            CGFloat scale = self.sideVisibleImageScale;
            //修改图片大小
            imageLayer.bounds = CGRectMake(0, 0, image.size.width * scale+100, image.size.height*scale+50);
        }
        [self.imageLayers addObject:imageLayer];
    }
    
    //step3 : according to templates, set its geometry info to corresponding image layer
    //1 means the extra layer in templates layer
    //对设定好的图层进行倒影效果渲染
    int indexOffsetFromImageLayersToTemplates = (self.currentRenderingImageIndex - self.sideVisibleImageCount < 0) ? (self.sideVisibleImageCount + 1 - self.currentRenderingImageIndex) : 1;
    for (int i = 0; i < self.imageLayers.count; i++) {
        CALayer *correspondingTemplateLayer = [self.templateLayers objectAtIndex:(i + indexOffsetFromImageLayersToTemplates)];
        CALayer *imageLayer = [self.imageLayers objectAtIndex:i];
        imageLayer.position = correspondingTemplateLayer.position;
        imageLayer.zPosition = correspondingTemplateLayer.zPosition;
        imageLayer.transform = correspondingTemplateLayer.transform;
        //show its reflections
        [self showImageAndReflection:imageLayer];
    }
}

//添加图片层倒影效果
- (void)showImageAndReflection:(CALayer*)layer
{
    //倒影图层
    CALayer *reflectLayer = [CALayer layer];
    reflectLayer.contents = layer.contents;
    reflectLayer.bounds = layer.bounds;
    reflectLayer.position = CGPointMake(layer.bounds.size.width/2, layer.bounds.size.height*1.5);
    reflectLayer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    
    //半透明度效果，真图与倒影分隔效果
    CALayer *blackLayer = [CALayer layer];
    blackLayer.backgroundColor = [UIColor blackColor].CGColor;
    blackLayer.bounds = reflectLayer.bounds;
    blackLayer.position = CGPointMake(blackLayer.bounds.size.width/2, blackLayer.bounds.size.height/2);
    blackLayer.opacity = 0.6;
    [reflectLayer addSublayer:blackLayer];
    
    //添加倒影渐变效果 mask
    CAGradientLayer *mask = [CAGradientLayer layer];
    mask.bounds = reflectLayer.bounds;
    mask.position = CGPointMake(mask.bounds.size.width/2, mask.bounds.size.height/2);
    mask.colors = [NSArray arrayWithObjects:
                   (__bridge id)[UIColor clearColor].CGColor,
                   (__bridge id)[UIColor whiteColor].CGColor, nil];
    mask.startPoint = CGPointMake(0.5, 0.35);
    mask.endPoint = CGPointMake(0.5, 1.0);
    reflectLayer.mask = mask;
    [layer addSublayer:reflectLayer];
    [self.layer addSublayer:layer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
