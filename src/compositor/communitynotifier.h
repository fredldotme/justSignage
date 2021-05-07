#ifndef COMMUNITYNOTIFIER_H
#define COMMUNITYNOTIFIER_H

#include <QObject>

class CommunityNotifier : public QObject
{
    Q_OBJECT
public:
    explicit CommunityNotifier(QObject* parent = nullptr);

Q_SIGNALS:
    void communityMemberEntered(const QString& id);
    void communityMemberLeft(const QString& id);
};

#endif
