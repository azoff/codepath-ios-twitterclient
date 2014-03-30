//
//  AZNibView.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZNibView.h"

@implementation AZNibView

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    return [self injectNib];
}

- (id)injectNib
{
    id class   = NSStringFromClass([self class]);
    id bundle  = [NSBundle mainBundle];
    id objects = [bundle loadNibNamed:class owner:self options:nil];
    self.nib   = [objects lastObject];
    self.nib.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.nib];
    [self awakeFromNib];
    return self;
}

@end
