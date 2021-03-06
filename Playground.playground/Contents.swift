
import UIKit

extension String {
    
    func toHexadecimalString() -> String {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        return data!.toHexadecimalString()
    }
    
    func xor(withHexString hexString: String) -> String {
        
        var result = [UInt8]()
        
        let text = self.asByteArray()
        let cipher = hexString.asByteArray()
        
        for (index, character) in text.enumerated() {
            result.append(character ^ cipher[index])
        }
        
        return result.toHexadecimalString()
    }
    
    func asByteArray() -> Array<UInt8> {
        
        var arrayLength: Int = self.utf16.count
        var hexString = self
        
        if arrayLength % 2 != 0 {
            hexString  = "0" + hexString
            arrayLength += 1
        }
        
        arrayLength = arrayLength / 2
        
        var buffer: Array<UInt8> = Array(repeating: 0 , count: arrayLength)
        for index: Int in 0  ..< arrayLength  {
            let substring: String = (hexString as NSString).substring(with: NSRange(location: 2 * index, length: 2))
            buffer[index] = UInt8(substring, radix: 16)!
        }
        return buffer
    }
    
    func toAscii() -> String {
        
        var chars = [Character]()
        
        for character in self.characters {
            chars.append(character)
        }
        
        let numbers = stride(from: 0, to: chars.count, by: 2).map {
            strtoul(String(chars[$0 ..< $0+2]), nil, 16)
        }
        
        var final = ""
        var i = 0
        
        while i < numbers.count {
            final.append(Character(UnicodeScalar(Int(numbers[i]))!))
            i += 1
        }
        
        return final
    }
}

extension Sequence where Iterator.Element == UInt8 {
    
    func toHexadecimalString() -> String {
        
        var byteArrayHexadecimalString = String()
        
        for value in self {
            byteArrayHexadecimalString = byteArrayHexadecimalString + (NSString(format: "%02x", value) as String)
        }
        
        return byteArrayHexadecimalString
    }
}

func performDragging(withCipherText cipherText1: String, cipherText2: String, cipher: String, message: String) {
    
    print("\n----------------- Cipher Length: \(cipher.characters.count)")
    print("----------------- \(message) \n")
    
    let cipher = cipher.toHexadecimalString()
    var cipher1 = "\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)\(cipher)"
    
    let xorCipherText = cipherText1.xor(withHexString: cipherText2)
    
    for (index, _) in cipher.characters.enumerated() {
        
        let result = xorCipherText.xor(withHexString: cipher1)
        
        print("\(index): \(result.toAscii())")
        
        cipher1.remove(at: cipher1.startIndex)
    }
}

var cipherTexts = [String]()
cipherTexts.append("4de61dd9dab5e0701f5e664ff522de12bd588051da4d3f62df3c3303e696139af0280308f5720d5e45efaa03bc6d37d84294")
cipherTexts.append("06b25cded0e2fb74045f681bd4378a5bba10901fd6513b2cc0343c0aa3c6138df02d1f46e63a090d07f3b602bc653bcd5ad1")
cipherTexts.append("00fa5890c4f0e062175d2348bd30c25dbb44c951c0503f6fd83d3114b28e1390b4611146e53a091c45f8bc01f56f2ac1459f")
cipherTexts.append("07be1dc2ccf8fc67131a3355f326c957ba438403cc03362adf213b14b5ca5290b537155aa1680d0b54eff916bc7e3fcc06d1")
cipherTexts.append("15fc5990c1f4e574565b665cf22cce12ac5e8a04d24b7a3dca3b3a09abc60191a533134da17c070c07eeb803fd207efc4294")
cipherTexts.append("54f552dccdb5fd64115d234fbd2ad912eb7d841fc142372adc3c324684871599b92f0340ee68065c09000000000000000000")

let cipher = "r anywhere. It is uncrackable as long as you keep"

for i in 0..<6 {
    
    let cipherText1 = cipherTexts[i]
    
    performDragging(withCipherText: cipherText1, cipherText2: cipherTexts[0], cipher: cipher, message: "Using cipherText\(i) & cipherText0")
    performDragging(withCipherText: cipherText1, cipherText2: cipherTexts[1], cipher: cipher, message: "Using cipherText\(i) & cipherText1")
    performDragging(withCipherText: cipherText1, cipherText2: cipherTexts[2], cipher: cipher, message: "Using cipherText\(i) & cipherText2")
    performDragging(withCipherText: cipherText1, cipherText2: cipherTexts[3], cipher: cipher, message: "Using cipherText\(i) & cipherText3")
    performDragging(withCipherText: cipherText1, cipherText2: cipherTexts[4], cipher: cipher, message: "Using cipherText\(i) & cipherText4")
    performDragging(withCipherText: cipherText1, cipherText2: cipherTexts[5], cipher: cipher, message: "Using cipherText\(i) & cipherText5")
}
