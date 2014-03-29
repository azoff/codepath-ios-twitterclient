//
//  MUJSONSerializer.m
//  Paragraph
//
//  Created by Martin Ulianko on 08/03/14.
//  Copyright (c) 2014 Martin Ulianko. All rights reserved.
//

#import "MUJSONResponseSerializer.h"
#import <objc/runtime.h>

@implementation MUJSONResponseSerializer {}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    id responseObject = [super responseObjectForResponse:response data:data error:error];
    
    // array
    //
    if ([responseObject isKindOfClass:[NSArray class]])
    {
        NSMutableArray *objects = [NSMutableArray new];
        
        for(id item in responseObject)
        {
            [objects addObject:[[[self responseObjectClass] alloc] initWithJSON:item]];
        }
        
        responseObject = objects;
    }
    
    // dictionary
    //
    else {
        responseObject = [[[self responseObjectClass] alloc] initWithJSON:responseObject];
    }

    return responseObject;
}

@end


@interface MUJSONResponseObject()

- (void)setObjectValue:(id)object forPropertyName:(NSString *)propertyName withClassName:(NSString *)className;
- (void)setValuesToProperties:(NSDictionary *)propertyValues;
@end

@implementation MUJSONResponseObject

#pragma mark PUBLIC METHODS


- (instancetype) init
{
    if (self = [super init])
    {
        // date formatter
        // default
        if(![self dateFormatter])
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        }
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)jsonResponse
{
    if(self = [self init])
    {
        // property map
        //
        NSMutableDictionary *propertyValues = [[NSMutableDictionary alloc] init];
        
        for (NSString *jsonPropertyName in [jsonResponse allKeys])
        {
            // use custom mapping, e.g. id -> ident
            // if you need custom mapping, you must overwrite getter for property map in your resposne object class
            NSString *propertyName = [self.propertyMap valueForKey:jsonPropertyName] ? [self.propertyMap valueForKey:jsonPropertyName] : jsonPropertyName;
            
            [propertyValues setObject:[jsonResponse objectForKey:jsonPropertyName] forKey:propertyName];
        }

        [self setValuesToProperties:propertyValues];
    }
    
    return self;
}

- (Class)classForElementsInArrayProperty:(NSString *)propertyName
{
    return nil;
}

- (NSDictionary *)propertyMap
{
    return _propertyMap;
}

- (id)validateObject:(id)object forPropertyName:(NSString *)propertyName withClass:(Class)propertyClass
{
    // NSString
    if([propertyClass isSubclassOfClass:[NSString class]])
    {
        // NSNull -> nil
        if([object isKindOfClass:[NSNull class]])
            object = nil;
        
        // @"" -> nil
        if ([object isEqualToString:@""])
            object = nil;
    }
    
    // NSDate
    // format time correctly
    if([propertyClass isSubclassOfClass:[NSDate class]])
    {
        // NSDate from NSString
        if([object isKindOfClass:[NSString class]])
            object = [self.dateFormatter dateFromString:object];
        
        // NSDate from timestamp in NSNumber
        if([object isKindOfClass:[NSNumber class]])
            object = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)object doubleValue]];
    }
    
    // NSArray
    // empty arrray -> nil
    if([propertyClass isSubclassOfClass:[NSArray class]])
    {
        if([object isKindOfClass:[NSArray class]] && [object count] == 0)
            object = nil;
            
    }
    
    return object;
}

#pragma mark PRIVATE METHODS

- (void)setObjectValue:(id)object forPropertyName:(NSString *)propertyName withClassName:(NSString *)className
{
    Class propertyClass = NSClassFromString(className);

    // NSDate
    if ([propertyClass isSubclassOfClass:[NSDate class]])
    {
        object = [self validateObject:object forPropertyName:propertyName withClass:propertyClass];
        [self setValue:object forKey:propertyName];
    }
    
    // NSString
    // NSNumber
    // NSDictionary
    else if ([propertyClass isSubclassOfClass:[NSString class]] ||
        [propertyClass isSubclassOfClass:[NSNumber class]] ||
        [propertyClass isSubclassOfClass:[NSDictionary class]])
    {
        object = [self validateObject:object forPropertyName:propertyName withClass:propertyClass];
        [self setValue:object forKey:propertyName];
    }
    
    // NSArray
    else if([propertyClass isSubclassOfClass:[NSArray class]])
    {
        Class elementClass = [self classForElementsInArrayProperty:propertyName];
        
        // we know about elements in array
        if (elementClass)
        {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[(NSArray *)object count]];
            for (id item in (NSArray *)object)
            {
                if([elementClass isSubclassOfClass:[MUJSONResponseObject class]])
                {
                    id element = [(MUJSONResponseObject *)[elementClass alloc] initWithJSON:item];
                    [array addObject:element];
                }
                else {
                    NSLog(@"MUJSONSerializer: Warning - given element class is not subclass of MUJSONResponseObject");
                    [array addObject:item];
                }
            }
            
            object = [self validateObject:array forPropertyName:propertyName withClass:propertyClass];
            [self setValue:object forKey:propertyName];
        }
        else
        {
            object = [self validateObject:object forPropertyName:propertyName withClass:propertyClass];
            [self setValue:object forKey:propertyName];
        }
    }
    
    // custom classes
    else if([propertyClass isSubclassOfClass:[MUJSONResponseObject class]])
    {
        object = [self validateObject:[(MUJSONResponseObject *)[propertyClass alloc] initWithJSON:object]
                     forPropertyName:propertyName
                           withClass:propertyClass];
        
        [self setValue:object forKey:propertyName];

    }
    
}

- (void)setValuesToProperties:(NSDictionary *)propertyValues
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        char *typeEncoding = property_copyAttributeValue(property, "T");
        switch (typeEncoding[0])
        {
            case '@':
            {
                if (strlen(typeEncoding) >= 3  && [propertyValues valueForKey:propertyName])
                {
                    char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                    __autoreleasing NSString *propertyClassName = @(className);
                    NSRange range = [propertyClassName rangeOfString:@"<"];
                    if (range.location != NSNotFound)
                    {
                        propertyClassName = [propertyClassName substringToIndex:range.location];
                    }
                    propertyClassName = propertyClassName ? propertyClassName : @"NSObject";
                    free(className);
                    
                    
                    [self setObjectValue:[propertyValues valueForKey:propertyName] forPropertyName:propertyName withClassName:propertyClassName];
                }
            }
            break;

            
            case 'c':   // BOOL or char
            case 'i':   //int
            case 's':   //short
            case 'l':   //long
            case 'q':   //long long
            case 'C':   //unsigned char
            case 'I':   //unsigned int
            case 'S':   //unsigned short
            case 'L':   //unsigned long
            case 'Q':   //unsigned long long
            case 'f':   //float
            case 'd':   //double
            case ':':   //selector
            case 'B':   //bool
            case '{':   //value
                if([propertyValues valueForKey:propertyName])
                    [self setObjectValue:[propertyValues valueForKey:propertyName] forPropertyName:propertyName withClassName:@"NSNumber"];
                break;
        }
        free(typeEncoding);
    }
    free(properties);
}

@end
