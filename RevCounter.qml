import QtQuick 2.0

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
    }
    Rectangle {
        id: revNeedle
        x: ((parent.width - 12) / 2) - 3.5
        y: ((parent.height - 12) / 2) - 3.5
        width: 7
        height: ((parent.height - 12) / 2) - 20
        color: "orange"
        //border.color: "orange"
        //border.width: 5
        //transformOrigin: revNeedle.Top
        transform: Rotation { origin.x: 3.5; origin.y: 3.5; angle: 45 + (rpm / 30)}
    }
}
