//
//  Common.h
//  iGeo
//
//  Created by Xiao Jiang on 11/19/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#ifndef iGeo_Common_h
#define iGeo_Common_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif
