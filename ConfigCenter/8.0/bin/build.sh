#!/bin/bash
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

EOS_COMPONENT_HOME=`cd "$AW_COMPONENT_HOME" && cd ".." && pwd`


cd "$saveddir"


# apollo config db info
apollo_config_db_url=jdbc:mysql://127.0.0.1:3306/ApolloConfigDB?characterEncoding=utf8
apollo_config_db_username=root
apollo_config_db_password=123qwe,./

if [[ $apollo_config_db_url =~ "jdbc:mysql" ]]
then
  export spring_datasource_validationQuery="select 1"
else
  export spring_datasource_validationQuery="select 1 from dual"
fi

# apollo portal db info
# apollo_portal_db_url=jdbc:mysql://localhost:3306/ApolloPortalDB?characterEncoding=utf8
# apollo_portal_db_username=root
# apollo_portal_db_password=root

#eureka addresss
eureka_service_url=http://127.0.0.1:8761/eureka/

# =============== Please do not modify the following content =============== #

if [ "$(uname)" == "Darwin" ]; then
    windows="0"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    windows="0"
elif [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then
    windows="1"
else
    windows="0"
fi

# meta server url
config_host_name=127.0.0.1
config_server_port=8081
admin_server_port=8091
# portal_port=8070

config_server_url=http://$config_host_name:$config_server_port
admin_server_url=http://$config_host_name:$admin_server_port
# portal_url=http://localhost:$portal_port



# JAVA OPTS
BASE_JAVA_OPTS="-Denv=dev -Ddev_meta=$config_server_url"
SERVER_JAVA_OPTS="$BASE_JAVA_OPTS -Dspring.profiles.active=dev -Deureka.client.serviceUrl.defaultZone=$eureka_service_url"

# executable

LIB_DIR=${AW_COMPONENT_HOME}/lib
LOG_DIR=${AW_COMPONENT_HOME}/logs
CONF_DIR=${AW_COMPONENT_HOME}/conf
BIN_DIR=${AW_COMPONENT_HOME}/bin

JAR_FILE=$LIB_DIR/apollo-all-in-one.jar

SERVICE_DIR=$BIN_DIR
SERVICE_JAR_NAME=apollo-service.jar
SERVICE_JAR=$LOG_DIR/$SERVICE_JAR_NAME
SERVICE_LOG=$LOG_DIR/apollo-service.log
PORTAL_DIR=$BIN_DIR
PORTAL_JAR_NAME=apollo-portal.jar
PORTAL_JAR=$LOG_DIR/$PORTAL_JAR_NAME
PORTAL_LOG=$LOG_DIR/apollo-portal.log
CLIENT_DIR=${AW_COMPONENT_HOME}/client
CLIENT_JAR=$CLIENT_DIR/apollo-demo.jar
SERVICE_CONFIG_FILE=$LOG_DIR/apollo-service.conf
PORTAL_CONFIG_FILE=$LOG_DIR/apollo-portal.conf
SERVICE_CONFIG_FILE_SOURCE=$CONF_DIR/apollo-service.conf
PORTAL_CONFIG_FILE_SOURCE=$CONF_DIR/apollo-portal.conf

#update in 2017/8/7

CONFIGSERVICE_JAR_NAME=apollo-config-service.jar
CONFIGSERVICE_JAR=$LOG_DIR/$CONFIGSERVICE_JAR_NAME

ADMINSERVICE_JAR_NAME=apollo-admin-service.jar
ADMINSERVICE_JAR=$LOG_DIR/$ADMINSERVICE_JAR_NAME

CONFIGSERVICE_CONFIG_FILE_SOURCE=$CONF_DIR/apollo-config-service.conf
ADMINSERVICE_CONFIG_FILE_SOURCE=$CONF_DIR/apollo-admin-service.conf


CONFIGSERVICE_CONFIG_FILE=$LOG_DIR/apollo-config-service.conf
ADMINSERVICE_CONFIG_FILE=$LOG_DIR/apollo-admin-service.conf


##insert in 2017/8/21
JRE_LOCATION=${EOS_COMPONENT_HOME}/jre

#2017/12/12 EPEIGHT-1943
export JAVA_HOME=$JRE_LOCATION
export PATH=$JRE_LOCATION/bin:$PATH
echo "================== EOS Platform 8.0 Configuration Center =================="

function checkJava {
  if [[ -n "$JRE_LOCATION" ]] && [[ -x "$JRE_LOCATION/bin/java" ]];  then
      if [ "$windows" == "1" ]; then
        tmp_java_home=`cygpath -sw "$JRE_LOCATION"`
        export JAVA_HOME=`cygpath -u $tmp_java_home`
        echo "Windows new JRE_LOCATION is: $JRE_LOCATION"
      fi
      _java="$JRE_LOCATION/bin/java"
  elif type -p java > /dev/null; then
    _java=java
  else
      echo "Could not find java executable, please check your java environment"
    exit 1
  fi
  if [[ "$_java" ]]; then
      version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
      if [[ "$version" < "1.8" ]]; then
          echo "Java version is $version, please make sure java 1.8+ is in the path"
         exit 1
      fi
  fi

}

function checkServerAlive {
  declare -i counter=0
  declare -i max_counter=24 # 24*5=120s
  declare -i total_time=0

  SERVER_URL="$1"

  until [[ (( counter -ge max_counter )) || "$(curl -X GET --silent --connect-timeout 1 --head $SERVER_URL | grep "Coyote")" != "" ]];
  do
    printf "."
    counter+=1
    sleep 5
  done

  total_time=counter*5

  if [[ (( counter -ge max_counter )) ]];
  then
    return $total_time
  fi

  return 0
}

checkJava

if [ "$1" = "start" ] ; then

  echo "======================= Starting Config Service ==========================="
  echo "Config service logging file is $LOG_DIR/apollo-config-service.log"
  
  
 #  if [[ -d "$LOG_DIR" ]]; then

	# if [[ ! -f "$SERVICE_CONFIG_FILE" ]]; then
	# 	cp $SERVICE_CONFIG_FILE_SOURCE -r $SERVICE_CONFIG_FILE
	# fi
	
	# if [[ ! -f "$PROTAL_CONFIG_FILE" ]]; then
	# 	cp $PORTAL_CONFIG_FILE_SOURCE -r $PORTAL_CONFIG_FILE
	# fi
 #  else

	# mkdir "$LOG_DIR"
	# chmod a+x "$LOG_DIR"
	# cp $SERVICE_CONFIG_FILE_SOURCE -r $SERVICE_CONFIG_FILE
	# cp $PORTAL_CONFIG_FILE_SOURCE -r $PORTAL_CONFIG_FILE

 #  fi
  
  

  # if [[ -f $SERVICE_JAR ]]; then
  #   rm -rf $SERVICE_JAR
  # fi
  

  if [[ -d "$LOG_DIR" ]]; then

  if [[ ! -f "$CONFIGSERVICE_CONFIG_FILE" ]]; then
    cp -r $CONFIGSERVICE_CONFIG_FILE_SOURCE  $CONFIGSERVICE_CONFIG_FILE
  fi
  
  if [[ ! -f "$ADMINSERVICE_CONFIG_FILE" ]]; then
    cp -r $ADMINSERVICE_CONFIG_FILE_SOURCE  $ADMINSERVICE_CONFIG_FILE
  fi
  else

  mkdir "$LOG_DIR"
  chmod a+x "$LOG_DIR"
  cp -r $CONFIGSERVICE_CONFIG_FILE_SOURCE  $CONFIGSERVICE_CONFIG_FILE
  cp -r $ADMINSERVICE_CONFIG_FILE_SOURCE  $ADMINSERVICE_CONFIG_FILE

  fi




   if [[ -f $CONFIGSERVICE_JAR ]]; then
    rm -rf $CONFIGSERVICE_JAR
  fi
     if [[ -f $ADMINSERVICE_JAR ]]; then
    rm -rf $ADMINSERVICE_JAR
  fi

  ln $JAR_FILE $CONFIGSERVICE_JAR
  chmod a+x $CONFIGSERVICE_JAR
  ln $JAR_FILE $ADMINSERVICE_JAR
  chmod a+x $ADMINSERVICE_JAR

 export JAVA_OPTS="$SERVER_JAVA_OPTS -Deureka.instance.hostname=$config_host_name -Dlogging.file=./apollo-config-service.log -Dserver.port=$config_server_port -Dspring.datasource.url=$apollo_config_db_url -Dspring.datasource.username=$apollo_config_db_username -Dspring.datasource.password=$apollo_config_db_password"

  $CONFIGSERVICE_JAR start --configservice
  
  rc=$?
  if [[ $rc != 0 ]];
  then
    echo "Failed to start config service, return code: $rc. Please check $LOG_DIR\apollo-config-service.log for more information."
   exit $rc;
  fi

  printf "Waiting for config service startup"
  checkServerAlive $config_server_url

  rc=$?
  if [[ $rc != 0 ]];
  then
    printf "\nConfig service failed to start in $rc seconds! Please check $LOG_DIR\apollo-config-service.log for more information.\n"
   exit 1;
  fi

  printf "\nConfig service started. \n"

  echo "======================= Starting Admin Service ============================"
  echo "Admin service logging file is $LOG_DIR/apollo-admin-service.log"

  
  export JAVA_OPTS="$SERVER_JAVA_OPTS -Deureka.instance.hostname=$config_host_name -Dlogging.file=./apollo-admin-service.log -Dserver.port=$admin_server_port -Dspring.datasource.url=$apollo_config_db_url -Dspring.datasource.username=$apollo_config_db_username -Dspring.datasource.password=$apollo_config_db_password"

  $ADMINSERVICE_JAR start  --adminservice

  rc=$?
  if [[ $rc != 0 ]];
  then
    echo "Failed to start admin service, return code: $rc. Please check $LOG_DIR\apollo-admin-service.log for more information."
   exit $rc;
  fi


  printf "Waiting for admin service startup"
  checkServerAlive $admin_server_url

  rc=$?
  if [[ $rc != 0 ]];
  then
    printf "\nAdmin service failed to start in $rc seconds! Please check $LOG_DIR\apollo-admin-service.log for more information.\n"
   exit 1;
  fi

  printf "\nAdmin service started. \n"
#   echo "==== starting portal ===="
#   echo "Portal logging file is $PORTAL_LOG"
#   export JAVA_OPTS="$SERVER_JAVA_OPTS -Dlogging.file=./apollo-portal.log -Dserver.port=8070 -Dspring.datasource.url=$apollo_portal_db_url -Dspring.datasource.username=$apollo_portal_db_username -Dspring.datasource.password=$apollo_portal_db_password"

#   if [[ -f $PORTAL_JAR ]]; then
#     rm -rf $PORTAL_JAR
#   fi

#   ln $JAR_FILE $PORTAL_JAR
#   chmod a+x $PORTAL_JAR

#   $PORTAL_JAR start --portal

#   rc=$?
#   if [[ $rc != 0 ]];
#   then
#     echo "Failed to start portal, return code: $rc. Please check $PORTAL_LOG for more information."
# #   exit $rc;
#   fi

#   printf "Waiting for portal startup"
#   checkServerAlive $portal_url

#   rc=$?
#   if [[ $rc != 0 ]];
#   then
#     printf "\nPortal failed to start in $rc seconds! Please check $PORTAL_LOG for more information.\n"
# #   exit 1;
#   fi

#   printf "\nPortal started. You can visit $portal_url now!\n"
  
#   read -n1

# exit 0;
elif [ "$1" = "client" ] ; then
  if [ "$windows" == "1" ]; then
    java -classpath "$CLIENT_DIR;$CLIENT_JAR" $BASE_JAVA_OPTS SimpleApolloConfigDemo
  else
    java -classpath $CLIENT_DIR:$CLIENT_JAR $BASE_JAVA_OPTS SimpleApolloConfigDemo
  fi
# exit 0;
elif [ "$1" = "stop" ] ; then
  # echo "==== stopping portal ===="
  cd $LOG_DIR
  # ./$PORTAL_JAR_NAME stop


  echo "==== stopping config service ===="
  $CONFIGSERVICE_JAR stop
    echo "==== stopping admin service ===="
  $ADMINSERVICE_JAR stop
   
  read -n1

# exit 0;
else
  echo "Usage: build.sh ( commands ... )"
  echo "commands:"
  echo "  start         start services and portal"
  echo "  client        start client demo program"
  echo "  stop          stop services and portal"
# exit 1
fi

  read -n1
