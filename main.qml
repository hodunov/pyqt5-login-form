import QtGraphicalEffects 1.13
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "components"

ApplicationWindow {
    id: root
    objectName: "LoginWindow"

    // Color properties
    property color appBackgroundColor: "#393939"
    property color backgroundColor: "#2C2C2C"
    property color textColor: "#DCE2D9"
    property color inputBackgroundColor: "#444"
    property color inputPlaceholderColor: "#AAA"
    property color buttonColor: "#2E6750"
    property color buttonPressedColor: "#255340"
    property color focusColor: "#454B1B"
    // Login button properties
    property color loginButtonColor: "#4CAF50"
    property color loginButtonPressedColor: "#388E3C"
    property color loginButtonTextColor: "black"
    property color successTextColor: "green"
    property color errorTextColor: "red"

    function areCredentialsValid() {
        // Check if username and password are not empty
        return usernameField.text.length > 0 && passwordField.text.length > 0;
    }

    visible: true
    width: 700
    height: 700
    color: "transparent"
    title: "Login Form"

    Connections {
        target: backend

        function onDropdownUpdated(values) {
            locationComboBox.model = values;
        }
    }

    Rectangle {
        color: "darkgray"
        anchors.fill: parent
    }

    Rectangle {
        id: loginForm

        radius: 20
        width: 400
        height: 370
        // This keeps the form centered
        anchors.centerIn: parent
        color: root.appBackgroundColor

        ColumnLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20
            spacing: 20

            // -----------------------------------------------------------------------------
            // Header section
            Text {
                Layout.alignment: Qt.AlignHCenter
                color: root.textColor
                text: "Виконайте логін у програму"
                font.pixelSize: 22
                font.bold: true
            }

            Rectangle {
                Layout.fillWidth: true
                height: 2
                color: root.textColor
                opacity: 0.7
            }

            // -----------------------------------------------------------------------------
            // Database section
            RowLayout {
                id: databaseRow

                Layout.fillWidth: true
                spacing: 5

                Text {
                    color: root.textColor
                    text: "Database:"
                    font.pixelSize: 16
                }

                CustomRadioButton {
                    id: productionRadio

                    text: "production"
                    checked: true
                    textColor: root.textColor
                    buttonGroup: databaseGroup
                    onClicked: backend.on_radio_button_changed(true)
                }

                CustomRadioButton {
                    id: debugRadio

                    text: "debug_production"
                    textColor: root.textColor
                    buttonGroup: databaseGroup
                    onClicked: backend.on_radio_button_changed(false)
                }

            }

            // -----------------------------------------------------------------------------
            // Form section
            CustomTextField {
                id: usernameField

                Layout.fillWidth: true
                placeholderText: "Username"
                onTextChanged: loginButton.enabled = root.areCredentialsValid()
                showPasswordToggle: false

                fieldValidator: RegExpValidator {
                    regExp: /^[a-zA-Z0-9_-]{3,15}$/ // Validate username same as in the backend
                }

            }

            CustomTextField {
                id: passwordField

                Layout.fillWidth: true
                placeholderText: "Password"
                echoMode: TextInput.Password
                fieldValidator: null // Skip validator for password
                onTextChanged: loginButton.enabled = root.areCredentialsValid()
                showPasswordToggle: true
            }

            // -----------------------------------------------------------------------------
            // Location section
            RowLayout {
                id: locationRow

                // https://forum.qt.io/topic/124353/what-s-wrong-with-alignment/8
                Layout.minimumWidth: parent.width

                CustomComboBox {
                    id: locationComboBox

                    objectName: "locationComboBox"
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: loginForm.width * 0.4
                }

                CustomButton {
                    id: loginButton

                    Layout.alignment: Qt.AlignRight
                    Layout.preferredWidth: loginForm.width * 0.4
                    buttonText: "Логін"
                    buttonColor: root.loginButtonColor
                    buttonPressedColor: root.loginButtonPressedColor
                    textColor: root.loginButtonTextColor
                    enabled: root.areCredentialsValid()
                    onClicked: {
                        loginButton.enabled = false;
                        var success = backend.login(usernameField.text, passwordField.text, locationComboBox.currentText, productionRadio.checked);
                        resultText.text = success ? "Login successful!" : "Please enter the correct username and password.\nNote that both fields may be case-sensitive.";
                        textTimer.start();
                        resultText.color = success ? root.successTextColor : root.errorTextColor;
                        loginButton.enabled = true;
                    }
                    onLongPressed: {
                        secretMessage.visible = true;
                        secretMessageTimer.start();
                    }

                    Timer {
                        id: secretMessageTimer

                        interval: 5000 // 5 seconds
                        onTriggered: secretMessage.visible = false
                    }

                }

            }

            Text {
                id: resultText

                Layout.alignment: Qt.AlignHCenter
                font.pointSize: 14

                Timer {
                    id: textTimer

                    interval: 5000
                    onTriggered: resultText.text = ""
                }

            }
            // -----------------------------------------------------------------------------

            // Easter egg message
            Text {
                id: secretMessage

                text: "🎉 You found the secret! 🎉 Click me"
                visible: false
                color: "green"
                font.bold: true
                font.pointSize: 14
                Layout.alignment: Qt.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Qt.openUrlExternally("https://youtu.be/dQw4w9WgXcQ");
                    }
                    cursorShape: Qt.PointingHandCursor
                }

            }

        }

        ButtonGroup {
            id: databaseGroup
        }

    }

}
