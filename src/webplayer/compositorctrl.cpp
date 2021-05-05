#include "compositorctrl.h"

#include <QString>
#include <QtDBus/QDBusConnection>

const QString COMP_SERVICE = QStringLiteral("io.justsignage.compositor");
const QString COMP_PATH = QStringLiteral("/io/justsignage/compositor");
const QString COMP_IFACE = QStringLiteral("io.justsignage.compositor");

CompositorCtrl::CompositorCtrl(QObject *parent) : QObject(parent)
{
    this->m_compositorIface = new QDBusInterface(COMP_SERVICE,
                                                 COMP_PATH,
                                                 COMP_IFACE,
                                                 QDBusConnection::sessionBus(),
                                                 this);
}

void CompositorCtrl::shuffle()
{
    this->m_compositorIface->call("shuffle");
}
