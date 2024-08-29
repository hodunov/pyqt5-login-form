import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: customButton
    // Properties to customize the component
    property string buttonText: "Button"  // Default button text
    property color buttonColor: "#21be2b"  // Default button color
    property color buttonPressedColor: "#17a81a"  // Default pressed color
    property color textColor: "#5DD0A1"  // Default text color
    opacity: enabled ? 1.0 : 0.5

    background: Rectangle {
        color: customButton.down ? customButton.buttonPressedColor : customButton.buttonColor
        radius: 7
    }

    contentItem: Text {
        id: buttonText
        text: customButton.buttonText  // Default text, can be set via the text property
        color: customButton.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    // Bind the enabled state
    enabled: enabled

    // Expand the button on press
    onPressed: anim.start()
    SequentialAnimation {
        id: anim
        PropertyAnimation {
            target: customButton
            property: "scale"
            to: 1.2
            duration: 200
            easing.type: Easing.InOutQuad
        }
        PropertyAnimation {
            target: customButton
            property: "scale"
            to: 1.0
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    // Long press event
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (customButton.enabled) {
                customButton.clicked();  // Emit clicked signal
            }
        }
        onPressed: {
            // Start the long press timer
            pressTimer.start();
        }
        onReleased: {
            // Stop the long press timer
            pressTimer.stop();
        }
    }

    Timer {
        id: pressTimer
        interval: 1000 // 1 second for long press
        repeat: false
        onTriggered: {
            // Emit a signal for the long press event
            longPressed();
        }
    }

    signal longPressed
}
