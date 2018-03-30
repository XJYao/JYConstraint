//
//  JYConstraint.m
//  JYConstraint
//
//  Created by XJY on 2018/3/30.
//  Copyright © 2018年 JY. All rights reserved.
//

#import "JYConstraint.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, strong) id jy_firstItem;
@property (nonatomic, strong) NSMutableArray *jy_firstAttributes;
@property (nonatomic, assign) NSLayoutRelation jy_relation;
@property (nonatomic, strong) id jy_secondItem;
@property (nonatomic, strong) NSMutableArray *jy_secondAttributes;

@property (nonatomic, assign) CGFloat jy_multi;
@property (nonatomic, assign) CGFloat jy_cons;

@end


@implementation UIView (JYConstraint)

#pragma mark - Public

- (JYConstraintMaker *)jy_left {
    return [self jy_addAttribute:NSLayoutAttributeLeft];
}

- (JYConstraintMaker *)jy_right {
    return [self jy_addAttribute:NSLayoutAttributeRight];
}

- (JYConstraintMaker *)jy_top {
    return [self jy_addAttribute:NSLayoutAttributeTop];
}

- (JYConstraintMaker *)jy_bottom {
    return [self jy_addAttribute:NSLayoutAttributeBottom];
}

- (JYConstraintMaker *)jy_leading {
    return [self jy_addAttribute:NSLayoutAttributeLeading];
}

- (JYConstraintMaker *)jy_trailing {
    return [self jy_addAttribute:NSLayoutAttributeTrailing];
}

- (JYConstraintMaker *)jy_width {
    return [self jy_addAttribute:NSLayoutAttributeWidth];
}

- (JYConstraintMaker *)jy_height {
    return [self jy_addAttribute:NSLayoutAttributeHeight];
}

- (JYConstraintMaker *)jy_centerX {
    return [self jy_addAttribute:NSLayoutAttributeCenterX];
}

- (JYConstraintMaker *)jy_centerY {
    return [self jy_addAttribute:NSLayoutAttributeCenterY];
}

- (JYConstraintMaker *)jy_centerXY {
    [self jy_addAttribute:NSLayoutAttributeCenterX];
    return [self jy_addAttribute:NSLayoutAttributeCenterY];
}

- (JYConstraintMaker *)jy_edge {
    [self jy_addAttribute:NSLayoutAttributeLeading];
    [self jy_addAttribute:NSLayoutAttributeTrailing];
    [self jy_addAttribute:NSLayoutAttributeTop];
    return [self jy_addAttribute:NSLayoutAttributeBottom];
}

- (JYConstraintMaker *)jy_size {
    [self jy_addAttribute:NSLayoutAttributeWidth];
    return [self jy_addAttribute:NSLayoutAttributeHeight];
}

- (JYConstraintMaker * (^)(CGFloat))jy_multiplier {
    __weak typeof(self) weak_self = self;
    
    return ^id(CGFloat multi) {
        weak_self.jy_multi = multi;
        return weak_self;
    };
}

- (JYConstraintMaker * (^)(CGFloat))jy_constant {
    __weak typeof(self) weak_self = self;
    
    return ^id(CGFloat cons) {
        weak_self.jy_cons = cons;
        
        if (weak_self.jy_secondItem) {
            [weak_self jy_addConstraint];
        } else {
            [weak_self jy_clear];
        }
        
        return weak_self;
    };
}

- (JYConstraintMaker * (^)(id))jy_equalTo {
    __weak typeof(self) weak_self = self;
    
    return ^id(id reference) {
        weak_self.jy_relation = NSLayoutRelationEqual;
        [weak_self jy_relationTo:reference];
        return weak_self;
    };
}

- (JYConstraintMaker * (^)(id))jy_lessThanOrEqualTo {
    __weak typeof(self) weak_self = self;
    
    return ^id(id reference) {
        weak_self.jy_relation = NSLayoutRelationLessThanOrEqual;
        [weak_self jy_relationTo:reference];
        return weak_self;
    };
}

- (JYConstraintMaker * (^)(id))jy_greaterThanOrEqualTo {
    __weak typeof(self) weak_self = self;
    
    return ^id(id reference) {
        weak_self.jy_relation = NSLayoutRelationGreaterThanOrEqual;
        [weak_self jy_relationTo:reference];
        return weak_self;
    };
}

