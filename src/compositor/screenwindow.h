#ifndef UNITY_SCREENWINDOW_H
#define UNITY_SCREENWINDOW_H

#include <QQuickWindow>
#include <QPointer>
#include <QDebug>

#include <qtmir/screen.h>

class ScreenAdapter;

/*
 * ScreenWindow - wrapper of QQuickWindow to enable QML to specify destination screen.
**/
class ScreenWindow : public QQuickWindow
{
    Q_OBJECT
    Q_PROPERTY(qtmir::Screen *screen READ screenWrapper WRITE setScreenWrapper NOTIFY screenWrapperChanged)
    Q_PROPERTY(int winId READ winId CONSTANT)
public:
    explicit ScreenWindow(QQuickWindow *parent = 0);
    ~ScreenWindow();

    qtmir::Screen *screenWrapper() const;
    void setScreenWrapper(qtmir::Screen *screen);

Q_SIGNALS:
    void screenWrapperChanged();

private:
    QPointer<qtmir::Screen> m_screen;
};

#endif // UNITY_SCREENWINDOW_H
