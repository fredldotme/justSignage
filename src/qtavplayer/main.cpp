#include <QQmlContext>
#include <QFile>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    QStringList files;
    for (const QString& arg : app.arguments()) {
        if (!QFile::exists(arg))
            continue;
        files << arg;
    }

    engine.rootContext()->setContextProperty("files", files);
    engine.load(url);

    return app.exec();
}
