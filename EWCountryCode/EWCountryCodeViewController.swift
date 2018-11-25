//
//  EWCountryCodeViewController.swift
//  EWCountryCode
//
//  Created by Ethan.Wang on 2018/11/14.
//  Copyright © 2018 Ethan. All rights reserved.
//

import UIKit

fileprivate func getCurrentLanguage() -> String {
    let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
    switch String(describing: preferredLang) {
    case "en-US", "en-CN":
        return "en"//英文
    case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
        return "cn"//中文
    default:
        return "en"
    }
}
class EWCountryCodeViewController: UIViewController {

    public var backCountryCode: ((String, String)->())?
    private var tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    private var searchController: UISearchController?
    private var sortedNameDict: Dictionary<String, Any>?
    private var indexArray: Array<String>?
    private var results: Array<Any> = Array()
    var ob: NSKeyValueObservation!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = isLanguageEnglish() ? "Country/Location" : "选择国家/地区"
        self.drawMyView()
        // Do any additional setup after loading the view.
    }
    private func drawMyView(){
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44.0
        tableView.backgroundColor = UIColor.clear
        tableView.autoresizingMask = .flexibleWidth
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.placeholder = "Search"
        let cancel: String = isLanguageEnglish() ? "Cancel" : "取消"
        searchController?.searchBar.setValue(cancel, forKey:"_cancelButtonText")
        tableView.tableHeaderView = searchController?.searchBar
        let sortedName = isLanguageEnglish() ? "sortedNameEN" : "sortedNameCH"
        let path = Bundle.main.path(forResource: sortedName, ofType: "plist")
        sortedNameDict = NSDictionary(contentsOfFile: path ?? "") as? Dictionary<String, Any>
        indexArray = Array(sortedNameDict!.keys).sorted(by: {$0 < $1})
    }

    
    func showCodeStringIndex(indexPath: NSIndexPath) -> String{
        var showCodeString: String = ""
        if searchController!.isActive{
            if results.count > indexPath.row{
                showCodeString = results[indexPath.row] as! String
            }
        }else{
            if indexArray!.count > indexPath.section{
                let sectionArray: Array<String> = sortedNameDict?[indexArray?[indexPath.section] ?? ""] as! Array<String>
                if sectionArray.count > indexPath.row{
                    showCodeString = sectionArray[indexPath.row]
                }
            }
        }
        return showCodeString
    }
    func selectCodeIndex(indexPath: IndexPath){
        let originText = self.showCodeStringIndex(indexPath: indexPath as NSIndexPath)
        let array = originText.components(separatedBy: "+")
        let countryName = array.first?.trimmingCharacters(in: CharacterSet.whitespaces)
        let code = array.last

        if self.backCountryCode != nil {
            self.backCountryCode!(countryName ?? "", code ?? "")
        }
        searchController?.isActive = false
        searchController?.searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

    private func isLanguageEnglish() -> Bool{
        return getCurrentLanguage() == "en" ? true : false
    }
    
}

extension EWCountryCodeViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if (searchController!.isActive) {
            return 1;
        } else {
            return sortedNameDict?.keys.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController!.isActive {
            return results.count
        }else {
            if indexArray!.count > section{
                let array: Array<String> = sortedNameDict?[indexArray![section]] as! Array<String>
                return array.count
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "identifier") else {
            return UITableViewCell()
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell.selectionStyle = .none
        cell.textLabel?.text = self.showCodeStringIndex(indexPath: indexPath as NSIndexPath)
        return cell
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexArray
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchController!.isActive ? 0 : 30
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if ((indexArray?.count) != nil) && indexArray!.count > section {
            return indexArray?[section]
        }
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectCodeIndex(indexPath: indexPath)
    }
}
extension EWCountryCodeViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if results.count > 0 {
            results.removeAll()
        }
        let inputText = searchController.searchBar.text
        let array: Array<Array<String>> = Array(sortedNameDict!.values) as! Array<Array<String>>
        for (_, obj) in array.enumerated() {
            for (_, obj) in obj.enumerated() {
                if obj.contains(inputText ?? ""){
                    self.results.append(obj)
                }
            }
        }
        tableView.reloadData()
    }
}
