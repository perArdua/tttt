//
//  GeneralPostingSearchViewController.swift
//  CapstonDesign
//
//  Created by 이동현 on 2023/04/09.
//

import UIKit
import Lottie

class GeneralPostingSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var manager = PostingManager()
    var array :[GeneralPostingContent] = []
    var searcharry :[GeneralPostingContent] = []
    
    
    let tempLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.text = "검색 결과가 없습니다."
        label.textAlignment = .center
        return label
    }()
    
    var animationView: LottieAnimationView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tempLabel.isHidden = false
        tempLabel.frame = CGRect(x: view.frame.size.width/2-75, y: view.frame.size.height/2, width: 150, height: 60)
        animationView?.frame = CGRect(x: view.frame.size.width/2-50, y: view.frame.size.height/2, width: 100, height: 100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        array = manager.getPostings()
        view.addSubview(tempLabel)
        
        animationView = .init(name: "loading_check")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 1
        view.addSubview(animationView!)
        animationView!.isHidden = true
    }

    // MARK: - 검색 버튼 누를때 동작
    
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "알림", message: "두 글자 이상 입력해주세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        guard let keyword = searchTF.text else{
            present(alert, animated: true)
            return
        }
        if keyword.count < 2 {
            present(alert, animated: true)
            return
            
        }
        animationView!.isHidden = false
        animationView!.play()
        tempLabel.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.searchPosting(keyword: keyword)
         }
    }
    
    func searchPosting(keyword: String){
        searcharry = []
    
        for i in 0..<array.count{
            if array[i].title.contains(keyword) || array[i].content.contains(keyword){
                tempLabel.isHidden = true
                searcharry.append(array[i])
            }
        }

        //검색된 게시글이 없는 경우
        if searcharry.count == 0{
            animationView!.stop()
            animationView!.isHidden = true
            tempLabel.isHidden = false
        }
        //검색된 게시글이 있는 경우
        else{
            animationView!.stop()
            animationView!.isHidden = true
            tempLabel.isHidden = true
        }
        tableView.reloadData()
    }
}
    



extension GeneralPostingSearchViewController : UITableViewDelegate, UITableViewDataSource{
    
    //테이블 뷰에 몇개의 셀을 보여줄 것인지 결정하는 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count:\(searcharry.count)")
        return searcharry.count
    }
    
    //각 테이블 뷰 셀의 내용을 결정하는 함수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralSearchTableViewCell", for: indexPath) as! GeneralSearchTableViewCell
        
        let temp = searcharry[indexPath.row]
        
        cell.titleLabel.text = temp.title
        cell.contentLabel.text = temp.content
        cell.dateLabel.text = temp.date
        cell.userLabel.text = temp.user
        cell.commentLabel.text = "5"

        return cell
    }
    
    //테이블 뷰 셀이 클릭되면 어떤 동작을 할지 정하는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "GeneralPostingDetailViewController") as? GeneralPostingDetailViewController else { return }
        nextVC.postingIndex = indexPath.row
                self.navigationController?.pushViewController(nextVC, animated: true)
    }
}