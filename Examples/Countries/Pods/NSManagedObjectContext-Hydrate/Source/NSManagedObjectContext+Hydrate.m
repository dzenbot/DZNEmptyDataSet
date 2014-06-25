//
//  NSManagedObjectContext+Hydrate.m
//
//  Created by Ignacio Romero Zurbuchen on 7/9/13.
//  Copyright (c) 2013 DZN Labs.
//  Licence: MIT-Licence
//

#import "NSManagedObjectContext+Hydrate.h"

#define kNSManagedObjectContextDefaultDateFormat @"yyyy-MM-dd'T'HH:mm:ss"

static NSManagedObjectContext *_sharedContext = nil;
static NSDateFormatter *_defaultDateFormatter = nil;
static NSString *_preferredDateFormat = nil;

@implementation NSManagedObjectContext (Hydrate)


#pragma mark - NSManagedObjectContext Getter Methods

+ (NSManagedObjectContext *)sharedContext
{
    return _sharedContext;
}

- (NSDateFormatter *)defaultDateFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        _defaultDateFormatter = [[NSDateFormatter alloc] init];
    });
    
    if (![_defaultDateFormatter.dateFormat isEqualToString:self.preferredDateFormat]) {
        [_defaultDateFormatter setDateFormat:self.preferredDateFormat];
    }
    
    return _defaultDateFormatter;
}

- (NSString *)preferredDateFormat
{
    if (_preferredDateFormat == nil) {
        return kNSManagedObjectContextDefaultDateFormat;
    }
    return _preferredDateFormat;
}


#pragma mark - NSManagedObjectContext Setter Methods

+ (void)setSharedContext:(NSManagedObjectContext *)context
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedContext = context;
    });
}

- (void)setPreferredDateFormat:(NSString *)format
{
    _preferredDateFormat = format;
}


#pragma mark - Hydrate from CSV data

- (void)hydrateStoreWithCSVAtPath:(NSString *)path attributeMappings:(NSDictionary *)attributes forEntityName:(NSString *)entityName
{
    // Check first if the bundle file path is valid
    if (!path || ![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"Sorry, the file at path %@ doesn't seem the exist.",path);
        return;
    }
    
    NSString *JSON = [self JSONStringFromCSVAtPath:path];
    NSData *data = [JSON dataUsingEncoding:NSUTF8StringEncoding];
    [self hydrateStoreWithJSONData:data attributeMappings:attributes forEntityName:entityName];
}


#pragma mark - Hydrate from JSON data

- (void)hydrateStoreWithJSONAtPath:(NSString *)path attributeMappings:(NSDictionary *)attributes forEntityName:(NSString *)entityName
{
    // Check first if the bundle file path is valid
    if (!path || ![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"Sorry, the file at path %@ doesn't seem the exist.",path);
        return;
    }
    
    [self hydrateStoreWithJSONData:[NSData dataWithContentsOfFile:path] attributeMappings:attributes forEntityName:entityName];
}

- (void)hydrateStoreWithJSONData:(NSData *)data attributeMappings:(NSDictionary *)attributes forEntityName:(NSString *)entityName
{
    NSError *error = nil;
    
    // Serializes the JSON data structure into arrays and collections
    NSArray *objects = [NSJSONSerialization JSONObjectWithData:data
                                                       options:kNilOptions|NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!error) {
        [self hydrateStoreWithObjects:objects attributeMappings:attributes forEntityName:entityName];
    }
    else {
        NSLog(@"%s ERROR : %@",__FUNCTION__, error.localizedDescription);
    }
}


#pragma mark - Hydrate from native objects

