//
//  Array+SortMandarin.swift
//  SortMandarin
//
//  Created by 胡古斤 on 2016/5/21.
//  Copyright © 2017年 胡古斤. All rights reserved.
//

import UIKit

extension Array {
    
    
    
    /** 原数据分组 */
    static func HGJSortMandarin(srcArr: Array<String>) -> Array<Array<String>> {
        
        //创建空数组
        var tempArr = Array<Array<String>>()
        
        let localizedIndex = UILocalizedIndexedCollation.current()
        var titleArr = localizedIndex.sectionTitles
        //去＃号
        titleArr.removeLast()
        for _ in titleArr {
            let sectionArr = Array<String>()
            tempArr.append(sectionArr)
        }
        
        //根据首字母添加至对应区
        for mandarin in srcArr {
            let index = mandarin.HGJMandarinSection()
            tempArr[index].append(mandarin)
        }
        
        
        //移除没有数据的区,并添加至新数组
        var arcArr = Array<Array<String>>()
        for arr in tempArr {
            if arr.count != 0 {
                arcArr.append(arr)
            }
        }
        
        return arcArr
    }

    
    
    /** 根据分组数据获取标题 */
    static func HGJGetSectionTitleArr(srcArr: Array<Array<String>>) -> Array<String> {
        
        //遍历每个区，获取每个区数组里面的第一个元素，然后获取该元素的首字母
        
        //创建空数组
        var titleArr = Array<String>()
        
        //遍历数据源
        for arr in srcArr {
            //获取首字母
            let title = arr[0].HGJMandarinToInitial().substring(to: arr[0].index(after: arr[0].startIndex))
            titleArr.append(title)
        }
        
        return titleArr
    }
    
    
    
}


