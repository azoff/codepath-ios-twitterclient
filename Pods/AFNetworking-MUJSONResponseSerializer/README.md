AFNetworking-MUJSONResponseSerializer
=====================================

Automatically serialize JSON response to your object model. 

# Usage

### AFNetworking

```Objective-c
AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://graph.facebook.com/"]];
[operationManager setResponseSerializer:[[MUJSONResponseSerializer alloc] init]];
[(MUJSONResponseSerializer *)[operationManager responseSerializer] setResponseObjectClass:[FBUser class]];

[operationManager GET:@"me" 
		   parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) 
{                                                
 	// response object is your FBUser object with all properties filled   
} 			  failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
```

### Custom Model Class


```Objective-c
#import "MUJSONResponseSerializer.h"
#import "FBWork.h"

@interface FBUser : MUJSONResponseObject

@property (nonatomic, strong) NSString *ident;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSURL *link;

// array of FBWork objects
@property (nonatomic, strong) NSArray *work;

@property (nonatomic, strong) NSString *gender;
@property (nonatomic) NSInteger timezone;
@property (nonatomic, strong) NSString *locale;
@property (nonatomic, getter=isVerified) BOOL verified;
@property (nonatomic, strong) NSDate *updatedTime;
@property (nonatomic, strong) NSString *username;

@end
```

```Objective-c
#import "FBUser.h"

@implementation FBUser

- (instancetype)init
{
    if(self = [super init])
    {
        self.propertyMap = @{@"id":         @"ident",
                             @"first_name": @"firstName",
                             @"last_name":  @"lastName",
                             @"updated_time": @"updatedTime"};
    }
    return self;
}

- (Class)classForElementsInArrayProperty:(NSString *)propertyName
{
    return [FBWork class];
}

@end
```

