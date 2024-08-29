import QtLocation 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: customTextField

    // Optional validator property
    property var fieldValidator: null
    property bool showPasswordToggle: false // Property to optionally show the eye icon
    // Properties to allow customization
    property color focusedTextColor: "white"
    property color unfocusedTextColor: "#AAA"
    property color focusedBackgroundColor: "green"
    property color unfocusedBackgroundColor: "#444"

    // Apply the validator only if provided
    validator: fieldValidator
    inputMethodHints: Qt.ImhNoPredictiveText
    color: unfocusedTextColor
    placeholderTextColor: customTextField.unfocusedTextColor
    // Focus change handler
    onActiveFocusChanged: {
        if (activeFocus) {
            customTextField.color = focusedTextColor;
            backgroundRect.color = focusedBackgroundColor;
        } else {
            customTextField.color = unfocusedTextColor;
            backgroundRect.color = unfocusedBackgroundColor;
        }
    }

    Button {
        id: toggleVisibilityButton

        visible: customTextField.showPasswordToggle // Toggle visibility based on the property
        anchors.verticalCenter: parent.verticalCenter // Align vertically with the TextField
        anchors.right: parent.right
        anchors.rightMargin: 10
        width: 20
        height: 20
        onClicked: {
            customTextField.echoMode = customTextField.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password;
        }

        Image {
            id: img

            anchors.fill: parent
            source: customTextField.echoMode === TextInput.Password ? "images/eye-closed.svg" : "images/eye-open.svg"
        }

        background: Rectangle {
            color: "transparent"
        }

    }

    background: Rectangle {
        id: backgroundRect

        color: customTextField.unfocusedBackgroundColor
        radius: 7

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

}