- (JYConstraintMaker * (^)(id))jy_update_equalTo {
    __weak typeof(self) weak_self = self;
    
    return ^id(id reference) {
        NSMutableArray *firstAttris = [weak_self.jy_firstAttributes mutableCopy];
        weak_self.jy_remove();
        weak_self.jy_firstAttributes = firstAttris;
        return weak_self.jy_equalTo(reference);
    };
}

- (JYConstraintMaker * (^)(id))jy_update_lessThanOrEqualTo {
    __weak typeof(self) weak_self = self;
    
    return ^id(id reference) {
        NSMutableArray *firstAttris = [weak_self.jy_firstAttributes mutableCopy];
        weak_self.jy_remove();
        weak_self.jy_firstAttributes = firstAttris;
        return weak_self.jy_lessThanOrEqualTo(reference);
    };
}

- (JYConstraintMaker * (^)(id))jy_update_greaterThanOrEqualTo {
    __weak typeof(self) weak_self = self;
    
    return ^id(id reference) {
        NSMutableArray *firstAttris = [weak_self.jy_firstAttributes mutableCopy];
        weak_self.jy_remove();
        weak_self.jy_firstAttributes = firstAttris;
        return weak_self.jy_greaterThanOrEqualTo(reference);
    };
}

- (JYConstraintMaker * (^)(void))jy_remove {
    __weak typeof(self) weak_self = self;
    
    return ^id(void) {
        weak_self.jy_firstItem = weak_self;
        
        for (NSLayoutConstraint *existConstraint in weak_self.superview.constraints) {
            if (existConstraint.firstItem == weak_self.jy_firstItem) {
                id existFirstAttributeObject = @(existConstraint.firstAttribute);
                if (existFirstAttributeObject) {
                    if ([weak_self.jy_firstAttributes containsObject:existFirstAttributeObject]) {
                        [weak_self jy_removeExistConstraint:existConstraint];
                    }
                }
            }
        }
        
        id widthObject = @(NSLayoutAttributeWidth);
        id heightObject = @(NSLayoutAttributeHeight);
        
        if ([weak_self.jy_firstAttributes containsObject:widthObject] ||
            [weak_self.jy_firstAttributes containsObject:heightObject]) {
            for (NSLayoutConstraint *existConstraint in weak_self.constraints) {
                if (existConstraint.firstItem == weak_self.jy_firstItem) {
                    id existFirstAttributeObject = @(existConstraint.firstAttribute);
                    if (existFirstAttributeObject) {
                        if ([weak_self.jy_firstAttributes containsObject:existFirstAttributeObject]) {
                            [weak_self jy_removeExistConstraint:existConstraint];
                        }
                    }
                }
            }
        }
        [weak_self jy_clear];
        return weak_self;
    };
}

#pragma mark - Private

#pragma mark property

static const void *JYConstraintFirstItemKey = &JYConstraintFirstItemKey;
static const void *JYConstraintFirstAttributesKey = &JYConstraintFirstAttributesKey;

static const void *JYConstraintRelationKey = &JYConstraintRelationKey;

static const void *JYConstraintSecondItemKey = &JYConstraintSecondItemKey;
static const void *JYConstraintSecondAttributesKey = &JYConstraintSecondAttributesKey;

static const void *JYConstraintMultiplierKey = &JYConstraintMultiplierKey;
static const void *JYConstraintConstantKey = &JYConstraintConstantKey;

