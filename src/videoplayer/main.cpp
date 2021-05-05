#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QtDBus/QDBusConnection>

#include "videoctrl.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qmlRegisterType<VideoCtrl>("justSignage", 1, 0, "VideoCtrl");

    QGuiApplication app(argc, argv);

    VideoCtrl videoCtrl;
    if(!QDBusConnection::sessionBus().registerService("io.justsignage.video") ||
            !QDBusConnection::sessionBus().registerObject("/io/justsignage/video", &videoCtrl,
                                                          QDBusConnection::ExportAllSlots |
                                                          QDBusConnection::ExportAllProperties |
                                                          QDBusConnection::ExportAllSignals)) {
        return 1;
    }

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.rootContext()->setContextProperty("videoCtrl", &videoCtrl);
    engine.load(url);

    return app.exec();
}
