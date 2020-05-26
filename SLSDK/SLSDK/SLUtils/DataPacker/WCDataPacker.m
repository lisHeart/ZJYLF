//
//  WCDataPacker.m
//  winCRM
//
//  Created by Cai Lei on 12/10/12.
//  Copyright (c) 2012 com.cailei. All rights reserved.
//

#import "WCDataPacker.h"
#import "GTMBase64.h"
#import "NSData+ZIP.h"
#import "NSData+CommonCrypto.h"
/// transplant from the colorgenious add by jimmy lee
static WCDataPacker *sharedInstance;
/// transplant from the colorgenious add by jimmy lee
const NSString *InitStreetCode = @"8F, Block E, Dazhongsi Zhongkun Plaza, No. A18 West Beisanhuan Road, Haidian District, Beijing";
const NSString *InitHttpCode = @"http://www.winchannel.net";

const UInt32 TypeCodeLength=2;
const UInt32 ErrorCodeLength=4;
const UInt32 ContentLenghtCodeLength=4;
const UInt32 FileLenghtCodeLength=4;

@implementation WCDataPacker
/// transplant from the colorgenious add by jimmy lee
+ (void)initialize {
    
    //NSAssert([WCDataPacker class] == self, @"Incorrect use of singleton : %@, %@", [WCDataPacker class], [self class]);
   // sharedInstance = [[WCDataPacker alloc] init];
}

+ (WCDataPacker *)sharedInstance {
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}
/// transplant from the colorgenious add by jimmy lee


- (NSData *)secretKey {
    NSData *firstPart = [InitStreetCode dataUsingEncoding:NSUTF8StringEncoding];
    NSData *secondPart = [InitHttpCode dataUsingEncoding:NSUTF8StringEncoding];
    if ((self.salt) && ([self.salt length])) {
        secondPart = [self.salt dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSMutableData *code = [NSMutableData dataWithData:[firstPart MD5Sum]];
    [code appendData:[secondPart MD5Sum]];
    
    return [NSData dataWithData:code];
}

- (NSData *)packDataWithZip:(NSData *)aData {
    // 1, zip
    NSData *zipData = [aData zip];
    
    // 2, encrypt
    CCCryptorStatus error = kCCSuccess;
    NSData *encryptData = [zipData dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                           key:[self secretKey]
                                                       options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                         error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"pack body error : %d", error);
        return nil;
    }
    
    return encryptData;
}

- (NSData *)packData:(NSData *)aData{
    // 2, encrypt
    CCCryptorStatus error = kCCSuccess;
    NSData *encryptData = [aData dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                         key:[self secretKey]
                                                     options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                       error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"pack body error : %d", error);
        return nil;
    }
    
    return encryptData;
}


- (NSData *)unpackDataWithUnzip:(NSData *)aData {
    // 1, decrypt
    CCCryptorStatus error = kCCSuccess;

    NSData *decryptData = [aData decryptedDataUsingAlgorithm:kCCAlgorithmAES128
                                                         key:[self secretKey]
                                                     options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                       error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"unpack body error : %d", error);
        return nil;
    }
    
    // 2, unzip
    NSData *unzipData = [decryptData unzip];
    
    return unzipData;
}

- (NSData *)unpackData:(NSData *)aData
{
    CCCryptorStatus error = kCCSuccess;

    NSData *decryptData = [aData decryptedDataUsingAlgorithm:kCCAlgorithmAES128
                                                         key:[self secretKey]
                                                     options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                       error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"unpack body error : %d", error);
        return nil;
    }
    return decryptData;                                                                                                                                                                
}


- (NSString *)packStringWithZip:(NSString *)aString
{
    NSData *orgData = [aString dataUsingEncoding:NSUTF8StringEncoding];
    // 1, zip
    NSData *zipData = [orgData zip];
    
    // 2, encrypt
    CCCryptorStatus error = kCCSuccess;
    NSData *encryptData = [zipData dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                           key:[self secretKey]
                                                       options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                         error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"pack body error : %d", error);
        return nil;
    }
    
    // 3, base64 URL encoding
    NSString *base64EncodeString = [GTMBase64 stringByWebSafeEncodingData:encryptData padded:YES];
    return base64EncodeString;
}

