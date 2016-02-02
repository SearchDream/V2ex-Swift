//
//  NodeTableViewCell.swift
//  V2ex-Swift
//
//  Created by huangfeng on 2/2/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit


class NodeTableViewCell: UITableViewCell {
    /// 节点间的 间距
    static let nodeSpacing:CGFloat = 15
    /// 离屏幕左侧和右侧的 间距
    static let leftAndRightSpacing:CGFloat = 15
    
    static let fontSize:CGFloat = 15
    
    var labelArray:[UILabel] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .None
    }
    
    func getLabel(index:Int) -> UILabel{
        if index < labelArray.count {
            return labelArray[index]
        }
        
        let label = UILabel()
        label.font = v2Font(NodeTableViewCell.fontSize)
        label.textColor = V2EXColor.colors.v2_TopicListUserNameColor
        label.backgroundColor = UIColor.whiteColor()
        labelArray.append(label)
        self.contentView.addSubview(label)
        return label
    }
    func bind(nodes:[NodeModel]) {
        for var i = 0 ; i < nodes.count ; i++ {
            let node = nodes[i]
            let label = getLabel(i)
            label.hidden = false
            label.text = node.nodeName
            label.snp_remakeConstraints(closure: { (make) -> Void in
                if i == 0 {
                    make.left.equalTo(self.contentView).offset(NodeTableViewCell.leftAndRightSpacing)
                }
                else {
                    make.left.equalTo(getLabel(i-1).snp_right).offset(NodeTableViewCell.nodeSpacing)
                }
                make.centerY.equalTo(self.contentView)
                make.width.equalTo(node.width + 1)
            })
        }
        
        for var i = nodes.count ; i < labelArray.count ; i++ {
            labelArray[i].hidden = true
        }
    }
    
    


    /**
     获取节点数据布局
     
     - returns: 得到一个节点 占多少行 每行有哪些节点的二维数组
     */
    class func getShowRows(nodes:[NodeModel]) -> [[Int]] {
        
        var row = 1
        
        var rows:[[Int]] = []
        
        var tempWidth:CGFloat = 0
        for var i = 0 ;i < nodes.count ; i++ {
            
            if rows.count < row {
                rows .append([])
            }
            
            let node = nodes[i]
            if tempWidth == 0 {
                tempWidth += NodeTableViewCell.leftAndRightSpacing
            }
            
            if tempWidth + node.width + NodeTableViewCell.nodeSpacing > SCREEN_WIDTH - NodeTableViewCell.leftAndRightSpacing
                && tempWidth > NodeTableViewCell.leftAndRightSpacing {
                tempWidth = 0
                i--
                row++
                continue
            }
            
            rows[row-1].append(i)
            if i == 0 {
                tempWidth += node.width
            }
            else {
                tempWidth += node.width + NodeTableViewCell.nodeSpacing
            }
        }
        
        return rows
    }
}
