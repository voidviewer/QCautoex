//
// Module provides base item for control module buttons.
//
import QtQuick 2.0
import QtQuick.Controls 2.15

Button {
    id: defaultButton
    property string buttonText: "defaultButton"

    height: 24
    contentItem: Text {
        color: "white"
        text: buttonText
    }
    background: Rectangle {
        color: {
            //pressed ? "grey" : "transparent"
            hovered ? "#646464" : "transparent"
        }
        border.width: 1
        border.color: "grey"
    }
}
