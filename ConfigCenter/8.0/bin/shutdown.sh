#!/bin/sh

## resolve links
PRG="$0"

# need this for relative symlinks
while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG="`dirname "$PRG"`/$link"
  fi
done

saveddir=`pwd`

AW_COMPONENT_HOME=`dirname "$PRG"`/..

# make it fully qualified
AW_COMPONENT_HOME=`cd "$AW_COMPONENT_HOME" && pwd`

cd "$saveddir"



${AW_COMPONENT_HOME}/bin/build.sh stop
