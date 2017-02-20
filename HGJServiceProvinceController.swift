//
//  HGJServiceProvinceController.swift
//  club
//
//  Created by 胡古斤 on 16/8/20.
//  Copyright © 2016年 lvfm. All rights reserved.
//

import UIKit
import SwiftyJSON

class HGJServiceProvinceController: UITableViewController {

    // MARK: - Property
    
    /** var份列表 */
    var tableArr = Array<Array<String>>()
    
    
    
    
    //MARK: - DesignedInitial
    
    /*swift 加载xib进行实例化的方法*/
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    convenience init() {
    
        self.init(nibName: nil, bundle: nil)
    
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*swift 加载xib进行实例化的方法*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择省份"
        
        //设置侧标题
        self.tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        self.tableView.sectionIndexColor = UIColor.blackColor()
        
        self.tabBarController?.tabBar.hidden = true
        
        //请求省接口
        self.requestProvinceList()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.tableArr.count;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tableArr[section].count;
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = self.tableArr[indexPath.section][indexPath.row]
        cell?.accessoryType = .DisclosureIndicator
        
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let serviceCityVc = HGJServiceCityController()
        serviceCityVc.province = tableArr[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(serviceCityVc, animated: true)
    }
    
    //区标题
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.getTitleArray(self.tableArr)[section]
    }
    
    
    //表视图右侧导航标题
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        return self.getTitleArray(self.tableArr)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - RequestInterface
    
    /** 获取省列表 */
    func requestProvinceList()
    {
        
        let updata = zyk_upDic()
        let json = updata.getJson()
        
        //HUD
        let wait = NDProgress().show((UIApplication.sharedApplication().windows.first!.currentViewController?.view)!)
        wait.hide(10)
        
        zyk_net.nodeServer(ND_PubData.get("NodeServer") as! String, funcName: "shengfenliebiao", key:ND_PubData.get("随机码") as! String, json: json, completion: { (data, response) in dispatch_sync(dispatch_get_main_queue(),{
            
            let responseJson = JSON(data: data!)
            if responseJson["状态"].stringValue == "成功" {
                wait.hide(0)

                
                //添加数据至临时数组
                var tempArr = Array<String>()
                for index in 0..<responseJson["省级列表"].arrayValue.count {
                    let province = responseJson["省级列表"].arrayValue[index]["省份"].stringValue
                    tempArr.append(province)
                }

                //排序
                self.tableArr = self.sortProvince(tempArr)
                
                //刷新列表
                self.tableView.reloadData()
                
            }else {
                self.ShowMyAlertController(responseJson["状态"].stringValue)
            }
        })
        }) { (err) in
            dispatch_sync(dispatch_get_main_queue(), {
                
                wait.hide(5)
                let alert = NDAlertController(title: "提示", details: "请检查您的网络是否正常!", cancleBtn: "好的", btnStyle: BtnStyle.Cancle)
                alert.show(self)
                
                
            })
        }
        
    }

    
    
    
    
    
    

    
    
    
    
    
    // MARK : - PrivateFunctions
    
    
    /** 原数据分组 */
    private func sortProvince(srcArr: Array<String>) -> Array<Array<String>> {
        
        //创建空数组
        var tempArr = Array<Array<String>>()
        
        let localizedIndex = UILocalizedIndexedCollation.currentCollation()
        var titleArr = localizedIndex.sectionTitles
            //去＃号
        titleArr.removeLast()
        for _ in titleArr {
            let sectionArr = Array<String>()
            tempArr.append(sectionArr)
        }
        
        //根据首字母添加至对应区
        for province in srcArr {
            let mandarin = self.firstCharactor(province)
            let firstCh = (mandarin as NSString).characterAtIndex(0)
            let index = firstCh.hashValue - 65
            tempArr[index].append(province)
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
    private func getTitleArray(tableArray: Array<Array<String>>) -> Array<String> {
        
        //遍历每个区，获取每个区数组里面的第一个元素，然后获取该元素的首字母
        
        //创建空数组
        var titleArr = Array<String>()
        
        //遍历数据源
        for arr in tableArray {
            //获取首字母
            let title = (self.firstCharactor(arr[0]) as NSString).substringToIndex(1)
            titleArr.append(title)
        }
        
        return titleArr
    }
    
    
    
    /** 汉字转拼音 */
    private func firstCharactor(chString: String) -> String{
    
        //转成可变字符串
        let str = NSMutableString.init(string: chString)
        //先转换为带声调的拼音
        CFStringTransform(str as CFMutableStringRef, nil, kCFStringTransformMandarinLatin, false)
        //再转换为不带声调的拼音
        CFStringTransform(str as CFMutableStringRef, nil, kCFStringTransformStripDiacritics, false)
        //首字母转化为大写
        return str.capitalizedString
//        return (pinYin as NSString).characterAtIndex(0)
    }
    
    
    private func ShowMyAlertController(info:String){
        
        let alert = NDAlertController(icon: UIImage(named: "nd_alert_warn")!, title: "", details:info)
        alert.addButton("确定", style: BtnStyle.Ok, action: {
            
        })
        
        alert.show(self)
        
    }
    
}
