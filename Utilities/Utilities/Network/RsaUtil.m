//
//  SARsaUtil.m
//  Annotation_iPad
//
//  Created by Yao Melo on 4/17/13.
//
//

#import "RsaUtil.h"
#import <tomcrypt.h>

ltc_math_descriptor ltc_mp;

static inline unsigned long InputLimit(unsigned long pubKeyBitSize)
{
    switch (pubKeyBitSize) {
        case 768:
            return 85;
        case 1024:
            return 117;
        case 2048:
            return 245;
        default:
            return 0;
    }
}


static inline unsigned long OutputSize(unsigned long pubKeyBitSize)
{
    if(pubKeyBitSize == 768||pubKeyBitSize==1024||pubKeyBitSize==2048)
    {
        return pubKeyBitSize/8;
    }
    else
    {
        return 0;
    }
}

static inline unsigned long TotalOuputSize(unsigned long totalInput, unsigned long pubKeyBitSize)
{
    unsigned long inputBlock = InputLimit(pubKeyBitSize);
    if(inputBlock == 0)
    {
        return 0;
    }
    unsigned totalOutput = ((totalInput + inputBlock -1) /inputBlock) * OutputSize(pubKeyBitSize);
    return totalOutput;
}


@implementation RsaUtil

+(void)initialize
{
    ltc_mp = tfm_desc;
}

+ (NSData*) encryptWithPublicKey:(NSData*)pubKey forData:(NSData*)data
{
    
    int err, hash_idx, prng_idx;
    unsigned long pubKeyLen = [pubKey length];
    rsa_key rsaPubKey;
    err = rsa_import([pubKey bytes], pubKeyLen, &rsaPubKey);
    
    if(err != CRYPT_OK)
    {
        DDLogError("Invalid public key");
        return nil;
    }
    
    if (register_prng(&sprng_desc) == -1) {
        DDLogError("Error registering sprng");
        rsa_free(&rsaPubKey);
        return nil;
    }
    if (register_hash(&sha1_desc) == -1) {
        DDLogError("Error registering sha1");
        rsa_free(&rsaPubKey);
        return nil;
    }
    
    hash_idx = find_hash("sha1");
    prng_idx = find_prng("sprng");
    unsigned long pubKeySize = mp_count_bits(rsaPubKey.N);
    unsigned long outputLen = TotalOuputSize([data length], pubKeySize);
    if(outputLen == 0)
    {
        DDLogError("Illegal public key size");
        rsa_free(&rsaPubKey);
        return nil;
    }
    void *outBuf = malloc(outputLen);//encData will take over the ownership, so do not free it.
    NSData *encData = [NSData dataWithBytesNoCopy:outBuf length:outputLen];
    unsigned long inputBlockSize = InputLimit(pubKeySize);
    if(inputBlockSize == 0)
    {
        rsa_free(&rsaPubKey);
        return nil;
    }
    unsigned long offset = 0,outOffset = 0;
    const void *inputBuf = [data bytes];
    unsigned long inputLen = [data length];
    while (offset < inputLen && outOffset < outputLen) {
        unsigned long inputSize = inputLen - offset > inputBlockSize?inputBlockSize:inputLen - offset;
        unsigned long outBlockSize = outputLen - outOffset;
        err = rsa_encrypt_key_ex(inputBuf+offset, /* data we wish to encrypt */
                                 inputSize, /* data is 16 bytes long */
                                 outBuf+outOffset , /* where to store ciphertext */
                                 &outBlockSize, /* length of ciphertext */
                                 NULL, /* our lparam for this program */
                                 0, /* lparam is 7 bytes long */
                                 NULL, /* PRNG state */
                                 prng_idx, /* prng idx */
                                 hash_idx,/* hash idx */
                                 LTC_LTC_PKCS_1_V1_5,
                                 &rsaPubKey) ;/* our RSA key */
        if(err != CRYPT_OK)
        {
            DDLogError("RSA encryption failed");
            rsa_free(&rsaPubKey);
            return nil;
        }
        outOffset += outBlockSize;
        offset += inputSize;
    }
    rsa_free(&rsaPubKey);
    return encData;
}

@end
