import QtGraphicalEffects 1.13
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "components"

ApplicationWindow {
    id: root

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

    signal radioButtonChanged(bool isProd)

    function areCredentialsValid() {
        // Check if username and password are not empty
        return usernameField.text.length > 0 && passwordField.text.length > 0;
    }

    visible: true
    width: 400
    height: 350
    minimumWidth: 400
    maximumWidth: 400
    maximumHeight: 350
    minimumHeight: 350
    color: "transparent"
    title: qsTr("Login Form")
    // Remove the title bar and borders
    flags: Qt.FramelessWindowHint | Qt.Window

    // Rounded window
    Rectangle {
        color: root.appBackgroundColor
        radius: 20
        anchors.fill: parent
    }

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
            text: qsTr("Виконайте логін у програму")
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
                text: qsTr("Database:")
                font.pixelSize: 16
            }

            CustomRadioButton {
                id: productionRadio

                text: qsTr("production")
                checked: true
                textColor: root.textColor
                buttonGroup: databaseGroup
                onClicked: root.radioButtonChanged(true)
            }

            CustomRadioButton {
                id: debugRadio

                text: qsTr("debug_production")
                textColor: root.textColor
                buttonGroup: databaseGroup
                onClicked: root.radioButtonChanged(false)
            }

        }

        // -----------------------------------------------------------------------------
        // Form section
        CustomTextField {
            id: usernameField

            Layout.fillWidth: true
            placeholderText: qsTr("Username")
            onTextChanged: loginButton.enabled = root.areCredentialsValid()
            showPasswordToggle: false

            fieldValidator: RegExpValidator {
                regExp: /^[a-zA-Z0-9_-]{3,15}$/ // Validate username same as in the backend
            }

        }

        CustomTextField {
            id: passwordField

            Layout.fillWidth: true
            placeholderText: qsTr("Password")
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
                Layout.preferredWidth: root.width * 0.4
            }

            CustomButton {
                id: loginButton

                Layout.alignment: Qt.AlignRight
                Layout.preferredWidth: root.width * 0.4
                buttonText: qsTr("Логін")
                buttonColor: root.loginButtonColor
                buttonPressedColor: root.loginButtonPressedColor
                textColor: root.loginButtonTextColor
                enabled: root.areCredentialsValid()
                onClicked: {
                    loginButton.enabled = false; // Disable the button
                    var success = backend.login(usernameField.text, passwordField.text, locationComboBox.currentText, productionRadio.checked);
                    resultText.text = success ? qsTr("Login successful!") : qsTr("Please enter the correct username and password.\nNote that both fields may be case-sensitive.");
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
        // Easter egg message

        Text {
            id: secretMessage

            text: qsTr("🎉 You found the secret! 🎉 Click me")
            visible: false
            color: "green"
            font.bold: true
            font.pointSize: 14
            Layout.alignment: Qt.AlignHCenter

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Open the URL
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
