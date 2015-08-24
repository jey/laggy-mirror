GST_DEBUG=3
OUTPATH=out.mp4

GST_DEBUG=$GST_DEBUG gst-launch-1.0 -e \
  uvch264src \
    name=cam \
    auto-start=true \
    usage-type=storage \
    peak-bitrate=8000000 \
    rate-control=vbr \
    num-reorder-frames=2 \
    entropy=cabac \
    fixed-framerate=true \
  cam.vidsrc \
    ! video/x-h264,width=1920,height=1080,framerate=30/1,profile=high \
    ! h264parse \
    ! tee name=vid \
    ! queue \
    ! outf. \
  alsasrc device="hw:2,0" \
    ! audio/x-raw,channels=1 \
    ! queue \
    ! audioconvert \
    ! faac bitrate=128000 \
    ! audio/mpeg,mpegversion=4,rate=48000,channels=2,base-profile=lc \
    ! queue2 max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
    ! outf. \
  vid. \
    ! queue \
    ! vaapidecode \
    ! vaapisink fullscreen=true \
  mp4mux name=outf faststart=true \
    ! filesink location=$OUTPATH sync=false \
  ;
exit $?
