#include "videoctrl.h"

VideoCtrl::VideoCtrl(QObject *parent) : QObject(parent)
{

}

void VideoCtrl::nextVideo()
{
    emit nextVideoTriggered();
}
