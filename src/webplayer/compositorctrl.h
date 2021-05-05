#ifndef COMPOSITORCTRL_H
#define COMPOSITORCTRL_H

#include <QObject>
#include <QtDBus/QDBusInterface>

class CompositorCtrl : public QObject
{
    Q_OBJECT
public:
    explicit CompositorCtrl(QObject *parent = nullptr);

public slots:
    void shuffle();

signals:
    void shuffleTriggered();

private:
    QDBusInterface* m_compositorIface = nullptr;
};

#endif // COMPOSITORCTRL_H
