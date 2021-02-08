import QtQuick 2.0
import QtMultimedia 5.15

Item {
    width: 400
    height: 240

    Camera {
        id: camera
        //deviceId: "AC372"
        //deviceId: "OBS Virtual Camera"

        //digitalZoom: 2.0

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        flash.mode: Camera.FlashRedEyeReduction

        imageCapture {
            onImageCaptured: {
                photoPreview.source = preview  // Show the preview in an Image
            }
        }
    }

    VideoOutput {
        id: cameraOutput
        source: camera
        anchors.fill: parent
        focus : visible // to receive focus and capture key events when visible
        fillMode: VideoOutput.PreserveAspectCrop
    }

    Image {
        id: photoPreview
    }

//    ListView {
//        anchors.fill: parent

//        model: QtMultimedia.availableCameras
//        delegate: Text {
//            text: modelData.displayName

//            MouseArea {
//                anchors.fill: parent
//                onClicked: camera.deviceId = modelData.deviceId
//            }
//        }
//    }
}
