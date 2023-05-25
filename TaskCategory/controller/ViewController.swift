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
    
//    func makeTree(list: [Category]) -> [Category] {
//        var categories = [Int: Category]() // Dictionary to store categories by ID
//        var tree = [Category]() // Final result array
//
//        // Step 1: Create dictionary of categories
//        for category in list {
//            if let categoryId = category.id {
//                categories[categoryId] = category
//            }
//        }
//
//        // Step 2 and 3: Build the tree structure
//        for category in list {
//            if let parentId = category.parentId {
//                if parentId == 0 {
//                    tree.append(category)
//                } else {
//                    if var parentCategory = categories[parentId] {
//                        if parentCategory.childs == nil {
//                            parentCategory.childs = [Category]()
//                        }
//                        parentCategory.childs?.append(category)
//                    }
//                }
//            }
//        }
//
//        return tree
//    }
    
    func makeTree(list: [Category]) -> [Category] {
        var tree: [Category] = []
        var lookup: [Int: Category] = [:]

        for category in list {
            if let parentId = category.parentId, parentId != 0 {
                if var parent = lookup[parentId] {
                    parent.childs?.append(category)
                } else {
                    lookup[parentId] = Category(id: parentId, parentId: nil, childs: [category])
                }
            } else {
                tree.append(category)
            }
            lookup[category.id!] = category
        }

        return tree
    }
    
    var list = [
        Category(id: 14, parentId: 0, childs: nil),
        Category(id: 127, parentId: 14, childs: nil),
        Category(id: 92, parentId: 26, childs: nil),
        Category(id: 15, parentId: 0, childs: nil),
        Category(id: 128, parentId: 15, childs: nil),
        Category(id: 93, parentId: 18, childs: nil)
    ]
    
    //    func makeTree(list: list)
    //    print(tree)
    
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

