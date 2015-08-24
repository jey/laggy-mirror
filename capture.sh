OUTPATH=out.mp4
DURATION=-1
BITRATE=8000000

GST_DEBUG=3 gst-launch-1.0 -e \
  uvch264src \
    name=cam \
    num-buffers=$DURATION \
    auto-start=true \
    usage-type=storage \
    peak-bitrate=$BITRATE \
    rate-control=vbr \
    num-reorder-frames=2 \
    entropy=cabac \
    fixed-framerate=true \
  cam.vidsrc \
    ! video/x-h264,width=1920,height=1080,framerate=30/1,profile=high \
    ! h264parse \
    ! tee name=vid \
  vid. \
    ! queue \
    ! mp4mux faststart=true \
    ! filesink location=$OUTPATH \
  vid. \
    ! queue \
    ! vaapidecode \
    ! vaapisink fullscreen=true
