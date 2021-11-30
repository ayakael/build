#!/bin/sh

###################################################################################
# Shell script for starting Airsonic.  See http://airsonic.org.
#
# Author: Sindre Mehus
###################################################################################

AIRSONIC_HOME=/var/lib/airsonic
AIRSONIC_HOST=127.0.0.1
AIRSONIC_PORT=8080
AIRSONIC_HTTPS_PORT=0
AIRSONIC_CONTEXT_PATH=/
AIRSONIC_MAX_MEMORY=150
AIRSONIC_PIDFILE=
AIRSONIC_DEFAULT_MUSIC_FOLDER=/var/lib/media/music
AIRSONIC_DEFAULT_PODCAST_FOLDER=/var/lib/media/podcasts
AIRSONIC_DEFAULT_PLAYLIST_FOLDER=/var/lib/media/playlists

quiet=0

usage() {
    echo "Usage: airsonic.sh [options]"
    echo "  --help               This small usage guide."
    echo "  --home=DIR           The directory where Airsonic will create files."
    echo "                       Make sure it is writable. Default: /var/airsonic"
    echo "  --host=HOST          The host name or IP address on which to bind Airsonic."
    echo "                       Only relevant if you have multiple network interfaces and want"
    echo "                       to make Airsonic available on only one of them. The default value"
    echo "                       will bind Airsonic to all available network interfaces. Default: 0.0.0.0"
    echo "  --port=PORT          The port on which Airsonic will listen for"
    echo "                       incoming HTTP traffic. Default: 4040"
    echo "  --https-port=PORT    The port on which Airsonic will listen for"
    echo "                       incoming HTTPS traffic. Default: 0 (disabled)"
    echo "  --context-path=PATH  The context path, i.e., the last part of the Airsonic"
    echo "                       URL. Typically '/' or '/airsonic'. Default '/'"
    echo "  --max-memory=MB      The memory limit (max Java heap size) in megabytes."
    echo "                       Default: 100"
    echo "  --pidfile=PIDFILE    Write PID to this file. Default not created."
    echo "  --quiet              Don't print anything to standard out. Default false."
    echo "  --default-music-folder=DIR    Configure Airsonic to use this folder for music.  This option "
    echo "                                only has effect the first time Airsonic is started. Default '/var/music'"
    echo "  --default-podcast-folder=DIR  Configure Airsonic to use this folder for Podcasts.  This option "
    echo "                                only has effect the first time Airsonic is started. Default '/var/music/Podcast'"
    echo "  --default-playlist-folder=DIR Configure Airsonic to use this folder for playlists.  This option "
    echo "                                only has effect the first time Airsonic is started. Default '/var/playlists'"
    exit 1
}

# Parse arguments.
while [ $# -ge 1 ]; do
    case $1 in
        --help)
            usage
            ;;
        --home=?*)
            AIRSONIC_HOME=${1#--home=}
            ;;
        --host=?*)
            AIRSONIC_HOST=${1#--host=}
            ;;
        --port=?*)
            AIRSONIC_PORT=${1#--port=}
            ;;
        --https-port=?*)
            AIRSONIC_HTTPS_PORT=${1#--https-port=}
            ;;
        --context-path=?*)
            AIRSONIC_CONTEXT_PATH=${1#--context-path=}
            ;;
        --max-memory=?*)
            AIRSONIC_MAX_MEMORY=${1#--max-memory=}
            ;;
        --pidfile=?*)
            AIRSONIC_PIDFILE=${1#--pidfile=}
            ;;
        --quiet)
            quiet=1
            ;;
        --default-music-folder=?*)
            AIRSONIC_DEFAULT_MUSIC_FOLDER=${1#--default-music-folder=}
            ;;
        --default-podcast-folder=?*)
            AIRSONIC_DEFAULT_PODCAST_FOLDER=${1#--default-podcast-folder=}
            ;;
        --default-playlist-folder=?*)
            AIRSONIC_DEFAULT_PLAYLIST_FOLDER=${1#--default-playlist-folder=}
            ;;
        *)
            usage
            ;;
    esac
    shift
done

# Use JAVA_HOME if set, otherwise assume java is in the path.
JAVA=java
if [ -e "${JAVA_HOME}" ]
    then
    JAVA=${JAVA_HOME}/bin/java
fi

# Create Airsonic home directory.
mkdir -p ${AIRSONIC_HOME}
LOG=${AIRSONIC_HOME}/airsonic_sh.log
rm -f ${LOG}

cd $(dirname $0)
if [ -L $0 ] && ([ -e /bin/readlink ] || [ -e /usr/bin/readlink ]); then
    cd $(dirname $(readlink $0))
fi

${JAVA} -Xmx${AIRSONIC_MAX_MEMORY}m \
  -Dairsonic.home=${AIRSONIC_HOME} \
  -Dairsonic.host=${AIRSONIC_HOST} \
  -Dairsonic.port=${AIRSONIC_PORT} \
  -Dairsonic.httpsPort=${AIRSONIC_HTTPS_PORT} \
  -Dairsonic.contextPath=${AIRSONIC_CONTEXT_PATH} \
  -Dairsonic.defaultMusicFolder=${AIRSONIC_DEFAULT_MUSIC_FOLDER} \
  -Dairsonic.defaultPodcastFolder=${AIRSONIC_DEFAULT_PODCAST_FOLDER} \
  -Dairsonic.defaultPlaylistFolder=${AIRSONIC_DEFAULT_PLAYLIST_FOLDER} \
  -Djava.awt.headless=true \
  -verbose:gc \
  -jar ${AIRSONIC_HOME}/airsonic.war > ${LOG} 2>&1 &

# Write pid to pidfile if it is defined.
if [ $AIRSONIC_PIDFILE ]; then
    echo $! > ${AIRSONIC_PIDFILE}
fi

if [ $quiet = 0 ]; then
    echo Started Airsonic [PID $!, ${LOG}]
fi


