import QtQuick 2.15
import QtQuick.Controls 2.15

RadioButton {
    id: customRadioButton

    // Properties to customize the component
    property string buttonText: "Radio Button"
    property var buttonGroup: null
    property color textColor: "black"

    // Assign the button's group
    ButtonGroup.group: buttonGroup

    // Custom content item for styling
    contentItem: Text {
        text: customRadioButton.buttonText
        font: customRadioButton.font
        opacity: enabled ? 1.0 : 0.3
        color: customRadioButton.textColor
        verticalAlignment: Text.AlignVCenter
        leftPadding: customRadioButton.indicator.width + customRadioButton.spacing
    }
}
