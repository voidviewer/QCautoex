import QtQuick 2.0
import QtQuick.Shapes 1.15

Item {
    property int rpm: 45

    id: root
    width: 400
    height: 400

    Rectangle {
        id: revCircle
        width: parent.width - 12
        height: parent.height - 12
        color: "transparent"
        border.color: "white"
        border.width: 7
        radius: width * 0.5
        opacity: 0.5
        Rectangle {
            x: 6
            y: 6
            width: parent.width - 12
            height: parent.height - 12
            radius: width * 0.5
            color: "black"
            opacity: 1
        }
    }
    Rectangle {
        id: revNeedle
        x: ((parent.width - 12) / 2) - 3.5
        y: ((parent.height - 12) / 2) - 3.5
        width: 7
        height: ((parent.height - 12) / 2) - 20
        color: "orange"
        transform: Rotation { origin.x: 3.5; origin.y: 3.5; angle: 45 + (rpm / 30)}
        Shape {
            width: 21; height: 21
            x: -6.5; y: -6.5
            ShapePath {
                strokeWidth: 2
                strokeColor: "white"
                fillColor: "black"
                startX: 0; startY: 0
                PathLine { x: 21; y: 0 }
                PathLine { x: 10.5; y: 21 }
                PathLine { x: 0.1; y: 0.1 }
            }
        }
    }
}
