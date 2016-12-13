import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import ArcGIS.AppFramework 1.0

Rectangle {

    id: esriStatusIndicator

    property bool hideAutomatically: false
    property bool showDismissButton: false
    property int hideAfter: 30000
    property int containerHeight: 50
    property int statusTextFontSize: 14
    property int indicatorBorderWidth: 1
    property string statusTextFontColor: "#111"
    property alias message: statusText.text
    property alias statusTextObject: statusText

    readonly property var success: {
        "backgroundColor": "#DDEEDB",
        "borderColor": "#9BC19C"
    }

    readonly property var info: {
        "backgroundColor": "#D2E9F9",
        "borderColor": "#3B8FC4"
    }

    readonly property var warning: {
        "backgroundColor": "#F3EDC7",
        "borderColor": "#D9BF2B"
    }

    readonly property var error: {
        "backgroundColor": "#F3DED7",
        "borderColor": "#E4A793"
    }

    property var messageType: success

    signal show()
    signal hide()
    signal linkClicked(string link)

    color: messageType.backgroundColor
    height: containerHeight
    Layout.preferredHeight: containerHeight
    border.width: indicatorBorderWidth
    border.color: messageType.borderColor
    visible: false

    //--------------------------------------------------------------------------

    RowLayout{
        anchors.fill: parent
        spacing: 0

        Text{
            id: statusText
            Layout.fillHeight: true
            Layout.fillWidth: true
            //anchors.top: parent.top
            //anchors.right: parent.right
            //anchors.bottom: parent.bottom
            //anchors.left: parent.left
            color: statusTextFontColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.RichText
            text: ""
            font.pointSize: statusTextFontSize
            font.family: notoRegular.name
            wrapMode: Text.WordWrap
            onLinkActivated: {
                linkClicked(link.toString());
                Qt.openUrlExternally(link);
            }
        }

        Button{
            visible: showDismissButton
            enabled: showDismissButton
            Layout.fillHeight: true
            Layout.preferredWidth: parent.height

            style: ButtonStyle {
                background: Rectangle {
                    anchors.fill: parent
                    color: messageType.backgroundColor
                    border.width: 1
                    border.color: messageType.borderColor
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                anchors.margins: 8 * AppFramework.displayScaleFactor

                Text{
                    anchors.centerIn: parent
                    font.pointSize: config.mediumFontSizePoint
                    color: messageType.borderColor
                    font.family: icons.name
                    text: icons.x_cross
                }
            }

            onClicked: {
                hide();
            }
        }
    }

    // SIGNALS /////////////////////////////////////////////////////////////////

    onShow: {
       esriStatusIndicator.opacity = 1;
       esriStatusIndicator.visible = true;
        if(hideAutomatically===true){
            hideStatusMessage.start();
        }
    }

    //--------------------------------------------------------------------------

    onHide: {
        fader.start()
    }

    // COMPONENTS //////////////////////////////////////////////////////////////

    Timer {
        id: hideStatusMessage
        interval: hideAfter
        running: false
        repeat: false
        onTriggered: hide()
    }

    //--------------------------------------------------------------------------

    PropertyAnimation{
        id:fader
        from: 1
        to: 0
        duration: 1000
        property: "opacity"
        running: false
        easing.type: Easing.Linear
        target: esriStatusIndicator

        onStopped: {
            esriStatusIndicator.visible = false;
            if(hideStatusMessage.running===true){
                hideStatusMessage.stop();
            }
        }
    }

    // END /////////////////////////////////////////////////////////////////////
}