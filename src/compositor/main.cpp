#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QJsonObject>
#include <QJsonDocument>
#include <QDir>
#include <QDBusConnection>
#include <QDBusConnectionInterface>
#include <QRandomGenerator>
#include <QDebug>
#include <QProcess>

#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <qtmir/mirserverapplication.h>
#include <qtmir/displayconfigurationpolicy.h>
#include <qtmir/sessionauthorizer.h>
#include <qtmir/windowmanagementpolicy.h>
#include <qtmir/displayconfigurationstorage.h>
#include <qtmir/miral/edid.h>

#include "screens.h"
#include "screenwindow.h"
#include "pointerposition.h"
#include "dbusinterface.h"
#include "communitynotifier.h"

inline QString stringFromEdid(const miral::Edid& edid)
{
    QString str;
    str += QString::fromStdString(edid.vendor);
    str += QString("%1%2").arg(edid.product_code).arg(edid.serial_number);

    for (int i = 0; i < 4; i++) {
        str += QString::fromStdString(edid.descriptors[i].string_value());
    }
    return str;
}

struct DemoDisplayConfigurationPolicy : qtmir::DisplayConfigurationPolicy
{
    void apply_to(mir::graphics::DisplayConfiguration& conf)
    {
        qDebug() << "OVERRIDE qtmir::DisplayConfigurationPolicy::apply_to";
        qtmir::DisplayConfigurationPolicy::apply_to(conf);
    }
};

class DemoWindowManagementPolicy : public qtmir::WindowManagementPolicy
{
public:
    DemoWindowManagementPolicy(const miral::WindowManagerTools &tools, std::shared_ptr<qtmir::WindowManagementPolicyPrivate> dd)
        : qtmir::WindowManagementPolicy(tools, dd)
    {}

    bool handle_pointer_event(const MirPointerEvent *event) override
    {
        return qtmir::WindowManagementPolicy::handle_pointer_event(event);
    }

    bool handle_keyboard_event(const MirKeyboardEvent *event) override
    {
        return qtmir::WindowManagementPolicy::handle_keyboard_event(event);
    }

    void advise_new_window(const miral::WindowInfo &windowInfo) override
    {
        qDebug() << Q_FUNC_INFO;

        qtmir::WindowManagementPolicy::advise_new_window(windowInfo);
    }

    void advise_adding_to_workspace(const std::shared_ptr<miral::Workspace> &workspace,
                                    const std::vector<miral::Window> &windows) override
    {
        qDebug() << Q_FUNC_INFO;
        qtmir::WindowManagementPolicy::advise_adding_to_workspace(workspace, windows);
    }

    void advise_output_create(miral::Output const& output)
    {
        qDebug() << Q_FUNC_INFO;
        qtmir::WindowManagementPolicy::advise_output_create(output);
    }
};

struct DemoDisplayConfigurationStorage : miral::DisplayConfigurationStorage
{
    void save(const miral::DisplayId& displayId, const miral::DisplayConfigurationOptions& options) override
    {
        QFile f(stringFromEdid(displayId.edid) + ".edid");
        qDebug() << "OVERRIDE miral::DisplayConfigurationStorage::save" << f.fileName();

        QJsonObject json;
        if (options.used.is_set()) json.insert("used", options.used.value());
        if (options.clone_output_index.is_set()) json.insert("clone_output_index", static_cast<int>(options.clone_output_index.value()));
        if (options.mode.is_set()) {
            auto const& mode = options.mode.value();

            QString sz(QString("%1x%2").arg(mode.size.width.as_int()).arg(mode.size.height.as_int()));
            QJsonObject jsonMode({
                {"size", sz},
                {"refresh_rate", mode.refresh_rate }
            });
            json.insert("mode", jsonMode);
        }
        if (options.orientation.is_set()) json.insert("orientation", static_cast<int>(options.orientation.value()));
        if (options.form_factor.is_set()) json.insert("form_factor", static_cast<int>(options.form_factor.value()));
        if (options.scale.is_set()) json.insert("scale", options.scale.value());

        if (f.open(QIODevice::WriteOnly)) {
            QJsonDocument saveDoc(json);
            f.write(saveDoc.toJson());
        }
    }

    bool load(const miral::DisplayId& displayId, miral::DisplayConfigurationOptions& options) const override
    {
        QFile f(stringFromEdid(displayId.edid) + ".edid");
        qDebug() << "OVERRIDE miral::DisplayConfigurationStorage::load" << f.fileName();

        if (f.open(QIODevice::ReadOnly)) {
            QByteArray saveData = f.readAll();
            QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));

            QJsonObject json(loadDoc.object());
            if (json.contains("used")) options.used = json["used"].toBool();
            if (json.contains("clone_output_index")) options.clone_output_index = json["clone_output_index"].toInt();
            if (json.contains("mode")) {
                QJsonObject jsonMode = json["mode"].toObject();

                if (jsonMode.contains("size") && jsonMode.contains("refresh_rate")) {
                    QString sz(jsonMode["size"].toString());
                    QStringList geo = sz.split("x", QString::SkipEmptyParts);
                    if (geo.count() == 2) {
                        miral::DisplayConfigurationOptions::DisplayMode mode;
                        mode.size = mir::geometry::Size(geo[0].toInt(), geo[1].toInt());
                        mode.refresh_rate = jsonMode["refresh_rate"].toDouble();
                        options.mode = mode;
                    }
                }
            }
            if (json.contains("orientation")) options.orientation = static_cast<MirOrientation>(json["orientation"].toInt());
            if (json.contains("form_factor")) options.form_factor = static_cast<MirFormFactor>(json["form_factor"].toInt());
            if (json.contains("scale")) options.scale = json["form_factor"].toDouble();

