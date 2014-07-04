//
//  NSMutableArray+Save.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/4/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

/*
 Straigh-forward methods for saving array filled with primite objects and/or custom objects.
 */
@interface NSMutableArray (Save)

/*
 Serializes and saves locally an array containing primitive and/or custom objects into a coded plist file.
 For custom objects, be sure to implement NSCoding protocol.

 @param filename The plist file name to be saved on.
*/
- (void)saveArrayToFile:(NSString *)filename;

/* Deserializes and returns an array containing the previously saved objects.

 @param fileName The plist file name to be saved on.
 @return A mutable array with the serialized objects ready to be used.
*/
+ (NSMutableArray *)loadArrayfromFile:(NSString *)fileName;

@end
