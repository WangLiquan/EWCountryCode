# EWCountryCode
一个选择国家/地区获取区号的控制器
----

# 实现功能：
* 中英文双语，根据系统语言获取不同源内容，以及不同的提示语言。
* 通过闭包回调，点击后将选中国家和区号以不同字段回调。
* 带有SearchBar,实现即时搜索功能。

# 调用方法：
```
let vc = EWCountryCodeViewController()
vc.backCountryCode = { [weak self] country, code in
    self?.showCountryLabel.text = country
    self?.showCodeLabel.text = code
}
self.navigationController?.pushViewController(vc, animated: true)
```

![效果图预览](https://github.com/WangLiquan/EWCountryCode/raw/master/images/demonstration.gif)

