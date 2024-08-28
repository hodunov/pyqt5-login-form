import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: animatedTextField

    // Optional validator property
    property var fieldValidator: null
    property bool showPasswordToggle: false  // Property to optionally show the checkbox

    // Apply the validator only if provided
    validator: fieldValidator

    inputMethodHints: Qt.ImhNoPredictiveText

    // Properties to allow customization
    property color focusedTextColor: "white"
    property color unfocusedTextColor: "#AAA"
    property color focusedBackgroundColor: "green"
    property color unfocusedBackgroundColor: "#444"

    color: unfocusedTextColor
    placeholderTextColor: animatedTextField.unfocusedTextColor

    background: Rectangle {
        id: backgroundRect
        color: animatedTextField.unfocusedBackgroundColor
        radius: 5

        // Background color animation
        Behavior on color {
            ColorAnimation {
                duration: 300
            }
        }
    }

    // Text color animation
    Behavior on color {
        ColorAnimation {
            duration: 300
        }
    }

    // Focus change handler
    onActiveFocusChanged: {
        if (activeFocus) {
            animatedTextField.color = focusedTextColor;
            backgroundRect.color = focusedBackgroundColor;
        } else {
            animatedTextField.color = unfocusedTextColor;
            backgroundRect.color = unfocusedBackgroundColor;
        }
    }

    CheckBox {
        id: showPasswordCheckBox
        text: ""
        width: 20
        height: 20
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: passwordField.right
        anchors.rightMargin: 10
        visible: animatedTextField.showPasswordToggle  // Toggle visibility based on the property

        onCheckedChanged: {
            passwordField.echoMode = checked ? TextInput.Normal : TextInput.Password
        }
    }
}
