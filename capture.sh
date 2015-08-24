OUTPATH=out.mpg
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
    fixed-framerate=TRUE \
  cam.vidsrc \
    ! video/x-h264,width=1920,height=1080,framerate=30/1,profile=high \
    ! tee name=vid \
  vid. \
    ! queue \
    ! mpegtsmux \
    ! filesink location=$OUTPATH \
  vid. \
    ! queue \
    ! vaapiparse_h264 \
    ! vaapidecode \
    ! vaapisink fullscreen=true
