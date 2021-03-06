//
//  LogInViewController.swift
//  com.work.with.filemanager
//
//  Created by v.milchakova on 05.05.2021.
//

import UIKit

let account = "myAccount"

class LogInViewController: UIViewController {
    private let basePadding: CGFloat = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(errorLabel)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(logInButton)
        setConstraints()

        defaults.removeObject(forKey: "newPassword")
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            errorLabel.heightAnchor.constraint(equalToConstant: 50),
            errorLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            errorLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:basePadding),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -50),
            passwordTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:basePadding),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        if defaults.value(forKey: "newPassword") == nil && KeyChain.load(key: account) != nil {
            logInButton.setTitle("?????????????? ????????????", for: .normal)
            NSLayoutConstraint.activate([
                logInButton.heightAnchor.constraint(equalToConstant: 50),
                logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: basePadding),
                logInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: basePadding),
                logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                logInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        } else {
            logInButton.setTitle("?????????????? ????????????", for: .normal)
            contentView.addSubview(confirmTextField)
            
            NSLayoutConstraint.activate([
                confirmTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: basePadding),
                confirmTextField.centerXAnchor.constraint(equalTo: passwordTextField.centerXAnchor),
                confirmTextField.heightAnchor.constraint(equalToConstant: 50),
                confirmTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
                confirmTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
                
                logInButton.heightAnchor.constraint(equalToConstant: 50),
                logInButton.topAnchor.constraint(equalTo: confirmTextField.bottomAnchor, constant: basePadding),
                logInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: basePadding),
                logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                logInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        let _ = KeyChain.remove(key: "tempPass")
        let _ = KeyChain.remove(key: "confirmPass")
        passwordTextField.text = ""
        confirmTextField.text = ""
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.toAutoLayout()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.toAutoLayout()
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .systemGray6
        field.isSecureTextEntry = true
        field.textColor = .black
        field.layer.cornerRadius = 10
        field.placeholder = "????????????"
        field.font = UIFont.systemFont(ofSize: 20)
        
        let paddingView: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 20, height: 50))
        field.leftView = paddingView
        field.leftViewMode = .always

        field.toAutoLayout()
        return field
    }()
    
    private lazy var confirmTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .systemGray6
        field.isSecureTextEntry = true
        field.textColor = .black
        field.layer.cornerRadius = 10
        field.placeholder = "??????????????????????????"
        field.font = UIFont.systemFont(ofSize: 20)
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        field.leftView = paddingView
        field.leftViewMode = .always

        field.toAutoLayout()
        return field
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var logInButton: UIButton = {
        let logInButton = UIButton(type: .system)
        logInButton.setTitleColor(.gray, for: .normal)
        logInButton.layer.cornerRadius = 10
        logInButton.layer.masksToBounds = false
        logInButton.clipsToBounds = true
        logInButton.backgroundColor = .cyan
        logInButton.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        logInButton.addTarget(self, action: #selector(loginButtonPressed), for:.touchUpInside)
        logInButton.toAutoLayout()
        return logInButton
    }()
    
    @objc func loginButtonPressed() {
        print("???????????? ???????????? ????????????")
        if let pass = passwordTextField.text, let confirm = confirmTextField.text {
            let loginButtonText = logInButton.titleLabel?.text
            if loginButtonText == "?????????????? ????????????" {
                if checkAccount(pass: pass) {
                    navigationController?.pushViewController(Tabbar(), animated: true)
                    return
                } else {
                    errorLabel.text = "?????????????????????? ???? ??????????????, ???????????????????? ?????? ??????"
                    return
                }
            }
            if loginButtonText == "?????????????? ????????????" || loginButtonText == "?????????????????? ????????????" {
                if pass.isEmpty || confirm.isEmpty {
                    errorLabel.text = "?????????????????? ???????????? ?? ??????????????????????????"
                    return
                }
                if pass.count != 4 || confirm.count != 4 {
                    errorLabel.text = "???????????? ?? ?????????????????????????? ???????????? ?????????????????? 4 ??????????????"
                    return
                }
                if !checkPassAndConfirm() {
                    errorLabel.text = "???????????? ?? ?????????????????????????? ???? ??????????????????"
                    return
                }
                if checkPassAndConfirm() {
                    navigationController?.pushViewController(Tabbar(), animated: true)
                }
            }
        }
    }
    
    func checkAccount(pass: String) -> Bool {
        guard let accountPass = KeyChain.load(key: account) else {
            print("?????????????? ???? ????????????")
            return false
        }
        let accountPassword = String(decoding: accountPass, as: UTF8.self)
        print("??????????????????, ????????????: \(accountPassword)")
        return accountPassword  == pass
    }
    
    func checkPassAndConfirm() -> Bool {
        
        savePassword(text: passwordTextField.text)
        saveConfirm(text: confirmTextField.text)
        
        guard let pass1 = KeyChain.load(key: "tempPass") else {
            print("???? ???????????? ?????????????????? ????????????")
            return false
        }
        
        guard let conf1 = KeyChain.load(key: "confirmPass") else {
            print("???? ?????????????? ??????????????????????????")
            return false
        }
        
        let tempPass = String(decoding: pass1, as: UTF8.self)
        let confirm = String(decoding: conf1, as: UTF8.self)
        
        if tempPass == confirm {
            let _ = KeyChain.save(key: account, data: tempPass.data(using: .utf8)!)
            let _ = KeyChain.remove(key: "tempPass")
            let _ = KeyChain.remove(key: "confirmPass")
            print("???????????? ????????????")
            return true
        }
        errorLabel.text = "???????????? ?? ?????????????????????????? ???? ??????????????????"
        return false
    }
    
    func saveConfirm(text: String?) {
        guard let conf = text, conf.count == 4 else {
            print("?????? ??????????????????????????")
            return
        }
        let _ = KeyChain.save(key: "confirmPass", data: conf.data(using: .utf8)!)
        print("?????????????????? ??????????????????????????")
    }
    
    func savePassword(text: String?) {
        guard let pass = text, pass.count == 4 else {
            print("?????? ????????????")
            return
        }
        let _ = KeyChain.save(key: "tempPass", data: pass.data(using: .utf8)!)
        logInButton.setTitle("?????????????????? ????????????", for: .normal)
        print("?????????????????? ????????????")
    }
}

extension UIImage {
    func alpha(_ value: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