- (UInt16)getResponseTwoBytes:(const char *)aResponse
                                   offset:(NSInteger)aOffset
{
    UInt16 result = 0;
    memcpy(&result, (aResponse+aOffset), 2);
    return [WCDataPacker checkCPULittleEndian]?(ntohs(result)):result;
}

- (UInt32)getResponseFourBytes:(const char *)aResponse
                                 offset:(NSInteger)aOffset
{
    UInt32 result = 0;
    memcpy(&result, (aResponse+aOffset), 4);
    return [WCDataPacker checkCPULittleEndian]?(ntohl(result)):result;
}

- (NSData *)getResponseContent:(const char *)aResponse
                        offset:(NSInteger)aOffset
                        length:(UInt32)aLength

{
    NSData *content = [NSData dataWithBytes:(aResponse+aOffset) length:aLength];
    return content;
}

- (void)getResponseInfo:(NSData *)rawData
                   type:(UInt16 *)aType
              errorCode:(UInt32 *)aErrorCode
                content:(NSData **)aContent
                   file:(id *)aFile
{
    if (!rawData)
        return;

    const char *aResponse= [rawData bytes];
    UInt32 dataLength= [rawData length];
    if (dataLength>=TypeCodeLength+ErrorCodeLength)
    {
        *aType = [self getResponseTwoBytes:aResponse offset:0];
        *aErrorCode = [self getResponseFourBytes:aResponse offset:TypeCodeLength];

        //content and file
        if (dataLength >= TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength)
        {
            // 检查content
            UInt32 contentLength = [self getResponseFourBytes:aResponse offset:TypeCodeLength+ErrorCodeLength];
            if (contentLength == 0)
            {
                // 没有content，检查是否有file
                if (dataLength >= TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength+FileLenghtCodeLength)
                {
                    UInt32 fileLength= [self getResponseFourBytes:aResponse offset:TypeCodeLength+ErrorCodeLength+contentLength];
                    if (fileLength&&dataLength==TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength+FileLenghtCodeLength+fileLength)
                    {
                        // 有file，且file长度正确
                        *aFile= [self getResponseContent:aResponse offset:TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength+contentLength length:fileLength];
                    }
                }
            }
            else
            {
                UInt32 dataOffset = TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength + contentLength;
                // 有content
                if (dataLength >= dataOffset)
                {
                    // 取出content
                    *aContent = [self getResponseContent:aResponse offset:TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength length:contentLength];

                    // 检查有没有file
                    if (dataLength >= (dataOffset + FileLenghtCodeLength))
                    {
                        UInt32 fileLength= [self getResponseFourBytes:aResponse offset:TypeCodeLength+ErrorCodeLength+contentLength];
                        if (fileLength>0&&dataLength == (dataOffset +FileLenghtCodeLength+ fileLength))
                        {
                            // 有file，且file长度正确
                            *aFile= [self getResponseContent:aResponse offset:TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength+contentLength length:fileLength];
                        }
                    }
                }
            }
        }
    }

}



//Tcp/ip:big endian; host:little endian
+ (int)checkCPULittleEndian
{
    union
    {
        unsigned int a;
        unsigned char b;
    }c;
    c.a = 1;
    return (c.b == 1);
}

// type : 2
// content len : 4
// content
// file len : 4
// file
- (NSData *)generatePost:(NSData *)aContent forType:(UInt16)aType {
    NSUInteger totalLen = 2 + 4 + [aContent length];
    char totalBytes[totalLen];
    
    UInt16 type = [WCDataPacker checkCPULittleEndian]?(htons(aType)):aType;
    UInt32 len = [WCDataPacker checkCPULittleEndian]?(htonl([aContent length])):[aContent length];
    
    memcpy(totalBytes, &type, 2);
    memcpy((totalBytes + 2), &len, 4);
    memcpy((totalBytes + 2 + 4), [aContent bytes], [aContent length]);
    NSData *totalData = [[NSData alloc] initWithBytes:totalBytes length:totalLen];

    return totalData;
}

