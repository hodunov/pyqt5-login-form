import QtQuick 2.15
import QtQuick.Controls 2.15

ComboBox {
    id: customComboBox
    objectName: "CustomComboBox"

    // Properties to customize the component
    property color pressedColor: "#17a81a"
    property color unPressedColor: "#e0e0e0"
    property color inputBackgroundColor: "#444"
    property color textColor: "#5DD0A1"
    property color popupTextColor: "#DCE2D9"
    property color popupBackgroundColor: "#434343"
    property color highlightedBackgroundColor: "#838383"
    property color highlightedTextColor: "#e0e0e0"

    textRole: "text"
    valueRole: "value"

    indicator: Canvas {
        id: canvas

        x: customComboBox.width - width - customComboBox.rightPadding
        y: customComboBox.topPadding + (customComboBox.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"
        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = customComboBox.pressed ? customComboBox.pressedColor : customComboBox.unPressedColor;
            context.fill();
        }

        Connections {
            function onPressedChanged() {
                canvas.requestPaint();
            }

            target: customComboBox
        }

    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 30
        border.color: customComboBox.pressed ? customComboBox.pressedColor : customComboBox.inputBackgroundColor
        border.width: customComboBox.visualFocus ? 2 : 1
        color: customComboBox.inputBackgroundColor
        radius: 7
    }

    contentItem: Text {
        leftPadding: 10
        height: parent.height
        text: customComboBox.displayText
        color: customComboBox.textColor
        verticalAlignment: Text.AlignVCenter
    }

    popup: Popup {
        y: customComboBox.height
        width: customComboBox.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: customComboBox.popup.visible ? customComboBox.delegateModel : null
            currentIndex: customComboBox.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator {
            }

        }

        background: Rectangle {
            color: customComboBox.popupBackgroundColor
            radius: 7
            border.color: customComboBox.inputBackgroundColor
        }

    }

    delegate: ItemDelegate {
        width: customComboBox.width
        highlighted: customComboBox.highlightedIndex === index

        contentItem: Text {
            text: customComboBox.textRole ? (Array.isArray(customComboBox.model) ? modelData[customComboBox.textRole] : model[customComboBox.textRole]) : modelData
            color: customComboBox.highlightedIndex === index ? customComboBox.highlightedTextColor : customComboBox.popupTextColor
            font: customComboBox.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            color: highlighted ? customComboBox.highlightedBackgroundColor : "transparent"
        }

    }

}
