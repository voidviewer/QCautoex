import QtQuick 2.0
import QtQml.Models 2.15

Item {
    property alias transmissionTextList: transmissionTextList
    property alias engineTextList: engineTextList
    property alias fuelTextList: fuelTextList

    ListModel {
        id: transmissionTextList
        ListElement {le: ""}
        ListElement {le: ""}
        ListElement {le: "G"}
        ListElement {le: "E"}
        ListElement {le: "A"}
        ListElement {le: "R"}
        ListElement {le: "B"}
        ListElement {le: "O"}
        ListElement {le: "X"}
        ListElement {le: ""}
        ListElement {le: ""}
        ListElement {le: ""}
    }

    ListModel {
        id: engineTextList
        ListElement {le: ""}
        ListElement {le: ""}
        ListElement {le: ""}
        ListElement {le: "E"}
        ListElement {le: "N"}
        ListElement {le: "G"}
        ListElement {le: "I"}
        ListElement {le: "N"}
        ListElement {le: "E"}
        ListElement {le: ""}
        ListElement {le: ""}
        ListElement {le: ""}
    }

    ListModel {
        id: fuelTextList
        ListElement {le: ""}
        ListElement {le: ""}
        ListElement {le: ""}
        ListElement {le: ""}
        ListElement {le: "F"}
        ListElement {le: "U"}
        ListElement {le: "E"}
        ListElement {le: "L"}
        ListElement {le: ""}
        ListElement {le: ""}
        ListElement {le: ""}
        ListElement {le: ""}
    }
}
