import QtQuick 2.0
import QtQuick.Window 2.15

Window {
    id: mirror
    flags: "FramelessWindowHint"
    maximumWidth: 500
    maximumHeight: 150
    minimumWidth: 500
    minimumHeight: 150
    x: ((window.x + window.width) - (window.width / 2)) - (width / 2)
    y: window.y - height
    color: "black"

    Rectangle {     // window border
        width: mirror.width
        height: mirror.height
        color: "black"
        border.width: 3
        border.color: "Sienna"
    }

    DefaultCamera {
        id: mirrorCamera
        anchors.centerIn: parent
        width: parent.width
        scale: 1.545
    }
}
