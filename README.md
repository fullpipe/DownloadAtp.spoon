# DownloadAtp.spoon

Download latest atp.fm podcasts on usb device

## Intallation

You need [Hammerspoon](http://www.hammerspoon.org/) installed.

```bash
brew install hammerspoon
```

Clone spoon

```bash
git clone --depth 1 git@github.com:fullpipe/DownloadAtp.spoon.git ~/.hammerspoon/Spoons/DownloadAtp.spoon
echo "hs.loadSpoon('DownloadAtp'):start('/Absolute/Path/To/Device')" >> ~/.hammerspoon/init.lua
```

On each device connection it will download latest atp.fm podcasts.

