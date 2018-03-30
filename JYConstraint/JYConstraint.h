//
//  JYConstraint.h
//  JYConstraint
//
//  Created by XJY on 2018/3/30.
//  Copyright © 2018年 JY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYExpObject.h"

@interface UIView (JYConstraint)

#define JYConstraintMaker UIView

/**
 Note:
 'constant' is must be called if the constraint has relative view.
 */

/**
 Example:
 
 *1. view2 is view1's father or brother.
 
 view1.jy_left.jy_equalTo(view2).jy_left.jy_multiplier(1.0).jy_constant(0.0);    //view1's left equal to view2's left
 view1.jy_left.jy_equalTo(view2).jy_multiplier(1.0).jy_constant(10.0);          //view1's left equal to view2's left offset 10
 view1.jy_left.jy_equalTo(view2).jy_constant(20.0);                            //view1's left equal to view2's left offset 20
 
 view1.jy_left.jy_right.jy_top.jy_bottom.jy_equalTo(view2).jy_constant(0.0);      //view1's left & right & top & bottom equal to view2
 
 view1.jy_width.jy_equalTo(view2).jy_width.jy_multiplier(0.5).jy_constant(0.0);  //view1's width equal to half of the view2's width
 view1.jy_width.jy_equalTo(100);                                              //view1's width equal to 100
 
 view1.jy_edge.jy_equalTo(view2).jy_edge.jy_multiplier(1.0).jy_constant(0.0);    //view1's left & right & top & bottom equal to view2
 view1.jy_size.jy_equalTo(view2).jy_size.jy_multiplier(1.0).jy_constant(0.0);    //view1's size equal to view2
 
 *2. Use for UIScrollView, you should add a contentView to scrollView.
 
 scrollView.jy_edge.jy_equalTo(superView).jy_edge.jy_multiplier(1.0).jy_constant(0);
 
 contentView.jy_edge.jy_equalTo(scrollView).jy_edge.jy_multiplier(1.0).jy_constant(0);
 contentView.jy_width.jy_equalTo(scrollView).jy_width.jy_multiplier(1.0).jy_constant(0);
 .
 .
 .
 contentView.jy_bottom.jy_equalTo(lastSubView).jy_bottom.jy_multiplier(1.0).jy_constant(0);
 */

@property (nonatomic, strong, readonly) JYConstraintMaker *jy_left;
@property (nonatomic, strong, readonly) JYConstraintMaker *jy_right;
@property (nonatomic, strong, readonly) JYConstraintMaker *jy_top;
@property (nonatomic, strong, readonly) JYConstraintMaker *jy_bottom;
@property (nonatomic, strong, readonly) JYConstraintMaker *jy_leading;
@property (nonatomic, strong, readonly) JYConstraintMaker *jy_trailing;
@property (nonatomic, strong, readonly) JYConstraintMaker *jy_width;
@property (nonatomic, strong, readonly) JYConstraintMaker *jy_height;
@property (nonatomic, strong, readonly) JYConstraintMaker *jy_centerX;
@property (nonatomic, strong, readonly) JYConstraintMaker *jy_centerY;
@property (nonatomic, strong, readonly) JYConstraintMaker *jy_centerXY;
@property (nonatomic, strong, readonly) JYConstraintMaker *jy_edge;
@property (nonatomic, strong, readonly) JYConstraintMaker *jy_size;

- (JYConstraintMaker * (^)(CGFloat multiplier))jy_multiplier; //default is 1.0
- (JYConstraintMaker * (^)(CGFloat constant))jy_constant;     //default is 0.0

//call when you first add layout constraint.
- (JYConstraintMaker * (^)(id reference))jy_equalTo;
- (JYConstraintMaker * (^)(id reference))jy_lessThanOrEqualTo;
- (JYConstraintMaker * (^)(id reference))jy_greaterThanOrEqualTo;

#define jy_equalTo(...) jy_equalTo(expObject((__VA_ARGS__)))
#define jy_lessThanOrEqualTo(...) jy_lessThanOrEqualTo(expObject((__VA_ARGS__)))
#define jy_greaterThanOrEqualTo(...) jy_greaterThanOrEqualTo(expObject((__VA_ARGS__)))

//call when you need update constraint.
- (JYConstraintMaker * (^)(id reference))jy_update_equalTo;
- (JYConstraintMaker * (^)(id reference))jy_update_lessThanOrEqualTo;
- (JYConstraintMaker * (^)(id reference))jy_update_greaterThanOrEqualTo;

#define jy_update_equalTo(...) jy_update_equalTo(expObject((__VA_ARGS__)))
#define jy_update_lessThanOrEqualTo(...) jy_update_lessThanOrEqualTo(expObject((__VA_ARGS__)))
#define jy_update_greaterThanOrEqualTo(...) jy_update_greaterThanOrEqualTo(expObject((__VA_ARGS__)))

/**
 remove constraints
 
 Example:
 view1.jy_left.jy_remove();
 view1.jy_left.right.jy_remove();
 */
- (JYConstraintMaker * (^)(void))jy_remove;

@end
