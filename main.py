from gi.repository import GObject, Gst


def main():
    Gst.init(None)

    pipespec = """
       uvch264src device=/dev/video1 name=src auto-start=true

       src.vidsrc
           ! queue
           ! video/x-h264,width=1920,height=1080,framerate=30/1
           ! h264parse
           ! avdec_h264
           ! autovideosink sync=false
    """
    pipeline = Gst.parse_launch(pipespec)
    pipeline.set_state(Gst.State.PLAYING)

    loop = GObject.MainLoop()
    loop.run()


if __name__ == '__main__':
    main()
