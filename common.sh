PROJECT=justSignage
VERSION=0.0.0-rc0

if [ "$SNAPCRAFT_PROJECT_NAME" != "" ]; then
    INSTALL=/usr
else
    INSTALL=/opt/${PROJECT}-${VERSION}
fi