- (NSData *)generatePost:(NSData *)aContent forType:(UInt16)aType withFile:(NSData *)aFile {
    NSUInteger totalLen = 2 + 4 + [aContent length] + 4 + [aFile length];
    char totalBytes[totalLen];
    
    UInt16 type = [WCDataPacker checkCPULittleEndian]?(htons(aType)):aType;
    UInt32 len = [WCDataPacker checkCPULittleEndian]?(htonl([aContent length])):[aContent length];
    UInt32 len2 = [WCDataPacker checkCPULittleEndian]?(htonl([aFile length])):[aFile length];
    memcpy(totalBytes, &type, 2);
    memcpy((totalBytes + 2), &len, 4);
    memcpy((totalBytes + 2 + 4), [aContent bytes], [aContent length]);
    memcpy((totalBytes + 2 + 4 + [aContent length]), &len2, 4);
    memcpy((totalBytes + 2 + 4 + [aContent length] + 4), [aFile bytes], [aFile length]);
    NSData *totalData = [[NSData alloc] initWithBytes:totalBytes length:totalLen];
    return totalData;
}



- (NSData *)decrypt398File:(NSData *)aData withSalt:(NSString *)salt andLength:(NSUInteger)headerLen
{
    char header[headerLen];
    NSUInteger totalLen= [aData length];
    if (headerLen> totalLen)
        return nil;

    NSMutableData *result= [NSMutableData data];
    NSUInteger offset=headerLen;
    [aData getBytes:header length:offset];//is.read(header, 0, mLen);
    if (headerLen > 0)
    {
        CCCryptorStatus error = kCCSuccess;

        NSData *decryptData = [[NSData dataWithBytes:header length:headerLen] decryptedDataUsingAlgorithm:kCCAlgorithmAES
                                                                                                      key:[[salt dataUsingEncoding:NSUTF8StringEncoding] MD5Sum]
                                                                                                  options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                                                                    error:&error];
        if (kCCSuccess != error)
            return nil;

        const char *hdr = [decryptData bytes];//hdr = CryptoUtils.decrypt(header, CryptoUtils.MD5(mSalt.getBytes()));
        if (headerLen> [decryptData length])
        {
            totalLen-=headerLen- [decryptData length];
            headerLen= [decryptData length];
        }

        [result appendData:decryptData]; //os.write(hdr, 0, hdrLen);

        char ct [headerLen];
        NSUInteger ctLen = MIN(headerLen, totalLen-headerLen);

        while (offset<totalLen)
        {
            [aData getBytes:ct range:NSMakeRange(offset, ctLen)];
            if (ctLen < headerLen)
            {
                [result appendBytes:ct length:ctLen];//os.write(ct, 0, ctLen);
                break;
            }
            else
            {
                XORProcess(ct, ct, hdr, ctLen, headerLen);    //ct = bytesXOR(ct, hdr);
                [result appendBytes:ct length:ctLen];//os.write(ct, 0, ctLen);
            }
            offset+=ctLen;
            if (totalLen-offset>=headerLen)
                ctLen=headerLen;
            else
                ctLen=totalLen-offset;
        }
        return result;
    }
    return nil;
}
//异或算法，加密解密均调用该方法
void XORProcess(const char *src, char *dst,const char *key, int m,int n)
{


    for (int i = 0, j = 0; i < m; i++, j++)
    {
        if (j == n)
            j = 0;
        dst[i] = src[i] ^ key[j];
    }
}


///////// transplant from the colorgenious -- add by jimmy lee

- (UInt16)getResponseTypeTwoBytes:(const char *)aResponse
                           offset:(NSInteger)aOffset
{
    UInt16 type = 0;
    memcpy(&type, (aResponse+aOffset), 2);
    return [WCDataPacker checkCPULittleEndian]?(ntohs(type)):type;
}


- (UInt32)getResponseErrorCodeFourBytes:(const char *)aResponse
                                 offset:(NSInteger)aOffset
{
    UInt32 errorCode = 0;
    memcpy(&errorCode, (aResponse+aOffset), 4);
    return [WCDataPacker checkCPULittleEndian]?(ntohl(errorCode)):errorCode;
}


