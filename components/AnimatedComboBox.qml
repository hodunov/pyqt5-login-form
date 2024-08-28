import QtQuick 2.15
import QtQuick.Controls 2.15

ComboBox {
    id: customComboBox
    textRole: "text"
    valueRole: "value"

    // Properties to customize the component
    property color pressedColor: "#17a81a"
    property color unPressedColor: "#21be2b"
    property color inputBackgroundColor: "#444"
    property color textColor: "#5DD0A1"

    indicator: Canvas {
        id: canvas
        x: customComboBox.width - width - customComboBox.rightPadding
        y: customComboBox.topPadding + (customComboBox.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: customComboBox
            function onPressedChanged() {
                canvas.requestPaint();
            }
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = customComboBox.pressed ? customComboBox.pressedColor : customComboBox.unPressedColor;
            context.fill();
        }
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 30
        border.color: customComboBox.pressed ? customComboBox.pressedColor : customComboBox.unPressedColor
        border.width: customComboBox.visualFocus ? 2 : 1
        color: customComboBox.inputBackgroundColor
        radius: 5
    }

    contentItem: Text {
        leftPadding: 10
        height: parent.height
        text: customComboBox.displayText
        color: customComboBox.textColor
        verticalAlignment: Text.AlignVCenter
    }
}