            return true;
        }

        return false;
    }
};

struct DemoSessionAuthorizer : qtmir::SessionAuthorizer
{
    bool connectionIsAllowed(miral::ApplicationCredentials const& creds) override
    {
        qDebug() << "OVERRIDE qtmir::SessionAuthorizer::connectionIsAllowed";
        return true;
    }
    bool configureDisplayIsAllowed(miral::ApplicationCredentials const& creds) override
    {
        qDebug() << "OVERRIDE qtmir::SessionAuthorizer::configureDisplayIsAllowed";
        return qtmir::SessionAuthorizer::configureDisplayIsAllowed(creds);
    }
    bool setBaseDisplayConfigurationIsAllowed(miral::ApplicationCredentials const& creds) override
    {
        qDebug() << "OVERRIDE qtmir::SessionAuthorizer::setBaseDisplayConfigurationIsAllowed";
        return qtmir::SessionAuthorizer::setBaseDisplayConfigurationIsAllowed(creds);
    }
    bool screencastIsAllowed(miral::ApplicationCredentials const& creds) override
    {
        qDebug() << "OVERRIDE qtmir::SessionAuthorizer::screencastIsAllowed";
        return qtmir::SessionAuthorizer::screencastIsAllowed(creds);
    }
    bool promptSessionIsAllowed(miral::ApplicationCredentials const& creds) override
    {
        qDebug() << "OVERRIDE qtmir::SessionAuthorizer::promptSessionIsAllowed";
        return qtmir::SessionAuthorizer::promptSessionIsAllowed(creds);
    }
};

QString GetRandomString()
{
    qsrand(QRandomGenerator::global()->generate());
    const QString possibleCharacters("abcdefghijklmnopqrstuvwxyz");
    const int randomStringLength = 3;

    QString ret;
    for(int i = 0; i < randomStringLength; i++) {
       int index = qrand() % possibleCharacters.length();
       QChar nextChar = possibleCharacters.at(index);
       ret.append(nextChar);
   }
   return ret;
}

int main(int argc, char *argv[])
{
    {
        QByteArray xdgRuntimePath = qgetenv("XDG_RUNTIME_DIR");
        QDir xdgRuntimeDir(xdgRuntimePath);
        if (!xdgRuntimeDir.exists()) {
            xdgRuntimeDir.mkpath(QString::fromUtf8(xdgRuntimePath));
            if (chmod(xdgRuntimePath.data(), 0700)) {
                qInfo() << "Failed to set permissions on" << xdgRuntimePath;
                return 1;
            }
        }
    }

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    qtmir::SetSessionAuthorizer<DemoSessionAuthorizer> sessionAuth;
    qtmir::SetDisplayConfigurationPolicy<DemoDisplayConfigurationPolicy> displayConfig;
    qtmir::SetWindowManagementPolicy<DemoWindowManagementPolicy> wmPolicy;

    qtmir::SetDisplayConfigurationStorage<DemoDisplayConfigurationStorage> displayStorage;

    qtmir::MirServerApplication::setApplicationName("justSignage");
    qtmir::MirServerApplication *application;

    application = new qtmir::MirServerApplication(argc, (char**)argv, { displayConfig, sessionAuth, wmPolicy, displayStorage });

    qmlRegisterSingletonType<PointerPosition>("Mir.Pointer", 0, 1, "PointerPosition",
        [](QQmlEngine*, QJSEngine*) -> QObject* { return PointerPosition::instance(); });
    qmlRegisterType<ScreenWindow>("QtMir", 0, 1, "ScreenWindow");
    qmlRegisterSingletonType<Screens>("QtMir", 0, 1, "Screens",
        [](QQmlEngine*, QJSEngine*) -> QObject* {
            static Screens* screens = new Screens();
            return screens;
    });
    qmlRegisterUncreatableType<qtmir::Screen>("QtMir", 0, 1, "Screen", "Screen is not creatable.");
    qmlRegisterType<CommunityNotifier>("justSignage", 1, 0, "CommunityNotifier");

    DBusInterface dbusInterface;
    const QString serviceTemplate = QStringLiteral("io.justsignage.compositor.%1");
    QString serviceName = serviceTemplate.arg(GetRandomString());
    if(!QDBusConnection::sessionBus().registerService(serviceName) ||
            !QDBusConnection::sessionBus().registerObject("/io/justsignage/compositor", &dbusInterface,
                                                          QDBusConnection::ExportAllSlots |
                                                          QDBusConnection::ExportAllProperties |
                                                          QDBusConnection::ExportAllSignals)) {
        return 2;
    }

    CommunityNotifier communityNotifier;

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     application, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.rootContext()->setContextProperty("dbusInterface", &dbusInterface);
    engine.rootContext()->setContextProperty("communityNotifier", &communityNotifier);
    engine.load(url);

    QProcess videoPlayer;
    videoPlayer.start("justsignage-videoplayer", QStringList() << serviceName << "-platform" << "wayland");

    QProcess webPlayer;
    webPlayer.start("justsignage-webplayer", QStringList() << serviceName << "-platform" << "wayland");

    QProcess imagePlayer;
    imagePlayer.start("justsignage-imageplayer", QStringList() << serviceName << "-platform" << "wayland");

    const int result = application->exec();
    delete application;

    return result;
}
