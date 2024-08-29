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
        color: customButton.pressed ? customButton.buttonPressedColor : customButton.buttonColor
        radius: 7
    }

    contentItem: Text {
        id: buttonText
        text: customButton.buttonText
        color: customButton.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    // Bind the enabled state
    enabled: enabled

    // Expand the button on press
    states: [
        State {
            name: "pressed"
            when: customButton.pressed
            PropertyChanges { target: customButton; scale: 1.2 }
        }
    ]

    transitions: [
        Transition {
            from: "*"; to: "pressed"
            NumberAnimation { properties: "scale"; duration: 200; easing.type: Easing.InOutQuad }
        },
        Transition {
            from: "pressed"; to: "*"
            NumberAnimation { properties: "scale"; duration: 200; easing.type: Easing.InOutQuad }
        }
    ]

    // Long press event
    onPressAndHold: {
        longPressed();
    }

    signal longPressed
}