- (void)setjy_firstItem:(id)jy_firstItem {
    objc_setAssociatedObject(self, JYConstraintFirstItemKey, jy_firstItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)jy_firstItem {
    return objc_getAssociatedObject(self, JYConstraintFirstItemKey);
}

- (void)setjy_firstAttributes:(NSMutableArray *)jy_firstAttributes {
    objc_setAssociatedObject(self, JYConstraintFirstAttributesKey, jy_firstAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)jy_firstAttributes {
    NSMutableArray *firstAttributes = objc_getAssociatedObject(self, JYConstraintFirstAttributesKey);
    if (!firstAttributes) {
        firstAttributes = [[NSMutableArray alloc] init];
        self.jy_firstAttributes = firstAttributes;
    }
    return firstAttributes;
}

- (void)setjy_relation:(NSLayoutRelation)jy_relation {
    objc_setAssociatedObject(self, JYConstraintRelationKey, [NSNumber numberWithInteger:jy_relation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutRelation)jy_relation {
    id relationObj = objc_getAssociatedObject(self, JYConstraintRelationKey);
    if (!relationObj) {
        self.jy_relation = NSLayoutRelationEqual;
    }
    return relationObj ? [relationObj integerValue] : NSLayoutRelationEqual;
}

- (void)setjy_secondItem:(id)jy_secondItem {
    objc_setAssociatedObject(self, JYConstraintSecondItemKey, jy_secondItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)jy_secondItem {
    return objc_getAssociatedObject(self, JYConstraintSecondItemKey);
}

- (void)setjy_secondAttributes:(NSMutableArray *)jy_secondAttributes {
    objc_setAssociatedObject(self, JYConstraintSecondAttributesKey, jy_secondAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)jy_secondAttributes {
    NSMutableArray *secondAttributes = objc_getAssociatedObject(self, JYConstraintSecondAttributesKey);
    if (!secondAttributes) {
        secondAttributes = [[NSMutableArray alloc] init];
        self.jy_secondAttributes = secondAttributes;
    }
    return secondAttributes;
}

- (void)setjy_multi:(CGFloat)jy_multi {
    objc_setAssociatedObject(self, JYConstraintMultiplierKey, [NSNumber numberWithFloat:jy_multi], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)jy_multi {
    id multiObj = objc_getAssociatedObject(self, JYConstraintMultiplierKey);
    if (!multiObj) {
        self.jy_multi = 0.0;
    }
    return multiObj ? [multiObj floatValue] : 0.0;
}

- (void)setjy_cons:(CGFloat)jy_cons {
    objc_setAssociatedObject(self, JYConstraintConstantKey, [NSNumber numberWithFloat:jy_cons], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)jy_cons {
    id consObj = objc_getAssociatedObject(self, JYConstraintConstantKey);
    if (!consObj) {
        self.jy_cons = 0.0;
    }
    return consObj ? [consObj floatValue] : 0.0;
}

#pragma mark Method

- (JYConstraintMaker *)jy_addAttribute:(NSLayoutAttribute)attribute {
    if (self.jy_secondItem) {
        [self.jy_secondAttributes addObject:@(attribute)];
    } else {
        [self.jy_firstAttributes addObject:@(attribute)];
    }
    return self;
}

- (void)jy_relationTo:(id)reference {
    if ([reference isKindOfClass:[UIView class]]) {
        self.jy_secondItem = reference;
        self.jy_multi = 1.0;
    } else {
        self.jy_secondItem = nil;
        self.jy_multi = 0.0;
        self.jy_cons = [reference floatValue];
    }
    
    if (!self.jy_secondItem) {
        [self jy_addConstraint];
    }
}

- (void)jy_addConstraint {
    if (self.jy_firstAttributes && self.jy_firstAttributes.count > 0) {
        if (self.translatesAutoresizingMaskIntoConstraints) {
            [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        
        self.jy_firstItem = self;
        
        BOOL isSecondNotAttribute = NO;
        if (!self.jy_secondItem) {
            isSecondNotAttribute = YES;
        }
        
        for (NSInteger i = 0; i < self.jy_firstAttributes.count; i++) {
            NSLayoutAttribute firstAttribute = [[self.jy_firstAttributes objectAtIndex:i] integerValue];
            NSLayoutAttribute secondAttribute = NSLayoutAttributeNotAnAttribute;
            
            if (!isSecondNotAttribute) {
                if (self.jy_secondAttributes && self.jy_secondAttributes.count > 0) {
                    if (i < self.jy_secondAttributes.count) {
                        secondAttribute = [[self.jy_secondAttributes objectAtIndex:i] integerValue];
                    }
                } else {
                    secondAttribute = firstAttribute;
                }
            }
            
            NSLayoutConstraint *constraint =
            [NSLayoutConstraint constraintWithItem:self.jy_firstItem attribute:firstAttribute
                                         relatedBy:self.jy_relation
                                            toItem:self.jy_secondItem
                                         attribute:secondAttribute
                                        multiplier:self.jy_multi
                                          constant:self.jy_cons];
            
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
                [constraint setActive:YES];
            } else {
                [self.superview addConstraint:constraint];
            }
        }
    }
    
    [self jy_clear];
}

- (void)jy_removeExistConstraint:(NSLayoutConstraint *)constraint {
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        [constraint setActive:NO];
    } else {
        [self.superview removeConstraint:constraint];
    }
}

- (void)jy_clear {
    self.jy_firstItem = nil;
    [self.jy_firstAttributes removeAllObjects];
    self.jy_relation = NSLayoutRelationEqual;
    self.jy_secondItem = nil;
    [self.jy_secondAttributes removeAllObjects];
    self.jy_multi = 0.0;
    self.jy_cons = 0.0;
}

@end