- (UInt32)getResponseContentLengthCodeFourBytes:(const char *)aResponse
                                         offset:(NSInteger)aOffset
{
    UInt32 contentLength = 0;
    memcpy(&contentLength, (aResponse+aOffset), 4);
    return [WCDataPacker checkCPULittleEndian]?(ntohl(contentLength)):contentLength;
}


- (void)getResponseInfo:(const char *)aResponse
                   type:(UInt16 *)aType
              errorCode:(UInt32 *)aErrorCode
          contentLength:(UInt32 *)aContentLength
                content:(NSData **)aContent{
    
    if (!aResponse) {
        return;
    }
    *aType = [self getResponseTypeTwoBytes:aResponse offset:0];
    *aErrorCode = [self getResponseErrorCodeFourBytes:aResponse offset:2];
    *aContentLength = [self getResponseContentLengthCodeFourBytes:aResponse offset:6];
    if(*aErrorCode == 0 || *aErrorCode == *aType * 1000)
    {
        *aContent = [self getResponseContent:aResponse offset:10 length:*aContentLength];
    }
    
    
}


- (NSString *)packForURLParam:(NSString *)aURLParam {
    NSData *orgData = [aURLParam dataUsingEncoding:NSUTF8StringEncoding];
    // 1, zip
    NSData *zipData = [orgData zip];
    
    // 2, encrypt
    CCCryptorStatus error = kCCSuccess;
    NSData *encryptData = [zipData dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                           key:[self secretKey]
                                                       options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                         error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"pack body error : %d", error);
        return nil;
    }
    
    // 3, base64 URL encoding
    NSString *base64EncodeString = [GTMBase64 stringByWebSafeEncodingData:encryptData padded:YES];
    return base64EncodeString;
}


- (NSData *)unpackForPostBody:(NSData *)aData {
    // 1, decrypt
    CCCryptorStatus error = kCCSuccess;
#if 0
    Byte *test = [aData bytes];
    unsigned short type;
    unsigned short dataerror;
    unsigned int contentLen;
    char a[4] = {0};
    a[0] = test[1];
    a[1] = test[0];
    memcpy(&type, a, 2);
    a[0] = test[3];
    a[1] = test[2];
    memcpy(&dataerror, a, 2);
    a[0] = test[7];
    a[1] = test[6];
    a[2] = test[5];
    a[3] = test[4];
    memcpy(&contentLen, a, 4);
    NSData *aaa = [NSData dataWithBytes:(test+8) length:contentLen];
#endif
    NSData *decryptData = [aData decryptedDataUsingAlgorithm:kCCAlgorithmAES128
                                                         key:[self secretKey]
                                                     options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                       error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"unpack body error : %d", error);
        return nil;
    }
    
    // 2, unzip
    NSData *unzipData = [decryptData unzip];
    
    return unzipData;
}

- (NSData *)packForPostBody:(NSData *)aData {
    // 1, zip
    NSData *zipData = [aData zip];
    
    // 2, encrypt
    CCCryptorStatus error = kCCSuccess;
    NSData *encryptData = [zipData dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                           key:[self secretKey]
                                                       options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                         error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"pack body error : %d", error);
        return nil;
    }
    
    return encryptData;
}

- (NSData *)packForPostBodyNoZip:(NSData *)aData{
    // 2, encrypt
    CCCryptorStatus error = kCCSuccess;
    NSData *encryptData = [aData dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                         key:[self secretKey]
                                                     options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                       error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"pack body error : %d", error);
        return nil;
    }

    return encryptData;
}

- (UInt16)getResponseErrorCodeTwoBytes:(const char *)aResponse
                                offset:(NSInteger)aOffset
{
    UInt16 errorCode = 0;
    memcpy(&errorCode, (aResponse+aOffset), 2);
    return [WCDataPacker checkCPULittleEndian]?(ntohs(errorCode)):errorCode;
}


///////// transplant from the colorgenious -- add by jimmy lee
@end

