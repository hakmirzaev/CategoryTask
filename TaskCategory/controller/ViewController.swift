//
//  ViewController.swift
//  TaskCategory
//
//  Created by Bekhruz Hakmirzaev on 25/05/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var sub_category: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        configureTableView()
        fetchData()
    }
    
    // MARK: - Tree
    
    func makeTree(list: [Category]) -> [Category] {
        var categories = [Int: Category]() // Dictionary to store categories by ID
        var tree = [Category]() // Final result array

        for category in list {
            if let categoryId = category.id {
                categories[categoryId] = category
            }
        }

        for category in list {
            if let parentId = category.parentId {
                if parentId == 0 {
                    tree.append(category)
                } else {
                    if var parentCategory = categories[parentId] {
                        if parentCategory.childs == nil {
                            parentCategory.childs = [Category]()
                        }
                        parentCategory.childs?.append(category)
                    }
                }
            }
        }

        return tree
    }
    
    // MARK: - TableView
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        } // here, I used SnapKit for tableView constraints
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sub_category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Section: \(sub_category.count) Row: \(sub_category.count)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("cell tapped")
    }
    
    // MARK: - JSON data
    
    private func fetchData() {
        let jsonData = """
            {
              "category_list": {
                "count": 10000,
                "array": [
                  {
                    "id": 14,
                    "parent_id": 0,
                    "childs": null
                  },
                  {
                    "id": 127,
                    "parent_id": 14,
                    "childs": null
                  },
                  {
                    "id": 92,
                    "parent_id": 26,
                    "childs": null
                  },
                  ...
                ]
              }
            }
            """.data(using: .utf8)!
        
        do {
            let decodedData = try JSONDecoder().decode(CategoryList.self, from: jsonData)
            sub_category = makeTree(list: decodedData.array)
            tableView.reloadData()
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    struct CategoryList: Codable {
        var count: Int
        var array: [Category]
    }
    
}

// I tried my best to make this program work successfully but I couldn't understand task completely because it was not clear, so here is all works I did
