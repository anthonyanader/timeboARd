//
//  PasswordViewController.swift
//  Pods
//
//  Created by Daniel Lozano Valdés on 12/12/16.
//
//

import UIKit
import Validator

protocol PasswordViewControllerDelegate: class {

    func didSelectRecover(_ viewController: UIViewController, email: String)

    func passwordDidSelectBack(_ viewController: UIViewController)

}

class PasswordViewController: UIViewController, BackgroundMovable, KeyboardMovable {

    // MARK: - Properties

    weak var delegate: PasswordViewControllerDelegate?

    weak var configurationSource: ConfigurationSource?

    var recoverAttempted = false

    // MARK: Keyboard movable

    var selectedField: UITextField?

    var offset: CGFloat = 0.0

    // MARK: Background Movable

    var movableBackground: UIView {
        get {
            return backgroundImageView
        }
    }

    // MARK: Outlet's

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!

    @IBOutlet weak var recoverButton: Buttn!

    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var backgroundImageView: GradientImageView!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        initBackgroundMover()
        customizeAppearance()
        setupValidation()
    }

    override func loadView() {
        self.view = viewFromNib()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        recoverButton.setTitle(config.recoverPasswordButtonText, for: .normal)
    }

    func setupFonts() {
        emailTextField.font = Font.montserratRegular.get(size: 13)
        recoverButton.titleLabel?.font = Font.montserratRegular.get(size: 15)
    }

    // MARK: - Action's

    @IBAction func didSelectBack(_ sender: AnyObject) {
        delegate?.passwordDidSelectBack(self)
    }

    @IBAction func didSelectRecover(_ sender: AnyObject) {
        recoverAttempted = true

        guard let email = emailTextField.text else {
            return
        }

        validateFields {
            delegate?.didSelectRecover(self, email: email)
        }
    }
    
}

// MARK: - Validation

extension PasswordViewController {

    func setupValidation() {
        setupValidationOn(field: emailTextField, rules: ValidationService.emailRules)
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
                guard self.recoverAttempted == true else {
                    break
                }
                field.errorMessage = nil
            case .invalid(let errors):
                guard self.recoverAttempted == true else {
                    break
                }
                if let errors = errors as? [ValidationError] {
                    field.errorMessage = errors.first?.message
                }
            }
        }
    }

    func validateFields(success: () -> Void) {
        let result = emailTextField.validate()
        switch result {
        case .valid:
            emailTextField.errorMessage = nil
            success()
        case .invalid(let errors):
            if let errors = errors as? [ValidationError] {
                emailTextField.errorMessage = errors.first?.message
            }
        }
    }

}

// MARK: - UITextField Delegate

extension PasswordViewController: UITextFieldDelegate {

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
            didSelectRecover(self)
        }

        return false
    }
    
}
