#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebEngine/QtWebEngine>

#include "remotectrl.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qmlRegisterType<RemoteCtrl>("justSignage", 1, 0, "RemoteCtrl");

    QGuiApplication app(argc, argv);

    if (QGuiApplication::arguments().length() < 2) {
        return 1;
    }

    QtWebEngine::initialize();

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.rootContext()->setContextProperty("compositorName", QGuiApplication::arguments().at(1));
    engine.load(url);

    return app.exec();
}
