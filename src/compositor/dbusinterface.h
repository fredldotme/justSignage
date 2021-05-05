#ifndef DBUS_INTERFACE_H
#define DBUS_INTERFACE_H

#include <QObject>

class DBusInterface : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "io.justsignage.compositor")

public:
    explicit DBusInterface(QObject* parent = nullptr);

public slots:
    void shuffle();

signals:
    void shuffleTriggered();
};

#endif
