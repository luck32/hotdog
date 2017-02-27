
//
//  HOTDOGGlobal.h
//  HOTDOG
//
//  Created by User on 7/21/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#ifndef HOTDOG_HOTDOGGlobal_h
#define HOTDOG_HOTDOGGlobal_h

#define APP_NAME   @"HOTDOG Photo"
#define CHK_TYPE(_OBJ_, _CLASS_)    ((_OBJ_) != nil && [_OBJ_ isKindOfClass:(_CLASS_)])
#define CHK_ERR(_ERR_)              CHK_TYPE(_ERR_, NSError.class)
#define MAKE_ERR(_MSG_)             ([NSError errorWithDomain:APP_NAME code:1020 userInfo:@{NSLocalizedDescriptionKey:(_MSG_)}])
#define ERR_MSG(_ERR_)              (((NSError*)(_ERR_)).localizedDescription)
#define VALID_NULL(_OBJ_, _DEF_)    ((CHK_TYPE((_OBJ_), NSNull.class) || ((_OBJ_) == nil)) ? (_DEF_) : (_OBJ_))
#define SCR_BOUND                   ([UIScreen mainScreen].bounds)


#endif
