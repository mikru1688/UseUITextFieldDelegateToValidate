//
//  ViewController.swift
//  UseUITextFieldDelegateToValidate
//
//  Created by Frank.Chen on 2017/1/15.
//  Copyright © 2017年 Frank.Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        // 身份證號
        let idLbl: UILabel = UILabel()
        idLbl.frame = CGRect(x: 0, y: 40, width: self.view.frame.size.width / 3, height: 50)
        idLbl.font = UIFont.systemFont(ofSize: 20)
        idLbl.textColor = UIColor.black
        idLbl.textAlignment = NSTextAlignment.left
        idLbl.adjustsFontSizeToFitWidth = true
        idLbl.text = "\t" + "身份證號："
        self.view.addSubview(idLbl)
        
        // 身份證輸入框
        let idTxtFld: UITextField = UITextField()
        idTxtFld.frame = CGRect(x: idLbl.frame.origin.x + idLbl.frame.size.width, y: 40, width: self.view.frame.size.width / 3 * 2, height: 50)
        idTxtFld.font = UIFont.systemFont(ofSize: 20)
        idTxtFld.backgroundColor = UIColor.clear
        idTxtFld.textAlignment = NSTextAlignment.left
        idTxtFld.clearButtonMode = UITextFieldViewMode.unlessEditing // 清除按鈕
        idTxtFld.placeholder = "請輸入證件號碼"
        idTxtFld.delegate = self
        self.view.addSubview(idTxtFld)
        
        // 註冊tab事件，點選瑩幕任一處可關閉瑩幕小鍵盤
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    // MARK: - Delegate
    // ---------------------------------------------------------------------
    // 關閉瑩幕小鍵盤
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // 當按下右下角的return鍵時觸發
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 關閉鍵盤
        return true
    }
    
    // 設定欄位是否可以清除
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    // onChange事件
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("textField.text: \(textField.text!)")
        print("range: \(range.location)")
        print("string: \(string)")
        print("")
        
        // 不能輸入空白
        if string.isContainsSpaceCharacters() {
            return false
        }
        
        // 不能輸入中文字
        if string.isContainsChineseCharacters() {
            return false
        }
        
        // 第一個字轉大寫
        if range.location == 0 {
            textField.text = string.substring(from: 0, to: 1).uppercased() + string.substring(from: 1).lowercased()
            return false
        }
        
        // 長度不得大於10
        if (range.location > 9 || (textField.text?.characters.count)! + string.characters.count > 10) {
            return false
        }
        
        return true
    }

}

// MARK: - 字串類別延伸
extension String {
    // 是否含有中文字元
    func isContainsChineseCharacters() -> Bool {
        for scalar in self.unicodeScalars {
            if scalar.value >= 19968 && scalar.value <= 171941 {
                return true
            }
        }
        return false
    }
    
    // 是否含有空白字元
    func isContainsSpaceCharacters() -> Bool {
        for scalar in self.unicodeScalars {
            if scalar.value == 32 {
                return true
            }
        }
        return false
    }
    
    func substring(from: Int, to: Int) -> String {
        guard from >= 0 && from < self.characters.count else { return "" }
        let range: Range = self.characters.index(self.startIndex, offsetBy: from <= self.characters.count ? from : self.characters.count) ..< self.characters.index(self.startIndex, offsetBy: to <= self.characters.count ? to : self.characters.count)
        return self[range]
    }
    
    func substring(from: Int) -> String {
        guard from >= 0 && from < self.characters.count else { return "" }
        let fromIndex = self.characters.index(self.startIndex, offsetBy: from)
        return self.substring(from: fromIndex)
    }
}
