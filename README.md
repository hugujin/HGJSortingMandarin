# HGJSortingMandarin
中文排序后按姓氏分为二维数组
##1.将文件两个扩展文件拖入项目中
##2.在控制器中输入
```obj       
        let arr = ["张三", "李四", "王五", "赵六"]
        
        let newArr = Array<Any>.HGJSortMandarin(srcArr: arr)
        
        print(newArr)
        
        
        let titleArr = Array<Any>.HGJGetSectionTitleArr(srcArr: newArr)
        
        print(titleArr) 
 ```
 
##3.打印效果如下

 ![](https://thumbnail0.baidupcs.com/thumbnail/cbf8bc5b6b574ea6b1960309a8db9181?fid=1649281771-250528-170369071869266&time=1487584800&rt=sh&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-8lCZOYqNfyOp2QMHpQiu0WBZe4E%3D&expires=8h&chkv=0&chkbd=0&chkpc=&dp-logid=1177307431645181158&dp-callid=0&size=c710_u400&quality=100)
