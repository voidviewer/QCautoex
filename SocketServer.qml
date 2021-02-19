import QtQuick 2.0
import QtWebSockets 1.0

Item {
    property string serverUrl: server.url

    function setGauge(gaugeIn) {
        var gaugeType = gaugeIn.substring(0,2)
        var gaugeValue = gaugeIn.substring(2)

        switch(gaugeType) {
        case "R ":
            gaugeValue = gaugeValue * (270 / 9000)
            revMeter.needleRotation = gaugeValue;
            break;
        case "S ":
            gaugeValue = gaugeValue * (270 / 360)
            speedoMeter.needleRotation = gaugeValue;
            break;
        case "T ":
            turnSignalsItem.signalValue = gaugeValue
            break;
        case "G ":
            gearDisplay.gear = gaugeValue
            break;
        case "Eo":
            engineOilTemperatureGauge.gaugeValue = gaugeValue
            break;
        default:
            break;
        }
    }

    WebSocketServer {
        id: server
        listen: true
        onClientConnected: {
            webSocket.onTextMessageReceived.connect(function(gaugeIn) {
                setGauge(qsTr("%1").arg(gaugeIn));
            });
        }
        onErrorStringChanged: {
            console.log(qsTr(timeOfDay() + " Server error: %1").arg(errorString));
        }
    }

    WebSocket {
        id: socket
        url: server.url
        active: true
        onTextMessageReceived: {
            console.log(timeOfDay() + " Server received message: " + socket.textMessageReceived())
        }
        onStatusChanged: {
            if (socket.status == WebSocket.Error) {
                console.log(timeOfDay() + " Server received message: " + socket.errorString)
            } else if (socket.status == WebSocket.Closed) {
                console.log(qsTr("Server socket closed."));
            }
        }
    }
}
