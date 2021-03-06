//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CXMLNode;

@protocol XmlObjectBuilder

- (id) constructObjectFromXml:(CXMLNode *)node error:(NSError **)error;

@end
