//
//  ChecklistViewController.swift
//  Triplog
//
//  Created by 배수빈 on 6/12/25.
//

import UIKit

//
//  ChecklistViewController.swift
//  Triplog

import UIKit

class ChecklistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var checklistItems: [ChecklistItem] = []
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checklistItems = ChecklistManager.shared.load()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell", for: indexPath) as? ChecklistCell else {
            return UITableViewCell()
        }

        let item = checklistItems[indexPath.row]
        cell.checkButton.setImage(UIImage(systemName: item.isChecked ? "checkmark.square" : "square"), for: .normal)
        cell.checkButton.tintColor = .black
        cell.checkButton.configuration = nil // ✅ 배경 제거 (필요 시)
        updateStrikeThrough(for: cell.titleLabel, text: item.title, isChecked: item.isChecked)
        // 선택된 셀은 회색 배경, 아니면 흰색
        cell.backgroundColor = (indexPath == selectedIndexPath) ? UIColor.systemGray5 : UIColor.white

        cell.checkButton.tag = indexPath.row
        cell.checkButton.addTarget(self, action: #selector(toggleCheck(_:)), for: .touchUpInside)

        return cell
    }
    
    @objc func toggleCheck(_ sender: UIButton) {
        let index = sender.tag
        checklistItems[index].isChecked.toggle()
        ChecklistManager.shared.save(checklistItems)
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath  // 선택된 항목 추적
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            checklistItems.remove(at: indexPath.row)
            ChecklistManager.shared.save(checklistItems)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func addChecklistButtonTapped(_ sender: UIButton) {
        presentAddItemAlert()
    }
    
    @IBAction func deleteChecklistItemTapped(_ sender: UIButton) {
        guard let indexPath = selectedIndexPath else {
            showAlert(title: "삭제 오류", message: "삭제할 항목을 먼저 선택해주세요.")
            return
        }
        
        checklistItems.remove(at: indexPath.row)
        ChecklistManager.shared.save(checklistItems)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        selectedIndexPath = nil
    }
    
    
    private func presentAddItemAlert() {
        let alert = UIAlertController(title: "새 항목 추가", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "체크리스트 항목"
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "추가", style: .default, handler: { [weak self] _ in
            guard let self = self, let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            let newItem = ChecklistItem(title: text, isChecked: false)
            self.checklistItems.append(newItem)
            ChecklistManager.shared.save(self.checklistItems)
            self.tableView.insertRows(at: [IndexPath(row: self.checklistItems.count - 1, section: 0)], with: .automatic)
        }))
        present(alert, animated: true)
    }
    
    
    func updateStrikeThrough(for label: UILabel?, text: String, isChecked: Bool) {
        let attributes: [NSAttributedString.Key: Any] = isChecked ?
            [.strikethroughStyle: NSUnderlineStyle.single.rawValue,
             .foregroundColor: UIColor.lightGray] : [:]
        label?.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
