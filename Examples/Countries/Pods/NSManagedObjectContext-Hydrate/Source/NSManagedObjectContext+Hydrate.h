//
//  NSManagedObjectContext+Hydrate.m
//
//  Created by Ignacio Romero Zurbuchen on 7/9/13.
//  Copyright (c) 2013 DZN Labs.
//  Licence: MIT-Licence
//

#import <CoreData/CoreData.h>

/**
 A NSManagedObjectContext category class for preload a CoreData persistent store with JSON data.
 IMPORTANT: Parsing is done automagically if the JSON key paths are identical to the entity attribute names. If not, you must provide a dictionary with attribute mappings matching the source key paths.
 */
@interface NSManagedObjectContext (Hydrate)

/**
 A custom date format that will be used for all date mappings that have not been configured specifically.
 If not set, the default format will be used instead "yyyy-MM-dd'T'HH:mm:ss'Z'"
 */
@property (nonatomic, strong) NSString *preferredDateFormat;

/**
 Returns the singleton managedObjectContext instance.
 
 @return The shared managedObjectContext.
 */
+ (NSManagedObjectContext *)sharedContext;


/**
 Sets a managedObjectContext static instance.
 
 @param context The managedObjectContext to be set.
 */
+ (void)setSharedContext:(NSManagedObjectContext *)context;


/**
 Preloads an entity table into the persistent store based on a CSV file's data.
 
 @param path The CSV file's path.
 @param attributes A collection of attribute mappings, wherein the keys represent the name target attributes on the destination object and the values represent the source key path.
 @param entityName The name of an entity to be stored.
 
 @discussion Calling this method without a valid attribute mappings collection will raise an exception. The dictionary must be keyed by destination attribute name to source key (the inverse way how the RKObjectMapping class from RestKit works).
 Passing a nil attribute mappings collection will be the same as calling hydrateStoreWithJSONAtPath:forEntityName: method.
 */
- (void)hydrateStoreWithCSVAtPath:(NSString *)path attributeMappings:(NSDictionary *)attributes forEntityName:(NSString *)entityName;


/**
 Preloads an entity table into the persistent store based on a JSON file's data.
 
 @param path The JSON file's path.
 @param attributes A collection of attribute mappings, wherein the keys represent the name target attributes on the destination object and the values represent the source key path.
 @param entityName The name of an entity to be stored.
 
 @discussion Calling this method without a valid attribute mappings collection will raise an exception. The dictionary must be keyed by destination attribute name to source key (the inverse way how the RKObjectMapping class from RestKit works).
 Passing a nil attribute mappings collection will be the same as calling hydrateStoreWithJSONAtPath:forEntityName: method.
 */
- (void)hydrateStoreWithJSONAtPath:(NSString *)path attributeMappings:(NSDictionary *)attributes forEntityName:(NSString *)entityName;


/**
 Preloads an entity table into the persistent store.
 
 @param objects A list of parsed objects (preferable, NSDictionary instances).
 @param attributes A collection of attribute mappings, wherein the keys represent the name target attributes on the destination object and the values represent the source key path.
 @param entityName The name of an entity to be stored.
 
 @discussion Calling this method without a valid attribute mappings collection will raise an exception. The dictionary must be keyed by destination attribute name to source key (the inverse way how the RKObjectMapping class from RestKit works).
 Passing a nil attribute mappings collection will be the same as calling hydrateStoreWithObjects:forEntityName: method.
 */
- (void)hydrateStoreWithObjects:(NSArray *)objects attributeMappings:(NSDictionary *)attributes forEntityName:(NSString *)entityName;


/**
 Checks if there isn't already an entity table preloaded with content.
 
 @param entityName The entity name to check.
 @returns YES if the store's table is empty. NO if the store is already preloaded with content.
 */
- (BOOL)isEmptyStoreForEntityName:(NSString *)entityName;


@end
