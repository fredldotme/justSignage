# Welcome to justSignage

### Project scope
* Provide base technologies for digital signage purposes
* Write once, run on every hardware
* Easy to integrate into existing solutions
* Easy to set up and get going

### Basics
* Your experience is content, an interactive app, or a mix
* Your experience has a sense of space
* Your experience moves rather than staying static
* This means animations in and between your content
* Your experience can require multiple devices

### Specifics
* Experiences follow the concept of a "choreograph"
* Choreograph handles flow between your content and apps
* Devices are grouped into "communities"
* Networks (LANs) can have multiple communities
* Communities are devices and apps interacting amongst themselves
* Automatic sharing of new content within the community
* Dynamic switching between content rather than static playlists

### Technologies
* Qt with QML
* Video: Hardware acceleration using either libmpv, QtAV/ffmpeg or QtMultimedia/gstreamer
* Web content: libcef, QtWebEngine
* Mir (via QtMir)
* Halium (for Android driver support)

### Build the source
For first time builds please run the build script using the `-d` argument:

```
./build.sh -d
```

This builds the source tree including dependencies. If building dependencies is
not requested you can simply omit `-d` from the command.

```
./build.sh
```
