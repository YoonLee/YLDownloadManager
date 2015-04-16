//
//  GlobalConfig.h
//  blackcloset
//
//  Created by Yoon Lee on 4/23/14.
//  Copyright (c) 2014 BrandBoom. All rights reserved.
//
// PRE-COMPILE HELPER HEADER METHODS

/* -fno-objc-arc -> from nonARC to ARC project */
/* -fobjc-arc    -> from ARC    to nonARC project */
#define KILL_OBJ(x)             x = nil;    [x release];

#define CLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#ifdef VERBOSE
#   define DLog(...)
#elif DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define BBLocalizedString(x)    NSLocalizedString(x, @"")

static inline double getEstimateTime(clock_t start, clock_t end)
{ return (double)(end - start)/CLOCKS_PER_SEC; }

static inline void printEstimateTime(clock_t start, clock_t end)
{ CLog(@"%f secs", getEstimateTime(start, end)); }

/* Preset Colors */
#define RGB(R,G,B)                                  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define RGBA(R,G,B,A)                               [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define CINDY_RGB(C)                                RGB(C, C, C)
#define CWHITE()                                    RGB(255, 255, 255)
#define CBLACK()                                    RGB(  0,   0,   0)
#define CBBTEXT()                                   RGB(237, 118, 102)
#define CDRED( )                                    RGB(191, 52, 43)
#define CDBLUE()                                    [UIColor blueColor]
#define CDGREY()                                    RGB(141, 141, 141)
#define CDPINK()                                    RGB(255, 105, 180)
#define CDORANGE()                                  [UIColor orangeColor]
#define CCLEAR()                                    [UIColor clearColor]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

static inline CGRect landscapeFrame()
{
    return CGRectMake(0, 0, 1024, 768);
}

static inline CGRect deviceScreen()
{
    return [UIScreen mainScreen].bounds;
}

static inline BOOL strsEqual(NSString *str1, NSString *str2)
{
    return str1 == nil?str2 == nil:[str1 isEqualToString:str2];
}

static inline BOOL isEmptyStr(NSString* str)
{
    return !str.length;
}

static inline id nullObject(id obj)
{
    return obj == nil||[obj isEqual:[NSNull null]]?[NSNull null]:obj;
}

static inline BOOL isNULL(id obj)
{
    return [nullObject(obj) isEqual:[NSNull null]]?YES:NO;
}

static inline BOOL isZeroNumeric(NSNumber *number)
{
    return [number integerValue] == -1 || [number integerValue] == 0?true:false;
}


static inline NSString * billingTypeDecode(NSString *billStr)
{
    NSString *billingTypeStr = @"Billing & Shipping";
    
    if ([billStr hasPrefix:@"B"])
        billingTypeStr = @"Billing";
        else if ([billStr hasPrefix:@"S"])
            billingTypeStr = @"Shipping";
            
            return billingTypeStr;
}

static inline NSString *billingTypeEncode(NSString *billStr)
{
    // Blank for both Billing & Shipping
    NSString *billingTypeSendStr = @"";
    if ([billStr hasPrefix:@"B"])
        billingTypeSendStr = @"B";
        else if ([billStr hasPrefix:@"S"])
            billingTypeSendStr = @"S";
            
            return billingTypeSendStr;
}

static inline BOOL emailValidation(NSString *emailStr)
{
    if(isEmptyStr(emailStr))
        return NO;
    
    NSArray* emails = [emailStr componentsSeparatedByString:@"|"];
    if([emails count]==1){
        emails = [emailStr componentsSeparatedByString:@":"];
        if([emails count]>2)
            return NO;
    }
    
    for(NSString* email in emails){
        NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
        NSPredicate *emailCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExPattern];
        if(![emailCheck evaluateWithObject:email])
            return NO;
    }
    
    return YES;
}

static inline BOOL isPad()
{
#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return NO;
#endif
}

#define K 1024
static inline NSString* getFileSize(NSString* path)
{
    BOOL isDirectory = NO;
    float thesize = 0.0f;
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if([filemanager fileExistsAtPath:path isDirectory:&isDirectory]){
        NSDictionary *attributes = [filemanager attributesOfItemAtPath:path error:nil];
        
        // file size
        NSNumber *fileSizeNumber = [attributes objectForKey:NSFileSize];
        thesize = [fileSizeNumber floatValue];
    }
    
	if (thesize < K) {
		return [NSString stringWithFormat:@"%.2f Bytes", thesize];
	}
	thesize = thesize / K;
	if (thesize < K) {
		return [NSString stringWithFormat:@"%.2f KB", thesize];
	}
	thesize = thesize / K;
    
	return [NSString stringWithFormat:@"%.2f MB", thesize];
}

static inline BOOL isStrContains(NSString *fullStr, NSString *subStr)
{
    if ([subStr rangeOfString:fullStr options:NSCaseInsensitiveSearch].location != NSNotFound)
        return true;
    
    return false;
}
