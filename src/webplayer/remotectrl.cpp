#include "remotectrl.h"

#include <QString>
#include <QDBusConnection>
#include <QDBusConnectionInterface>
#include <QDBusReply>
#include <QDebug>

const QString COMP_SERVICE = QStringLiteral("io.justsignage.compositor.");
const QString COMP_PATH = QStringLiteral("/io/justsignage/compositor");
const QString COMP_IFACE = QStringLiteral("io.justsignage.compositor");

const QString VID_SERVICE = QStringLiteral("io.justsignage.video");
const QString VID_PATH = QStringLiteral("/io/justsignage/video");
const QString VID_IFACE = QStringLiteral("io.justsignage.video");

RemoteCtrl::RemoteCtrl(QObject *parent) : QObject(parent)
{

}

void RemoteCtrl::connect()
{
    this->m_compositorIface = new QDBusInterface(this->m_compositor,
                                                 COMP_PATH,
                                                 COMP_IFACE,
                                                 QDBusConnection::sessionBus(),
                                                 this);

    this->m_videoIface = new QDBusInterface(VID_SERVICE,
                                            VID_PATH,
                                            VID_IFACE,
                                            QDBusConnection::sessionBus(),
                                            this);
}

void RemoteCtrl::shuffle()
{
    if (!this->m_compositorIface)
        return;
    this->m_compositorIface->call("shuffle");
}

void RemoteCtrl::shuffleOthers()
{
    QDBusReply<QStringList> names =
            QDBusConnection::sessionBus().interface()->registeredServiceNames();
    if (!names.isValid())
        return;

    for (QString name : names.value()) {
        qDebug() << name;
        if (name == this->m_compositor)
            continue;

        if (!name.startsWith(COMP_SERVICE))
            continue;

        QDBusInterface tmpIface(name,
                                COMP_PATH,
                                COMP_IFACE,
                                QDBusConnection::sessionBus());
        tmpIface.call("shuffle");
    }
}

void RemoteCtrl::nextVideo()
{
    if (!this->m_videoIface)
        return;
    this->m_videoIface->call("nextVideo");
}

void RemoteCtrl::animate()
{
    if (!this->m_compositorIface)
        return;
    this->m_compositorIface->call("animate");
}
