//
//  String+ChangeMandarinToEnglish.swift
//  SortMandarin
//
//  Created by 胡古斤 on 2016/5/21.
//  Copyright © 2017年 胡古斤. All rights reserved.
//

import Foundation


extension String {
    
    
    /** 汉字转首字母大写的拼音 */
    public func HGJMandarinToInitial() -> String{
        
        //转成可变字符串
        let str = NSMutableString.init(string: self)
        //先转换为带声调的拼音
        CFStringTransform(str as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
        //再转换为不带声调的拼音
        CFStringTransform(str as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
        //首字母转化为大写
        return str.capitalized
    }
    
    
    /** 获取中文排序后所在区 */
    public func HGJMandarinSection() -> Int {
        
        let str = self.HGJMandarinToInitial()
        let unichar = (str as NSString).character(at: 0)
        return Int(unichar - 65)
    }
    
    
    
}