- (void)hydrateStoreWithObjects:(NSArray *)objects attributeMappings:(NSDictionary *)attributes forEntityName:(NSString *)entityName
{
    // We verify that there isn't already an entity table filled with content
    if (objects.count == 0) {
        NSLog(@"The array seems to be empty. Please set a non-nil array with objects.");
        return;
    }
    if (![self isEmptyStoreForEntityName:entityName]) {
        NSLog(@"A table with the entity name '%@' is already populated.", entityName);
        return;
    }
    
    [objects enumerateObjectsUsingBlock:^(NSDictionary *node, NSUInteger idx, BOOL *stop) {
        
        // First we insert a new object to the managed object context
        NSObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
        
        // Then we retrieve all the entity's attributes, to specially be aware about its properties name
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
        
        for (NSAttributeDescription *attributeDescription in entityDescription.properties) {
            
            NSString *sourceKey = attributes ? [attributes objectForKey:attributeDescription.name] : attributeDescription.name;
            if (!sourceKey) continue;
                
            id obj = [node objectForKey:sourceKey];
            id value = nil;
            
            // We verify if the object is supposed to be parsed as a date. If YES, a default date formatter does the conversion automatically.
            if ([[attributeDescription attributeValueClassName] isEqualToString:NSStringFromClass([NSDate class])]) {
                
                if ([obj isKindOfClass:[NSString class]]) {
                    value = [self.defaultDateFormatter dateFromString:(NSString *)obj];
                }
            }
            else {
                value = obj;
            }
            
            // We set the value from the parsed collection, to the entity's attribute name.
            // It is important that the both, the JSON key and the property name match.
            // An exception will be raised in case that a key doesn't match to its property.
            [newObject setValue:value forKey:attributeDescription.name];
        }
    }];
}


#pragma mark - Testing and validation methods

- (NSArray *)testByFetchingEntity:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        return fetchedObjects;
    }
    else {
        NSLog(@"%s ERROR : %@",__FUNCTION__, [error localizedDescription]);
        return nil;
    }
}

- (BOOL)isEmptyStoreForEntityName:(NSString *)entityName
{
    NSArray *fetchedObjects = [self testByFetchingEntity:entityName];
    return (fetchedObjects.count == 0) ? YES : NO;
}


#pragma mark - CSV tool methods

- (NSString *)JSONStringFromCSVAtPath:(NSString *)path
{
    NSError *error = nil;

    // Gets the CSV string at path
    NSString *string = [[NSString alloc] initWithContentsOfFile:path encoding:NSStringEncodingConversionAllowLossy error:&error];
    if (error) {
        NSLog(@"%s ERROR : %@",__FUNCTION__, [error localizedDescription]);
        return nil;
    }

    // Splits the CSV string into several lines
    NSMutableArray *contentComponents = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@"\n"]];
    
    // Retrieves the key paths of the objects, and removes it from the content
    NSArray *keyPaths = [[contentComponents objectAtIndex:0] componentsSeparatedByString:@","];
    [contentComponents removeObjectAtIndex:0];
    
    // The string that will wrap every object
    NSMutableString *JSONData = [NSMutableString new];
    
    // Loops trought the CSV content and wraps each found entity
    [contentComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger i, BOOL *stop) {

        NSArray *itemComponents = [obj componentsSeparatedByString:@","];
        NSMutableString *object = [[NSMutableString alloc] initWithString:@"{"];
        
        [itemComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger j, BOOL *stop) {
            
            NSString *attribute = [itemComponents objectAtIndex:j];
            NSString *key = [keyPaths objectAtIndex:j];
            
            NSString *value = ([self isNumeric:attribute]) ? [NSString stringWithFormat:@"%@",attribute] : [NSString stringWithFormat:@"\"%@\"",attribute];

            [object appendString:[NSString stringWithFormat:@"\"%@\":%@",key,value]];
            
            if (j < keyPaths.count-1) [object appendString:@","];
        }];
        
        [object appendString:@"}"];
        if (i < contentComponents.count-1) [object appendString:@","];
        
        [JSONData appendString:object];
    }];
    
    // Return the newly created JSON string
    return [NSString stringWithFormat:@"[%@]",JSONData];
}

- (BOOL)isNumeric:(NSString *)string
{
    NSCharacterSet *alphaNums = [[NSCharacterSet characterSetWithCharactersInString:@".0987654321."] invertedSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    return ![alphaNums isSupersetOfSet:inStringSet];
}

@end
