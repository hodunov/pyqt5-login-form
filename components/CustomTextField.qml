import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15

TextField {
    id: customTextField

    // Optional validator property
    property var fieldValidator: null
    property bool showPasswordToggle: false  // Property to optionally show the eye icon

    // Apply the validator only if provided
    validator: fieldValidator

    inputMethodHints: Qt.ImhNoPredictiveText

    // Properties to allow customization
    property color focusedTextColor: "white"
    property color unfocusedTextColor: "#AAA"
    property color focusedBackgroundColor: "green"
    property color unfocusedBackgroundColor: "#444"

    color: unfocusedTextColor
    placeholderTextColor: customTextField.unfocusedTextColor

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
        visible: customTextField.showPasswordToggle  // Toggle visibility based on the property
        anchors.verticalCenter: parent.verticalCenter  // Align vertically with the TextField
        anchors.right: parent.right
        anchors.rightMargin: 10
        width: 20
        height: 20
        background: Rectangle {
            color: "transparent"
        }

        Image {
            id: img
            anchors.fill: parent
            source: customTextField.echoMode === TextInput.Password ? "images/eye-closed.svg" : "images/eye-open.svg"
        }


        onClicked: {
            customTextField.echoMode = customTextField.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password;
        }
    }
}
