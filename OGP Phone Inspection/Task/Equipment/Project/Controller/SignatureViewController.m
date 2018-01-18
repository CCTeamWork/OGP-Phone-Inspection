//
//  SignatureViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/8.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "SignatureViewController.h"
#import "SignNavView.h"
@interface SignatureViewController ()
@property(nonatomic,assign)CGPoint lastPoint;
@property(nonatomic,assign)BOOL isSwiping;
@property(nonatomic,assign)CGFloat red;
@property(nonatomic,assign)CGFloat green;
@property(nonatomic,assign)CGFloat blue;
@property(nonatomic,strong)NSMutableArray * xPoints;
@property(nonatomic,strong)NSMutableArray * yPoints;

@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic, strong) UIBezierPath *bezier;
//存储Undo出来的线条
@property(nonatomic, strong) NSMutableArray *cancleArray;
@property(nonatomic,strong) SignNavView * signview;
@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signview = [[SignNavView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:self.signview];
    [self.signview.leftBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.signview.rightBtn addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor =[[UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1] CGColor];
    [self.view addSubview:self.imageView];
    
    self.view.backgroundColor=[UIColor whiteColor];

}
-(void)buttonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)saveButtonClick
{
    NSData *data=UIImageJPEGRepresentation(self.imageView.image, 1.0);
    NSDictionary * dict = @{@"signimage":data,@"content_path":[ToolModel saveImage:data],@"data_record_show":[NSString stringWithFormat:@"%ld",[data length]],@"file_name":[NSString stringWithFormat:@"%@.jpg",[ToolModel uuid]]};
    [self showSignImage:dict];
    [self buttonClick];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isSwiping    = false;
    UITouch * touch = touches.anyObject;
    self.lastPoint = [touch locationInView:self.imageView];
    [self.xPoints addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.yPoints addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isSwiping = true;
    UITouch * touch = touches.anyObject;
    CGPoint currentPoint = [touch locationInView:self.imageView];
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    [self.imageView.image drawInRect:(CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height))];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(),kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),0.0, 0.0, 0.0, 1.0);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.lastPoint = currentPoint;
    [self.xPoints addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.yPoints addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.isSwiping) {
        // This is a single touch, draw a point
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        [self.imageView.image drawInRect:(CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height))];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
}
#pragma mark getter && setter
-(NSMutableArray*)xPoints
{
    if (!_xPoints) {
        _xPoints=[[NSMutableArray alloc]initWithCapacity:0];
    }
    return _xPoints;
}
-(NSMutableArray*)yPoints
{
    if (!_yPoints) {
        _yPoints=[[NSMutableArray alloc]initWithCapacity:0];
    }
    return _yPoints;
}
#pragma mark delegate
- (void)showSignImage:(NSDictionary *)dict
{
    //检测代理有没有实现代理方法
    if([self.delegate respondsToSelector:@selector(showSignImage:)]){
        [self.delegate showSignImage:dict];
    }else{
        NSLog(@"代理没有实现changeStatus:方法");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
