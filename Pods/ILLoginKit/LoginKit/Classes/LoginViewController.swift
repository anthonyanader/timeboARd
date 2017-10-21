//
//  LoginViewController.swift
//  LoginKit
//
//  Created by Daniel Lozano Valdés on 12/8/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import UIKit
import Validator

protocol LoginViewControllerDelegate: class {

    func didSelectLogin(_ viewController: UIViewController, email: String, password: String)

    func didSelectForgotPassword(_ viewController: UIViewController)

    func loginDidSelectBack(_ viewController: UIViewController)

}

class LoginViewController: UIViewController, BackgroundMovable, KeyboardMovable {

    // MARK: - Properties

    weak var delegate: LoginViewControllerDelegate?

    weak var configurationSource: ConfigurationSource?

    var loginAttempted = false

    var loginInProgress = false {
        didSet {
            loginButton.isEnabled = !loginInProgress
        }
    }

    // MARK: Keyboard movable

    var selectedField: UITextField?

    var offset: CGFloat = 0.0

    // MARK: Background Movable

    var movableBackground: UIView { return backgroundImageView }

    // MARK: Outlet's

    @IBOutlet var fields: Array<SkyFloatingLabelTextField> = []
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: GradientImageView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupValidation()
        initKeyboardMover()
        initBackgroundMover()
        customizeAppearance()
    }

    override func loadView() {
        self.view = viewFromNib()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroyKeyboardMover()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Setup

    func customizeAppearance() {
        configureFromSource()
        setupFonts()
    }

    func configureFromSource() {
        guard let config = configurationSource else {
            return
        }

        backgroundImageView.image = config.backgroundImage
        backgroundImageView.gradientColor = config.tintColor
        backgroundImageView.fadeColor = config.tintColor
        logoImageView.image = config.secondaryLogoImage

        emailTextField.placeholder = config.emailPlaceholder
        emailTextField.errorColor = config.errorTintColor
        passwordTextField.placeholder = config.passwordPlaceholder
        passwordTextField.errorColor = config.errorTintColor

        loginButton.setTitle(config.loginButtonText, for: .normal)
        loginButton.setTitleColor(config.tintColor, for: .normal)
        forgotPasswordButton.isHidden = !config.shouldShowForgotPassword
        forgotPasswordButton.setTitle(config.forgotPasswordButtonText, for: .normal)

        stackViewHeight.constant = config.shouldShowForgotPassword ? 200 : 125
    }

    func setupFonts() {
        emailTextField.font = Font.montserratRegular.get(size: 13)
        passwordTextField.font = Font.montserratRegular.get(size: 13)
        forgotPasswordButton.titleLabel?.font = Font.montserratLight.get(size: 13)
        loginButton.titleLabel?.font = Font.montserratRegular.get(size: 15)
    }

    // MARK: - Action's

    @IBAction func didSelectBack(_ sender: AnyObject) {
        delegate?.loginDidSelectBack(self)
    }

    @IBAction func didSelectLogin(_ sender: AnyObject) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        loginAttempted = true
        validateFields {
            delegate?.didSelectLogin(self, email: email, password: password)
        }
    }

    @IBAction func didSelectForgotPassword(_ sender: AnyObject) {
        delegate?.didSelectForgotPassword(self)
    }

}

// MARK: - Validation

extension LoginViewController {

    func setupValidation() {
        setupValidationOn(field: emailTextField, rules: ValidationService.emailRules)
        setupValidationOn(field: passwordTextField, rules: ValidationService.passwordRules)
    }

    func setupValidationOn(field: SkyFloatingLabelTextField, rules: ValidationRuleSet<String>) {
        field.validationRules = rules
        field.validateOnInputChange(enabled: true)
        field.validationHandler = validationHandlerFor(field: field)
    }

    func validationHandlerFor(field: SkyFloatingLabelTextField) -> ((ValidationResult) -> Void) {
        return { result in
            switch result {
            case .valid:
                guard self.loginAttempted == true else {
                    break
                }
                field.errorMessage = nil
            case .invalid(let errors):
                guard self.loginAttempted == true else {
                    break
                }
                if let errors = errors as? [ValidationError] {
                    field.errorMessage = errors.first?.message
                }
            }
        }
    }

    func validateFields(success: () -> Void) {
        var errorFound = false
        for field in fields {
            let result = field.validate()
            switch result {
            case .valid:
                field.errorMessage = nil
            case .invalid(let errors):
                errorFound = true
                if let errors = errors as? [ValidationError] {
                    field.errorMessage = errors.first?.message
                }
            }
        }
        if !errorFound {
            success()
        }
    }

}

// MARK: - UITextField Delegate

extension LoginViewController : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        selectedField = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = view.viewWithTag(nextTag) as UIResponder!

        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didSelectLogin(self)
        }
        
        return false
    }
    
}
