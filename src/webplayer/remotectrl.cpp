#include "remotectrl.h"

#include <QString>
#include <QtDBus/QDBusConnection>

const QString COMP_SERVICE = QStringLiteral("io.justsignage.compositor");
const QString COMP_PATH = QStringLiteral("/io/justsignage/compositor");
const QString COMP_IFACE = QStringLiteral("io.justsignage.compositor");

const QString VID_SERVICE = QStringLiteral("io.justsignage.video");
const QString VID_PATH = QStringLiteral("/io/justsignage/video");
const QString VID_IFACE = QStringLiteral("io.justsignage.video");

RemoteCtrl::RemoteCtrl(QObject *parent) : QObject(parent)
{
    this->m_compositorIface = new QDBusInterface(COMP_SERVICE,
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
    this->m_compositorIface->call("shuffle");
}

void RemoteCtrl::nextVideo()
{
    this->m_videoIface->call("nextVideo");
}

void RemoteCtrl::animate()
{
    this->m_compositorIface->call("animate");
}
