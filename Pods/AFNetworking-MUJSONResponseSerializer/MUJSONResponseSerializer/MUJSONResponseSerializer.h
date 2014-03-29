//
//  MUJSONSerializer.h
//  Paragraph
//
//  Created by Martin Ulianko on 08/03/14.
//  Copyright (c) 2014 Martin Ulianko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/**
 *  MUJSONResponseSerializer is subclass of AFJSONResponseSerializer which automatically serialize
 *  response foundation objects to your custom model objects.
 */
@interface MUJSONResponseSerializer : AFJSONResponseSerializer <AFURLResponseSerialization>

/**
 *  Tells MUJSONResponseSerializer which class is top level object. 
 *  In case of array of ojects, the serializer assumed that all objects in the array are the same class
 */
@property (nonatomic) Class responseObjectClass;

@end

/**
 *  It is base object for all your model objects. It wil find all your properties in subclass and set value for each.
 *  It ignore all keys which dont belong to any property.
 */
@interface MUJSONResponseObject : NSObject

/**
 *  It is used in validate method to correct build NSDate from NSString.
 *  By default is set as [dateFormatter setDateStyle:NSDateFormatterFullStyle];
 */
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

/**
 *  Mapps service keys to property keys.
 *  There is no need to map all keys but only those which you want to have different name.
 *  (for example id -> userID)
 */
@property (nonatomic, strong) NSDictionary *propertyMap;

/**
 *  Designated initializer which do all the work.
 *  If you want setup something before the process (for example dateFormatter or propertyMap), you should use "init" method instead of this.
 *
 *  @param jsonResponse NSDictionary of response values
 *
 *  @return instancetype
 */
- (instancetype)initWithJSON:(id)jsonResponse;

/**
 *  This method tells to response object which kind of objects are in the array.
 *  It use that information and create objects for you recursively.
 *
 *  @param propertyName name of array property
 *
 *  @return Class - It have to be subclass of MUJSONResponseObject
 */
- (Class)classForElementsInArrayProperty:(NSString *)propertyName;

/**
 *  This is default validation method. It converts empty string, empty arrays and NSNull to nil.
 *  It also build NSDate from strings on which it use dateFormatter property. Please set dateFormatter property
 *  in your init method int order to correct formatting string from dates;
 *
 *  @param object       object to validate
 *  @param propertyName property name
 *  @param objectClass  property class
 *
 *  @return return adjusted object
 */
- (id)validateObject:(id)object forPropertyName:(NSString *)propertyName withClass:(Class)propertyClass;

@end
