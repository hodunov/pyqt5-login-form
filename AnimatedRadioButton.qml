import QtQuick 2.15
import QtQuick.Controls 2.15

RadioButton {
    id: customRadioButton

    // Properties to customize the component
    property string buttonText: "Radio Button"
    property var buttonGroup: null
    property color textColor: "black"
    property color checkedColor: "white"
    property color uncheckedColor: "#BDBDBD"

    // Assign the button's group
    ButtonGroup.group: buttonGroup

    // Custom content item for styling
    indicator: Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        x: customRadioButton.leftPadding
        y: parent.height / 2 - height / 2
        radius: 10
        border.color: customRadioButton.checked ? 'green' : uncheckedColor
        border.width: 2
        color: '#393939'
        Rectangle {
            width: 12
            height: 12
            x: 4
            y: 4
            radius: 6
            color: customRadioButton.checked ? checkedColor : "transparent"
            visible: customRadioButton.checked
        }
    }

    contentItem: Text {
        text: customRadioButton.text
        font: customRadioButton.font
        opacity: enabled ? 1.0 : 0.3
        color: textColor
        verticalAlignment: Text.AlignVCenter
        leftPadding: customRadioButton.indicator.width + customRadioButton.spacing
    }
}
