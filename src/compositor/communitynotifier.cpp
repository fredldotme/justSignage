#include "communitynotifier.h"

#include <QDBusConnection>
#include <QDBusConnectionInterface>
#include <QDebug>

CommunityNotifier::CommunityNotifier(QObject* parent) : QObject(parent)
{
    QObject::connect(QDBusConnection::sessionBus().interface(), &QDBusConnectionInterface::serviceOwnerChanged,
                     this, [=](const QString& name, const QString& oldOwner, const QString& newOwner) {
        qDebug() << name;
        if (!name.startsWith("io.justsignage.compositor."))
            return;
        if (!newOwner.isEmpty())
            emit communityMemberEntered(name);
        else
            emit communityMemberLeft(name);
    });
}
