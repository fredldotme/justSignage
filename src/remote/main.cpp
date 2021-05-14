#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "compositorfinder.h"
#include "compositorremote.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    qmlRegisterType<CompositorFinder>("justSignage", 1, 0, "CompositorFinder");
    qmlRegisterType<CompositorRemote>("justSignage", 1, 0, "CompositorRemote");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
