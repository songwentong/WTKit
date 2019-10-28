//
//  File.swift
//  
//
//  Created by 宋文通 on 2019/10/25.
//

import Foundation
import UIKit
// MARK: - UINibReusableCell
public protocol UINibReusableCell:NSObjectProtocol {
    static func nib() -> UINib
    static var reuseIdentifier: String{get}
}
public extension UINibReusableCell{
    //这段代码的神奇之处是到了这里已经无法打印self了，报错内容是：error: <EXPR>:1:11: error: use of undeclared type '$__lldb_context'
    static func nib() -> UINib {
        return UINib.init(nibName: self.reuseIdentifier, bundle: nil)
    }
    static var reuseIdentifier: String{
        return "\(self)"
    }
}

public extension UITableView{
    func registNibReuseableCell<T:UINibReusableCell>(_ cellType:T.Type) -> Void {
        register(cellType.nib(), forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    func registNibReuseableCell<T:UINibReusableCell>(_ cellType:T.Type, forHeaderFooterViewReuseIdentifier:String) -> Void {
        register(cellType.nib(), forHeaderFooterViewReuseIdentifier: cellType.reuseIdentifier)
    }
}
public extension UICollectionView{
    func registNibReuseableCell<T:UINibReusableCell>(_ cellType:T.Type) -> Void {
        let nib = cellType.nib()
        let rid = cellType.reuseIdentifier
        register(nib, forCellWithReuseIdentifier: rid)
    }
}
public protocol UITableViewModel {
    var sections:[UITableViewSectionModel]{get set}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}
public protocol UITableViewSectionModel {
    var cells:[UITableViewCellModel]{get set}
}
public protocol UITableViewCellModel{
    var reuseIdentifier:String{get set}
}
public protocol UITableViewCellDetailModel:UITableViewCellModel {
    var height:CGFloat{get}
    var didSelectAction:DispatchWorkItem?{get}
    var willDisplayAction:DispatchWorkItem?{get}
    var prefetchAction:DispatchWorkItem?{get}
    var cancelPrefetchingAction:DispatchWorkItem?{get}
}
public protocol UICollectionViewCellModel {
    var reuseId:String{get set}
}
public protocol UICollectionViewCellDetailModel:UICollectionViewCellModel{
    var size:CGSize?{get}
    var didSelectAction:DispatchWorkItem?{get}
    var willDisplayAction:DispatchWorkItem?{get}
    var prefetchAction:DispatchWorkItem?{get}
    var cancelPrefetchingAction:DispatchWorkItem?{get}
}
public protocol UICollectionViewSectionModel{
    var cells:[UICollectionViewCellModel]{get set}
}
public protocol UICollectionViewModel{
    var sections:[UICollectionViewSectionModel]{get set}
}
public protocol UITableViewCellModelHolder {
    var model:UITableViewCellModel?{get set}
}
public protocol UICollectionViewCellModelHolder {
    var model:UICollectionViewCellModel!{get set}
}
public extension UITableView{
    func dequeueReusableCellModel(withModel model:UITableViewCellModel, for indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: model.reuseIdentifier, for: indexPath)
        if var c = cell as? UITableViewCellModelHolder{
            c.model = model
        }
        return cell
    }
}
public extension UICollectionView{
    func dequeueReusableCellModel(withModel model:UICollectionViewCellModel, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: model.reuseId, for: indexPath)
        if var c = cell as? UICollectionViewCellModelHolder{
            c.model = model
        }
        return cell
    }
}
// MARK: - ModelSample
open class UITableViewModelSample:NSObject, UITableViewModel,UITableViewDataSource,UITableViewDelegate,UITableViewDataSourcePrefetching{
    public var sections: [UITableViewSectionModel] = {
        let list = [UITableViewSectionModel]()
        return list
    }()
    public func appendSection(_ section:UITableViewSectionModel) {
        sections.append(section)
    }
    public func appendSectionWithClosure(with closure:()->UITableViewSectionModel){
        appendSection(closure())
    }
    public func appendCellModelToLastSection(_ model:UITableViewCellModel) {
        guard var last = sections.last else{
            return
        }
        last.cells.append(model)
    }
    public func appendCellDetailModelToLastSectionWithClosure(_ closure:()->UITableViewCellModel){
        appendCellModelToLastSection(closure())
    }
    
    
    // MARK: - UITableViewDataSource
    open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        let cell = tableView.dequeueReusableCellModel(withModel: model, for: indexPath)
        return cell
    }
    public func model(for indexPath:IndexPath) -> UITableViewCellModel {
        return sections[indexPath.section].cells[indexPath.row]
    }
    // MARK: - UITableViewDelegate
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let m = model(for: indexPath) as? UITableViewCellDetailModel{
            m.willDisplayAction?.perform()
        }
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let m = model(for: indexPath) as? UITableViewCellDetailModel{
            m.didSelectAction?.perform()
        }
    }
    // MARK: - UITableViewDataSourcePrefetching
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]){
        for indexPath in indexPaths{
            if let m = model(for: indexPath) as? UITableViewCellDetailModel{
                m.prefetchAction?.perform()
            }
        }
    }
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let m = model(for: indexPath) as? UITableViewCellDetailModel{
                m.cancelPrefetchingAction?.perform()
            }
        }
    }
}
// MARK: - UITableViewSectionModelSample
open class UITableViewSectionModelSample:NSObject,UITableViewSectionModel{
    public var cells: [UITableViewCellModel] = {
        let list = [UITableViewCellModel]()
        return list
    }()
    public func appendCell(_ model:UITableViewCellModel) {
        cells.append(model)
    }
}
// MARK: - UITableViewCellModelSample
open class UITableViewCellModelSample:NSObject,UITableViewCellModel{
    public var reuseIdentifier: String = "cell"
}
// MARK: - UITableViewCellDetailModelSample
open class UITableViewCellDetailModelSample:NSObject,UITableViewCellDetailModel {
    public var willDisplayAction: DispatchWorkItem?
    public var prefetchAction: DispatchWorkItem?
    public var cancelPrefetchingAction: DispatchWorkItem?
    public var reuseIdentifier:String = ""
    public var height:CGFloat = 44
    public var didSelectAction:DispatchWorkItem?
    public override init() {
        super.init()
    }
    public init(reuseIdentifier: String, height: CGFloat = 44, didSelectAction:@escaping ()->Void){
        super.init()
        self.reuseIdentifier = reuseIdentifier
        self.height = height
        self.didSelectAction = DispatchWorkItem.init(block: didSelectAction)
    }
}
// MARK: - UITableViewSample
open class UITableViewSample:UITableView{
    open var sample:UITableViewModelSample = UITableViewModelSample()
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        config()
    }
    func config() {
        dataSource = sample
        delegate = sample
        if #available(iOS 10.0, *) {
            prefetchDataSource = sample
        } else {
            // Fallback on earlier versions
        }
    }
}
// MARK: - UICollectionViewModelSample
open class UICollectionViewModelSample:NSObject,UICollectionViewModel,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    public var sections: [UICollectionViewSectionModel] = []
    open func addSection(with section:UICollectionViewSectionModel) {
        sections.append(section)
    }
    open func addSectionwithClosure(with closure:()->UICollectionViewSectionModel) {
        sections.append(closure())
    }
    open func addItemToLastSection(with cell:UICollectionViewCellModel) {
        guard var last = sections.last else{
            return
        }
        last.cells.append(cell)
    }
    open func addItemToLastSectionWithClosure(with closure:()->UICollectionViewCellModel) {
        addItemToLastSection(with: closure())
    }
    open func model(for indexPath:IndexPath) -> UICollectionViewCellModel? {
        return sections[indexPath.section].cells[indexPath.row]
    }
    // MARK: - UICollectionViewDataSource
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = self.model(for: indexPath) else {
            return UICollectionViewCell.init()
        }
        return collectionView.dequeueReusableCellModel(withModel: model, for: indexPath)
    }
    // MARK: - UICollectionViewDelegate
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        guard let model = self.model(for: indexPath) as? UICollectionViewCellDetailModel else {
            return
        }
        model.willDisplayAction?.perform()
    }
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        guard let model = self.model(for: indexPath) as? UICollectionViewCellDetailModel else {
            return
        }
        model.didSelectAction?.perform()
    }
    // MARK: - UICollectionViewDelegateFlowLayout
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        guard let model = self.model(for: indexPath) as? UICollectionViewCellDetailModel else {
            return .init(width: 50, height: 50)
        }
        guard let size = model.size else{
            return .init(width: 50, height: 50)
        }
        return size
    }
}
open class UICollectionViewSectionModelSample:UICollectionViewSectionModel{
    public var cells: [UICollectionViewCellModel] = []
    open func addItemToLastSection(with cell:UICollectionViewCellModel) {
        cells.append(cell)
    }
    open func addItemToLastSectionWithClosure(with closure:()->UICollectionViewCellModel) {
        addItemToLastSection(with: closure())
    }
}
