NODE_ID=`nodejs client/getconf.js node_id`
TASK_TYPE=`nodejs client/getconf.js task_type`
X_FILE=`nodejs client/getconf.js x_auth`
SEL_ADDR=`nodejs client/getconf.js selenium_server`
SEL_PORT=`nodejs client/getconf.js selenium_port`
SEL_HOME=/tmp/$USER-$NODE_ID-$TASK_TYPE
SINGLE_LOCK=/tmp/awt-client.lock  # 1-sized semaphore for weak hosts
