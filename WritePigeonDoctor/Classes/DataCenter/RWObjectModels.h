//
//  RWObjectModels.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/7.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWUser : NSObject

@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, retain) NSData *header;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *umid;
@property (nonatomic, assign) BOOL defaultUser;

@end

@interface RWHistory : NSObject

@property (nonatomic, retain) NSString *doctorDescription;
@property (nonatomic, retain) NSString *doctorid;
@property (nonatomic, retain) NSData *header;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *office;
@property (nonatomic, retain) NSString *professionTitle;
@property (nonatomic, retain) NSString *umid;

@end

@interface RWCard : NSObject

@property (nonatomic, retain) NSString *doctorDescription;
@property (nonatomic, retain) NSString *doctorid;
@property (nonatomic, retain) NSData *header;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *office;
@property (nonatomic, retain) NSString *professionTitle;
@property (nonatomic, retain) NSString *umid;

@end
