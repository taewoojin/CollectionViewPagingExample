//
//  ViewController.swift
//  CollectionViewPagingExample
//
//  Created by 진용호 on 2018. 7. 18..
//  Copyright © 2018년 진용호. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let itemColors = [UIColor.red, UIColor.yellow, UIColor.blue, UIColor.green]
    
    var currentIndex: CGFloat = 0
    
    let lineSpacing: CGFloat = 20
    
    let cellRatio: CGFloat = 0.7
    
    var isOneStepPaging = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // width, height 설정
        let cellWidth = floor(view.frame.width * cellRatio)
        let cellHeight = floor(view.frame.height * cellRatio)
        
        // 상하, 좌우 inset value 설정
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = .horizontal
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 스크롤 시 빠르게 감속 되도록 설정
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = itemColors[indexPath.row]
        cell.alpha = 0.5
        return cell
    }
    
}

extension ViewController : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if isOneStepPaging {
            if currentIndex > roundedIndex {
                currentIndex -= 1
                roundedIndex = currentIndex
            } else if currentIndex < roundedIndex {
                currentIndex += 1
                roundedIndex = currentIndex
            }
        }
        
        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

