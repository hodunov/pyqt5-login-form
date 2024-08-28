import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: root
    visible: true

    width: 400
    height: 350
    minimumWidth: 400
    maximumWidth: 400
    maximumHeight: 350
    minimumHeight: 350

    // minimumWidth: 300
    // maximumWidth: 300

    // flags: Qt.FramelessWindowHint | Qt.Window

    color: "#393939"
    title: qsTr("Login Form")

    signal radioButtonChanged(bool isProd)

    // Color properties
    property color backgroundColor: "#2C2C2C"
    property color textColor: "#DCE2D9"
    property color inputBackgroundColor: "#444"
    property color inputPlaceholderColor: "#AAA"
    property color buttonColor: "#2E6750"
    property color buttonPressedColor: "#255340"
    property color focusColor: "#454B1B"

    // property QtObject backend

    // Component.onCompleted: {
    //     radioButtonChanged(true);
    // }

    function areCredentialsValid() {
        // Check if username and password are not empty
        return usernameField.text.length > 0 && passwordField.text.length > 0;
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20  // Increased spacing between elements

        // -----------------------------------------------------------------------------
        // Header section
        Text {
            Layout.alignment: Qt.AlignHCenter
            color: root.textColor
            text: "Виконайте логін у програму"
            font.pixelSize: 16
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
            spacing: 10

            Text {
                color: root.textColor
                text: "Database:"
                font.pixelSize: 16
            }

            // TODO: fix radio buttons
            AnimatedRadioButton {
                id: productionRadio
                text: "production"
                checked: true
                textColor: root.textColor
                buttonGroup: databaseGroup
                onClicked: root.radioButtonChanged(true)
            }
            AnimatedRadioButton {
                id: debugRadio
                text: "debug_production"
                textColor: root.textColor
                buttonGroup: databaseGroup
                onClicked: root.radioButtonChanged(false)
            }
        }

        // -----------------------------------------------------------------------------
        // Form section
        AnimatedTextField {
            id: usernameField
            Layout.fillWidth: true
            placeholderText: "Username"
            fieldValidator: RegExpValidator {
                regExp: /^[a-zA-Z0-9_-]{3,15}$/ // Validate username same as in the backend
            }
            onTextChanged: loginButton.enabled = root.areCredentialsValid()
        }

        AnimatedTextField {
            id: passwordField
            Layout.fillWidth: true
            placeholderText: "Password"
            echoMode: TextInput.Password
            fieldValidator: null // Skip validator for password
            onTextChanged: loginButton.enabled = root.areCredentialsValid()
        }

        // -----------------------------------------------------------------------------
        // Location section
        RowLayout {
            id: locationRow
            // https://forum.qt.io/topic/124353/what-s-wrong-with-alignment/8
            Layout.minimumWidth: parent.width

            AnimatedComboBox {
                id: locationComboBox
                objectName: "locationComboBox"
                Layout.alignment: Qt.AlignLeft
                Layout.preferredWidth: root.width * .4
            }

            CustomButton {
                id: loginButton
                text: "Login"
                Layout.alignment: Qt.AlignRight
                Layout.preferredWidth: root.width * .4
                buttonText: "Login"
                buttonColor: "#4CAF50"  // Green color
                buttonPressedColor: "#388E3C"  // Darker green when pressed
                textColor: "black"
                enabled: root.areCredentialsValid()
                onClicked: {
                    var success = backend.login(usernameField.text, passwordField.text, locationComboBox.currentText, productionRadio.checked);
                    resultText.text = success ? "Login successful!" : "Login failed.";
                    resultText.color = success ? "green" : "red";
                }
                onLongPressed: {
                    secretMessage.visible = true;
                }
            }
        }
        Text {
            id: resultText
            Layout.alignment: Qt.AlignHCenter
        }
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
