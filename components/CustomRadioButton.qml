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
    property color checkedBorderColor: "green"
    property color itemColor: "#393939"

    // Assign the button's group
    ButtonGroup.group: buttonGroup

    // Custom content item for styling
    indicator: Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        x: customRadioButton.leftPadding
        y: parent.height / 2 - height / 2
        radius: 10
        border.color: customRadioButton.checked ? customRadioButton.checkedBorderColor : customRadioButton.uncheckedColor
        border.width: 2
        color: customRadioButton.itemColor

        Rectangle {
            width: 12
            height: 12
            x: 4
            y: 4
            radius: 6
            color: customRadioButton.checked ? customRadioButton.checkedColor : "transparent"
            visible: customRadioButton.checked
        }

    }

    contentItem: Text {
        text: customRadioButton.text
        font: customRadioButton.font
        opacity: enabled ? 1 : 0.3
        color: customRadioButton.textColor
        verticalAlignment: Text.AlignVCenter
        leftPadding: customRadioButton.indicator.width + customRadioButton.spacing
    }

}
